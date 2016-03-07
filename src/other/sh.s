" -*-fundamental-*-
" sh -- a shell
" started by p budne 3/4/2016
" with code from cat.s, init.s, and looking at the v1 (pdp-11) shell

" XXX cat.s seems to write error output on fd 8

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
   dzm char			" clear saved char
   dzm infile			" clear input redirect file name
   dzm outfile			" clear output redirect file name
   lac iopt			" reset output pointer
   dac opt
   dac nextarg

" reset high memory
   dzm argc			" clear arg count
   lac argcptr
   dac argptr
   dzm argv0			" clear out argv0 for chdir comparison
   dzm argv0+1
   dzm argv0+2

newarg:
   -8				" save 8 chars
   dac bcount
   dzm redirect

   lac opt			" save start for print (TEMP)
   dac nextarg

   jms blank			" skip whitespace
   jms delim			" newline?
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
   jmp newchar			" v1 behavior? no whitespace eater

redirout:			" saw >
   dac redirect			" flag redirect
   lac outfilep
   dac opt
   " v1 behavior? no whitespace eater!
   " fall

newchar:
   jms getc
   sad o40			" space?
    jmp ws			"  yes
   jms delim
    jmp eoname
3: jms putc			" save
   isz bcount			" loop unless full
    jmp newchar

" here after 8 chars: discard until terminator seen
discard:
   jms getc
   dac char
   sad o4
    jmp eof
   jms delim			" end of line?
    jmp eoname
   sad o40
    jmp eoname
   jmp discard

" here with EOF in command: process command?
eof:
   sys exit			" quit, for now?

" name ended (short) with whitespace or newline
" pad out last name to 8 with spaces
ws:
   dac char			" save terminator
1: lac o40
   jms putc			" no: copy into argv
   isz bcount			" loop until full
    jmp 1b

" saw end of name
eoname:
   dac char
   lac redirect
   sza
    jmp 2f			" last name was a redirect file, skip increment

   lac argc			" increment argc
   tad d4
   dac argc
   lac nextarg
   tad d4			" advance nextarg
   dac nextarg

2:
   dzm redirect			" clear redirect flag
   lac nextarg
   dac opt

   lac char
   jms delim
    jmp eol

   -maxargs
   tad argc
   sza
    jmp newarg

" too many args, (complain?).  for now eat rest of line 
4: jms getc
   jms delim
    skp
     jmp 4b
   lac d1; sys write; toomany; ltoomany
   jmp newline

" here at end of line
eol:
   sad delimchar		" save eol character
   lac argc			" check for empty command line
   sna				" get anything?
    jmp 2f			" no, go back for another

" check for built-in "chdir" command
   lac argv0
   sad chdirstr
    skp
     jmp 1f
   lac argv0+1
   sad chdirstr+1
    skp
     jmp 1f
   lac argv0+2
   sad chdirstr+2
    jmp changedir

1:
" comment these out to test "exec"
   sys fork
    jmp parent

" here in child
   lac d2; sys close		" close fd 2
   sys unlink; exectemp		" remove temp file

" try to link binary from "system" directory to "exectemp" file
"   sys link; system; argv0; exectemp
"   spa
"     jmp notsys
"   sys open; exectemp; 0
"   spa
"     jmp error
"   sys unlink; exectemp
"   jmp 1f
"notsys:			" not found in "system"

   sys open; argv0; 0		" try cwd
   spa
     jmp cmderr

   cla				" check for input redirection
   sad infile
    jmp 1f
   sys close			" close fd 0
   sys open; infile; 0		" open redirected
   spa sna
     jmp inerror
   cla
1: sad outfile
    jmp exec
   lac d1; sys close		" close fd 1
   lac o17
   sys creat; outfile		" open output redirect
   spa
     jmp outerror

" here to "exec" file open on fd 2, adapted from init.s
exec:
   law boot-1			" Get source addr
   dac 8			" set up index 8 (pre-increments)
   law bootloc-1		" Copy "boot" code into high memory
   dac 9			" set up index 9 (pre-increments)
1: lac 8 i
   dac 9 i
   isz bootcount		" can only do this once!
     jmp 1b
   jmp bootloc			" and then jump to the code

" copied up to bootloc in high memory (below argc)
boot:
   lac d2			" Load fd 2 (the opened executable)
   lmq				" Save the fd into MQ
   sys read; userbase; userlen	" read executable in
   lacq				" Get the fd back and close the file
   sys close	
   jmp userbase			" and jump to the beginning of the executable
bootlen=.-boot			" length of bootstrap

bootcount: -bootlen		" isz loop count for bootstrap copy

