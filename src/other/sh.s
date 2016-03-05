" -*-fundamental-*-
" sh -- a shell
" started by p budne 3/4/2016
" with code from cat.s, init.s, and looking at the v1 (pdp-11) shell

" BUG: XXX second char of second word being incremented?????

start:
" XXX take command line argument (script file to open), suppress prompt??
" NOTE!!! v0 init.s doesn't set up the argv at the top of memory,
" so the v0 shell may not have taken command line arguments!!!
" if non-interactive, "dzm prompt", jump to newcom

interactive:
   -1
   sys intrp			" make shell uninterruptable
   sys getuid
   sma				" <0?
    jmp newline			"  no, a mundane
   lac hash			" yes: superuser
   dac prompt			" change prompt

newline:
   lac d1; sys write; prompt; 1	" output prompt
newcom:
   dzm argc			" clear arg count
   dzm char			" clear saved char
   dzm infile			" clear input redirect file name
   dzm outfile			" clear output redirect file name
   lac iopt			" reset output pointer
   dac opt
   dac nextarg

newarg:
   -8				" save 8 chars
   dac bcount
   dzm redirect

   lac opt			" save start for print (TEMP)
   dac 8f
   dac nextarg

   jms blank			" skip whitespace
   sad o12			" newline?
    jmp eol			"  yes
   sad lt			" input redirect?
    jmp redirin
   sad gt			" output redirect?
    jmp redirout
   jmp 3f

redirin:			" saw <
   dac redirect			" flag redirect
   lac infilep
   dac opt
   dac 8f			" TEMP
   jmp newchar			" v1 behavior? no whitespace eater

redirout:			" saw >
   dac redirect			" flag redirect
   lac outfilep
   dac opt
   dac 8f			" TEMP
   " v1 behavior? no whitespace eater
   " fall

newchar:
   jms getc
   sad o40			" space?
    jmp ws			"  yes
   sad o12
    jmp ws
3: jms putc			" save
   isz bcount			" loop unless full
    jmp newchar

" here after 8 chars: discard until terminator seen
discard:
   jms getc
   dac char
   sad o4
    jmp eof
   sad o12
    jmp eoname
   sad o40
    jmp eoname
   jmp discard

" here with EOF in command
eof:
   sys exit			" quit, for now?

" name ended (short) with whitespace or newline
" pad out last name to 8 with spaces
ws:
   dac char
1: lac o40
   jms putc			" no: copy into argv
   isz bcount			" loop until full
    jmp 1b

" saw end of name
eoname:
   lac redirect
   sza
    jmp 1f			" last name was a redirect file, skip increment

   isz argc			" increment argc
   lac nextarg
   tad d4			" advance nextarg
   dac nextarg

1f:
" TEMP output each name on a line:
   lac d1; sys write; 8:0; 4
   lac d1; sys write; nl; 1

   lac nextarg
   dac opt
   dac 8b		" TEMP

   lac char
   sad o12
    jmp eol

   -maxargs
   tad argc
   sza
    jmp newarg

" here at end of line (or too many args)
eol:
" XXX check for "chdir", execute "in-process"
" XXX if not, fork (child code below)
" XXX parent wait for child (unless &)
   jmp newline

child:
   cla
   sad infile
    jmp 1f
   sys close			" close fd 0
   sys open; infile; 0		" open redirected
   spa
     jmp inerror
   cla				" XXX should still be zero!
1: sad outfile
    jmp 1f
   lac d1
   sys close			" close fd 1
" XXXXXXXXXX use creat!!!?
   sys open; outfile; 1		" open redirected
   spa
     jmp outerror

" here to exec filename at argv, code adapted from init.s
" right now always look in "system" directory.
" but on error, check local directory?
1: sys unlink; exectemp
   sys link; system; argv0; exectemp
   spa
     jmp nofile
   sys open; exectemp; 0
   spa
     jmp error
   sys unlink; exectemp
   jmp 1f

nofile:			" not found in "system"
   sys open; argv0; 0	" try cwd
   spa
     jmp cmderr
1:
   law bootloc-1	" Copy the code at the boot label below
   dac 9		" up to high memory
   law boot-1
   dac 8
1:
   lac 8 i
   dac 9 i
   sza			" Stop copying when we hit the 0 marker
     jmp 1b
   jmp bootloc		" and then jump to the code

