" -*-fundamental-*-
" pbsh -- a shell
" started by p budne 3/4/2016
" with code from init.s, cat.s and looking at the v1 (pdp-11) shell

" In particular, the newline/newcom/newarg/newchar processing loop(s)
" are copied from the v1 shell:
" redirection must occur at the start of a name (after whitespace)

" includes ';' and '&' (unknown if available in v0 shell)
" does NOT (yet) include quoting (backslash or single quote)
" no "globbing" (performed by /etc/glob in v1 shell)

" v0 cat.s seems to write error output on fd 8, *BUT* shell doesn't
" know what device is on stdout (passed by init, and init doesn't pass
" fd 8), and there isn't a "dup" call, nor does init appear to be an
" "indirect" device like /dev/tty, nor does init make an equivalent link!!

" Arguments for new processes are located at the end of memory.
" Location 17777 points to a word with the argument count (argc),
" followed by blocks of four words with (filename) arguments.
" Currently leave room for ONLY maxargs items.
maxargs=8

" v1 shell expects "-" as argument from init or login, will read
" filename passed as argument.  *BUT* v0 init.s doesn't set up the
" argv at the top of memory, so the v0 shell may not have taken
" command line arguments!!!

   lac d1
   sys intrp			" make shell uninterruptable
   sys getuid
   sma				" <0?
    jmp newline			"  no
   lac hash			" yes: superuser
   dac prompt			" change prompt

newline:
   lac d1; sys write; prompt; 1	" output prompt
   jms rline			" read line into ibuf
   lac iipt
   dac ipt
newcom:
   dzm char			" clear saved char
   dzm infile			" clear input redirect file name
   dzm outfile			" clear output redirect file name
   lac iopt			" reset output buffer pointer
   dac opt
   dac nextarg

" reset high memory
   dzm argc			" clear arg count
   lac argcptr			" (re) set arg pointer
   dac argptr
   dzm argv0			" clear out argv0 for chdir comparison
   dzm argv0+1
   dzm argv0+2

" NOTE! behavior copied from v1 shell!!!
" "improvements" here may be non-historic!!
newarg:
   -8				" save 8 chars
   dac bcount
   dzm redirect			" clear redirect flag

   lac opt			" save start for print (TEMP)
   dac nextarg

   jms blank			" skip whitespace
   jms delim			" command sep?
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
   jmp newchar

redirout:			" saw >
   dac redirect			" flag redirect
   lac outfilep
   dac opt
   " fall

newchar:
   jms getc
   sad o40			" space?
    jmp eoname			"  yes
   jms delim
    jmp eoname
3: jms putc			" save
   isz bcount			" loop unless full
    jmp newchar

" here after 8 chars: discard until terminator seen
discard:
   jms getc
   jms delim			" end of line?
    jmp eoname
   sad o40
    jmp eoname
   jmp discard

" name ended (short) with whitespace or delim
" pad out last name to 8 with spaces
" XXX check if ANYTHING read
eoname:
   dac char			" save terminator
1: lac o40
   jms putc			" no: copy into argv
   isz bcount			" loop until full
    jmp 1b

" saw end of name
2: lac redirect
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

   lac argc
   sad maxargwords
    skp
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
" comment these out to test "exec" w/o fork
   sys fork
    jmp parent

   sys open; argv0; 0		" try cwd (no link required)
   sma
    jmp 1f
   " jmp cmderr

   sys unlink; exectemp		" remove old temp file, if any
   sys link; system; argv0; exectemp
   spa
     jmp cmderr
   sys open; exectemp; 0
   spa
     jmp cmderr
   dac cmdfd
   sys unlink; exectemp
   skp

1:  dac cmdfd			" save command file descriptor
   cla				" check for input redirection
   sad infile			" input redirct?
    jmp 1f			"  no
   sys close			" close fd 0
   sys open; infile; 0		" open redirected
   spa sna
    jmp inerror
   cla
1: sad outfile			" output redirec?
    jmp exec			"  no
   lac d1; sys close		" close fd 1
   lac o17; sys creat; outfile	" open output redirect
   spa
    jmp outerror

" here to "exec" file open on cmdfd, adapted from init.s
exec:
   law boot-1			" Get source addr
   dac 8			" set up index (pre-increments)
   law bootloc-1		" Copy "boot" code into high memory
   dac 9			" set up index
   -bootlen			" isz loop count for bootstrap copy
   dac bootcount
