" Warren's alternative version of ls. ls [-l] [name ...]
"
" When -l is used, you see
"
"    inum [dls][r-][w-][r-][w-] nlink uid size name
"
" with numbers in octal. All filenames need to be 8 characters
" long or less, or ls will crash when used with a7out. 

main:

   lac 017777           " Move five words past the argument word count
   tad d5		" so that AC points at the first argument
   dac argptr

argloop:
   lac 017777 i		" Do we have any arguments?
   sad d4
     jmp 1f		" No, so leave the argloop

   lac argptr i		" Is this one -l?
   sad minusell
     jmp setlong

   lac argptr		" It wasn't -l, so try to list it
   jms listit
   skp

setlong:
   dac longopt		" It was -l, so set longopt non-zero

   lac argptr		" Move the arg pointer up to the next one
   tad d4
   dac argptr

   -4
   tad 017777 i
   dac 017777 i		" Decrement the arg count and loop back
   jmp argloop

1: lac didprint		" Have we actually printed anything?
   sna
     jms listdir	" No, so list the current directory
    sys exit		" then exit


			" Given a pointer to a name in AC, list it.
			" If it's a dir, list the contents.
			" If it's a file, list just the file.
listit: 0
   dac 7f		" Stash the name's pointer in several places
   dac 8f
   lac statbufptr	" Get the name's details into the statbuf
   sys status; 7:0
   spa
     jmp error		" exit if the status call fails
   lac s.perm		" See if this is a directory
   and isdirmask
   sna
     jmp 1f
   jms listdir		" Yes, print the whole directory
   jmp listit i

1: lac 7b
   jms printentry	" Only a file, print it
   jmp listit i


listdir: 0		" List a whole directory
   sys open; 8:curdir; 0 " Open up the directory, curdir if no arguments
   spa
     jmp error
   dac fd		" Save the fd
   
fileloop:
   lac fd		" Read 64 words into the buffer from the input file
   sys read; buf; 64
   spa                  " Skip if result was >= 0
     jmp error          " Result was -ve, so error result
   sna                  " Skip if result was >0
     jmp fileend       	" Result was zero, so nothing left to read

   dac count		" Save the count of words read in
   lac inameptr		" Point nameptr at the base of the buffer
   dac nameptr

			" Each dir entry is 8 words. We need to print out the
			" filename which is in words 2 to 5. Word 1 is the inum.
entryloop:
   lac nameptr i	" Is the inode number zero?
   sna
     jmp nextentry	" Yes, move to the next directory entry

   lac nameptr		" Move up to the filename
   tad d1
   dac statfile		" Copy the pointer to the status call
   lac statbufptr	" Get the file's details into the statbuf
   sys status; statfile:0
   spa
     jmp error		" exit if the status call fails
   lac statfile
   jms printentry	" Now print it out

nextentry:
   lac nameptr		" Add 8 to the nameptr to move up to the next one
   tad d8
   dac nameptr
   -8
   tad count		" Decrement the count of words in the buffer by 8
   dac count
   sza			" Anything left in the buffer to print?
     jmp entryloop	" Yes, stuff left to print
   jmp fileloop		" Nothing in the buffer, try reading some more

fileend:
   lac fd		" Close the open file descriptor and return
   sys close
   jmp listdir i


printentry: 0		" Print out an entry from the statbuf and nameptr in AC
   dac statfile
   lac longopt		" Are we printing out in long format?
   sza
     jms printlong	" Yes, print out the i-node details
   lac statfile		" Now print out the file's name
   jms printname
   isz didprint
   jmp printentry i

			" Print out the i-node in long format
printlong: 0		
			" Ugly code. Improvements welcome!
   lac s.inum		" Print out the i-node number
   jms octal; -5
   lac s.perm		" See if this is a directory
   and isdirmask
   sna
     jmp 1f
   lac fd1
   sys write; d; 1	" Yes, print a d
   jmp 2f
1: lac s.perm		" Not a dir, see if its a large file
   and largemask
   sna			
     jmp 1f
   lac fd1
   sys write; l; 1	" Yes, print an l
   jmp 2f
1: lac fd1
   sys write; s; 1	" Not a dir, not large, print an s

2: lac s.perm		" Readable by owner?
   and ureadmask
   sna
     jmp 1f
   lac fd1
   sys write; r; 1	" Yes, print an r
   jmp 2f