boot:
   lac d2		" Load fd2 (the opened shell file)
   lmq			" Save the fd into MQ
   sys read; userbase; userlen	" read executable in
   lacq			" Get the fd back and close the file
   sys close	
   jmp userbase		" and jump to the beginning of the executable
   0			" 0 marks the end of the code, used by the copy loop
bootlen=.-boot		" length of bootstrap

inerror:
  law infile
  jmp error
outerror:
  law outfile
  skp
cmderr:
   law argv0
error:				" here for error in child
  dac 1f
  lac d1	" XXX stdout may be redirected!!!!
  sys write qmsp; 1
  lac d1
  sys write; 1: 0; 4
  lac d1
  sys write; nl; 1
" XXX smes to shell???
  sys exit

" end code from init.s
" ================

blank: 0
1: jms getc
   sad o40
    jmp 1b
   jmp blank i

" give skip return if AC *NOT* a command delimiter
delim: 0
   sad o12
    jmp delim i
   isz delim
   jmp delim i

" ****************************************************************
" from cat.s
getc: 0
   lac ipt			" Load the pointer to the next word in the buffer
   sad eipt
     jmp 1f			" We've reached the end of the buffer, so read more
   dac 2f			" Save the pointer
   add o400000			" Flip the msb and save into ipt
   dac ipt
   ral				" Move the msb into the link register
   lac 2f i			" Load the word from the buffer
   szl				" Skip if this is the second character in the word
     lrss 9			" It's the first char, shift down the top character
   and o177			" Keep the lowest 7 bits
   sna
     jmp getc+1			" Skip a NUL characters and read another one
   jmp getc i			" Return the character from the subroutine

1:
   cla				" Buffer is empty, read another 64 characters
   sys read; ibuf; 64
   sna
     jmp 1f			" No characters were read in
   tad iipt			" Add the word count to the base of the buffer
   dac eipt			" and store in the end buffer pointer
   lac iipt			" Reset the ipt to the base of the buffer
   dac ipt
   jmp getc+1			" and loop back to get one character
1:
   lac o4			" No character, return with ctrl-D
   jmp getc i			" return from subroutine

putc: 0
   and o177			" Keep the lowest 7 bits and save into 2f+1
   dac 2f+1
   lac opt			" Save the pointer to the empty buffer
   dac 2f			" position to 2f
   add o400000			" Flip the msb and save back into opt
   dac opt			" This also has the effect of incrementing
				" the opt pointer every second addition!

   spa				" If the bit was set, we already have one
     jmp 1f			" character at 2f+1. If no previous character,
   lac 2f i			" merge the old and new character together
   xor 2f+1
   jmp 3f			" and go to the "save it in buffer" code
1:
   lac 2f+1			" Move the character up into the top half
   alss 9
3:
   dac 2f i			" Save the word into the buffer
   jmp putc i			" No, so return (more room still in the buffer)

2: 0;0				" Current input and output word pointers
ipt: 0				" Current input buffer base
eipt: 0				" Pointer to end of data read in input buffer
iipt: ibuf
ibuf: .=.+64


" end from cat.s
" ****************************************************************
" constants
d1: 1
d2: 2
o4:d4: 4
o12:nl: 012	" newline
o40:sp: 040	" space
o74:lt: 074
o76:gt: 076
o177: 0177			" ASCII mask
o400000: 0400000		" Msb toggle bit

hash: <#> " superuser prompt
qmsp: <? > "

system:
   <sy>;<st>;<em>; 040040

exectemp:
   <ex>;<ec>;<te><mp>		" temporary link for file being exec'ed

" TEMP FOR DEBUG:
star: <*> "

" ################ variables

prompt: <@> " v1 prompt
pid: 0				" "other" pid
char: 0				" white space char
redirect: 0			" last file was a redirect (lt or gt)
bcount: 0			" byte counter for current filename

iopt: argc-4			" initial value for nextarg, opt
nextarg: 0			" next slot in argv to fill
opt: 0				" "output pointer" (may point to in/outfile)

infilep: infile
outfilep: outfile

outfile: .=.+4			" buffer for output redirect file name
infile: .=.+4			" buffer for input redirect file name

" == high memory
userbase=010000
userlen=userbase-bootloc	" max executable
argptr=017777			" last word points to argc + argv data
" leave room for maxargs items of 4 words each
maxargs=8
argc=argptr-maxargs-maxargs-maxargs-maxargs
" 4 word blocks follow argc:
argv0=argc+1

" "bootstrap" (reads executable into userbase) below argc:
bootloc=argc-bootlen		" location of bootstrap