" error in child process:
inerror:			" error opening input redirection
  lac infilep
  jmp error
outerror:			" error opening new stdout (stdout closed!)
  lac outfilep
  skp
cmderr:				" error opening command
   lac argv0p
error:				" error in child: filename pointer in AC
  dac 1f			" save filename to complain about
  lac d1; sys write; 1: 0; 4
  lac d1; sys write; qmnl; 1
  lac d2; sys close
  sys exit

" chdir command: executed in shell process
changedir:
" XXX check if argc == 4 (no directories) and complain??
   lac argv0p
   skp
1:  lac 0f			" increment argvp
   tad d4
   sad 0f
   -4				" decrement argc
   tad argc
   dac argc
   sna				" done?
    jmp 2f			"  yes: join parent code
   sys chdir; 0:0
   sma				" error?
    jmp 1b			"  no: look for another directory

" chdir call failed
   lac 0b
   dac 0f
   lac d1; sys write; 0:0; 4
   lac d1; sys write; qmnl; 1
   jmp 2f			" join parent code

" here in parent, child pid in AC
parent:
"	https://www.bell-labs.com/usr/dmr/www/hist.html
"	The message facility was used as follows: the parent shell, after
"	creating a process to execute a command, sent a message to the new
"	process by smes; when the command terminated (assuming it did not
"	try to read any messages) the shell's blocked smes call returned an
"	error indication that the target process did not exist. Thus the
"	shell's smes became, in effect, the equivalent of wait.
   dac pid
   lac delimchar
   sad o46			" ampersand?
    jmp newcom			"  yes: go back without wait
   lac pid
   sys smes			" hang until child exits
2: lac delimchar
   sad o73			" semi?
    jmp newcom			"  yes: look for another command w/o prompt
   jmp newline			" no: output prompt

" ================
" subroutines

" eat spaces
" v1 routine name:
blank: 0
1: jms getc
   sad o40
    jmp 1b
   jmp blank i

" give skip return if AC *NOT* a command delimiter
" v1 routine name:
delim: 0
   sad o12			" newline
    jmp delim i
   sad o46			" ampersand
    jmp delim i
   sad o73			" semi
    jmp delim i
   isz delim			" ran the gauntlet: skip home
   jmp delim i

" from cat.s
getc: 0
   lac ipt			" Load pointer to next word in the buffer
   sad eipt
     jmp 1f			" end of the buffer, so read more
   dac 2f			" Save the pointer
   add o400000			" flip MSB, increment pointer on overflow
   dac ipt
   ral				" Move the msb into the link register
   lac 2f i			" Load the word from the buffer
   szl				" Skip if second character in word
     lrss 9			"  first char: shift down the top character
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

" literals
d1: 1
d2: 2
o4:d4: 4
o12: 012			" newline
o17: 017
o40: 040			" space
o46: 046			" ampersand
o73: 046			" semi
o74:lt: 074			" <
o76:gt: 076			" >
o177: 0177			" 7-bit (ASCII) mask
o400000: 0400000		" MSB

hash: <#> " superuser prompt
qmnl: <? 012			" question mark, newline

system:
   <sy>;<st>;<em>; 040040

exectemp:
   <ex>;<ec>;<te>;<mp>		" temporary link for file being exec'ed

chdirstr:
   <ch>;<di>;<r 040

" TEMP FOR DEBUG:
star: <*> "

toomany: <to>;<o> ;<ma>;<ny>;< a>;<rg>;<s 012
ltoomany=.-toomany

" ################ variables

prompt: <@> " v1 prompt
pid: 0				" "other" pid
char: 0				" white space char
redirect: 0			" last file was a redirect (lt or gt)
bcount: 0			" byte counter for current filename
delimchar: 0			" character that terminated line

iopt:argv0p: argv0		" initial value for nextarg, opt
nextarg: 0			" next slot in argv to fill
opt: 0				" "output pointer" (may point to in/outfile)

infilep: infile
outfilep: outfile

outfile: .=.+4			" buffer for output redirect file name
infile: .=.+4			" buffer for input redirect file name

argcptr: argc

" leave room for maxargs items of 4 words each
maxargs=8

userbase=010000			" user starts at 4K
argptr=017777			" last word points to argc + argv data
argc=argptr-maxargs-maxargs-maxargs-maxargs-1 " argc followed by argv

" arguments in 4 word blocks follow argc
argv0=argc+1

" "bootstrap" (reads executable into userbase) JUST below argc
bootloc=argc-bootlen		" location of bootstrap

userlen=bootloc-userbase	" max executable