1: lac 8 i
   dac 9 i
   isz bootcount		" can only do this once!
     jmp 1b
   lac cmdfd			" get fd for the executable
   lmq				" Save the fd into MQ
   jmp bootloc			" and then jump to the code

" copied up to bootloc in high memory (below argc)
boot:
   sys read; userbase; userlen	" read executable in
   lacq				" Get the fd back and close the file
   sys close			" close command file
   jmp userbase			" and jump to the beginning of the executable
bootlen=.-boot			" length of bootstrap

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
  lac d2; sys close		" close executable, if any
  sys exit

" chdir command: executed in shell process
changedir:
" XXX check if argc == 4 (no directories) and complain??
   lac argv0p
   skp
1:  lac 0f			" increment argvp
   tad d4
   dac 0f
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
"
"	PLB: The "exit" system call code apears to "fall" into the
"	rmes code So Dennis' memory of what the shell did may have
"	been correct, but not for the reason he remembered.
   dac pid			" save child pid
   lac delimchar		" get command delimiter
   sad o46			" ampersand?
    jmp newcom			"  yes: go back without wait
   lac pid			" no: get pid
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

" get character from ibuf
getc: 0
   lac ipt i		" fetch char
   isz ipt		" increment pointer
   jmp getc i

" from init.s rline: read line from tty into ibuf
" (store one character per word)
rline: 0
   law ibuf-1		" Store ibuf pointer in location 8
   dac 8
1:
   cla; sys read; char; 1 " Read in one character from stdin
   sna			" read ok?
    jmp quit		" no
   lac char
   lrss 9		" Get it and shift down 9 bits
   sad o100		" '@' (kill) character?
     jmp rline+1	"  yes: start from scratch
   sad o43		" '#' (erase) character?
     jmp 2f		"  yes: handle below

   dac 8 i		" Store the character in the buffer
   sad o12		" Newline?
     jmp rline i	"  yes: return
   jmp 1b		" no: keep going
2:
   law ibuf-1		" # handling. Do nothing if at start of the buffer
   sad 8
     jmp 1b		" and loop back
   -1
   tad 8		" Otherwise, move the pointer in location 8 back one
   dac 8
   jmp 1b		" and loop back

quit:
   lac d1; sys smes	" wake up init
   sys exit

" copied from cat.s:
putc: 0
   and o177			" Keep the lowest 7 bits and save into 2f+1
   dac 2f+1
   lac opt			" get output buffer pos
   dac 2f			" save
   add o400000			" Flip the msb (advance) and save back into opt
   dac opt
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

2: 0;0				" pointer, char

" literals
d1: 1
d2: 2
o4:d4: 4
o12: 012			" newline
o17: 017
o40: 040			" space
o43: 043			" #
o46: 046			" ampersand
o73: 046			" semi
o74:lt: 074			" <
o76:gt: 076			" >
o100: 0100			" @
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

maxargwords: maxargs+maxargs+maxargs+maxargs
argcptr: argc

infilep: infile
outfilep: outfile

iipt: ibuf
iopt:argv0p: argv0		" initial value for nextarg, opt

" ################ variables

prompt: <@ 040			" v1 prompt!

redirect: .=.+1			" last file was a redirect (lt or gt)
nextarg: .=.+1			" next slot in argv to fill
bcount: .=.+1			" byte counter for current filename
opt: .=.+1			" "output pointer" (may point to in/outfile or into argv)
delimchar: .=.+1		" character that terminated line
char: .=.+1			" char that terminated word

outfile: .=.+4			" buffer for output redirect file name
infile: .=.+4			" buffer for input redirect file name
pid: .=.+1			" "other" pid
cmdfd: .=.+1			" fd for executable
bootcount: .=.+1		" loop count for "boot" copy

ipt: .=.+1			" input buf pointer
ibuf:				" input line stored here, one character per word

userbase=010000			" user starts at 4K
argptr=017777			" last word points to argc + argv data
argc=argptr-maxargs-maxargs-maxargs-maxargs-1 " argc followed by argv

" arguments in 4 word blocks follow argc
argv0=argc+1

" "bootstrap" (reads executable into userbase) JUST below argc
bootloc=argc-bootlen		" location of bootstrap

userlen=bootloc-userbase	" max executable