1: lac fd1
   sys write; minus; 1	" No, print a - sign

2: lac s.perm		" Writable by owner?
   and uwritemask
   sna
     jmp 1f
   lac fd1
   sys write; w; 1	" Yes, print a w
   jmp 2f
1: lac fd1
   sys write; minus; 1	" No, print a - sign

2: lac s.perm		" Readable by other?
   and oreadmask
   sna
     jmp 1f
   lac fd1
   sys write; r; 1	" Yes, print an r
   jmp 2f
1: lac fd1
   sys write; minus; 1	" No, print a - sign

2: lac s.perm		" Writable by other?
   and owritemask
   sna
     jmp 1f
   lac fd1
   sys write; w; 1	" Yes, print a w
   jmp 2f
1: lac fd1
   sys write; minus; 1	" No, print a - sign

2: lac fd1
   sys write; space; 1	" Print a space

   lac s.nlinks		" Print the number of links out
			" but first make it positive
   cma
   tad d1
   jms octal; -2
   lac s.uid		" Print the user-id out
   jms octal; -3
   lac s.size		" Print the size out
   jms octal; -5
   jmp printlong i


			" Given a filename pointer in AC,
			" print it out with a newline
printname: 0
   dac 1f
   lac fd1
   sys write; 1:0; 4		" Write the filename out to stdout
   lac fd1
   sys write; newline; 1	" followed by a newline
   jmp printname i


			" Octal print code: This code borrowed from ds.s
octal: 0
   lmq			" Move the negative argument into the MQ
			" as we will use shifting to deal with the
			" number by shifting groups of 3 digits.

   lac d5		" By adding 5 to the negative count and
   tad octal i		" complementing it, we set the actual
   cma			" loop count up to 6 - count. So, if we
   dac c		" want to print 2 digits, we lose 6 - 2 = 4 digits
1:
   llss 3		" Lose top 3 bits of the MQ
   isz c		" Do we have any more to lose?
     jmp 1b		" Yes, keep looping
   lac octal i		" Save the actual number of print digits into c
   dac c		" as a negative number.
1:
   cla
   llss 3		" Shift 3 more bits into AC
   tad o60		" Add AC to ASCII '0'
   dac cbuf		" and print out the digit
   lac fd1
   sys write; cbuf; 1
   isz c		" Any more characters to print out?
     jmp 1b		" Yes, loop back
   lac fd1		" Print out a space
   sys write; space; 1
   isz octal		" Move return address 1 past the argument
   jmp octal i		" and return from subroutine

error:
   lac d1
   sys write; mes; 1	" followed by "?\n"
   sys exit

mes:
   077012               " String literal: " ?\n"

longopt: 0		" User set the -l option when this is 1
argptr:  0		" Pointer to the next argument
nameptr:	 0		" Pointer to files name
fd: 0			" File descriptor for the directory
d1: fd1: 1		" File descriptor 1
d4: 4
d5: 5
d7: 7
d8: 8
o40: 040
o60: 060
didprint: 0		" Did we print anything out?
count: 0		" Count of # of directory words read in
cbuf: 0			" Used to print out in the octal routing
c: .=.+1		" Loop counter for printing octal digits

" Input buffer for read
inameptr: buf			" Constant pointer to the buffer
buf: .=.+64			" Directory buffer
statbufptr: statbuf		" Pointer to the statbuf
statbuf:			" Status buffer fields below
s.perm: 0
s.blk1: 0
s.blk2: 0
s.blk3: 0
s.blk4: 0
s.blk5: 0
s.blk6: 0
s.blk7: 0
s.uid: 0
s.nlinks: 0
s.size: 0
s.uniq: 0
s.inum: 0
largemask:  0200000  		" large file, bigger than 4096 words
isdirmask:  000020  		" is a directory
ureadmask:  000010  		" user read
uwritemask: 000004		" user write
oreadmask:  000002  		" other read
owritemask: 000001		" other write

d: 0144				" ASCII characters: d, l, s, r, w, -, space, \n
l: 0154
s: 0163
r: 0162
w: 0167
minus: 055
space: 040
newline: 012

curdir: <. 040; 040040; 040040; 040040		" i.e. "."
minusell: <-l>
