" Warren's version of ls. Simply print out the names in the current directory

main:
   sys open; curdir; 0		" Open up the currect directory
   spa
     sys exit			" Unable, so die now
   dac fd			" Save the fd
   
fileloop:
   " Read 64 words into the buffer from the input file
   lac fd
   sys read; buf; 64
   spa                  " Skip if result was >= 0
     jmp fileend        " Result was -ve, so error result
   sna                  " Skip if result was >0
     jmp fileend        " Result was zero, so nothing left to read

   " Save the count of words read in
   dac count
   lac ibufptr		" Point bufptr at the base of the buffer
   dac bufptr

printloop:
   lac d1
   sys write; bufptr:0; 4	" Write a filename out to stdout
   lac d1
   sys write; newline; 1	" followed by a newline

   lac bufptr		" Add 4 to the bufptr
   tad d4
   dac bufptr
   -4
   tad count		" Decrement the count of words by 4
   dac count
   sza			" Anything left in the buffer to print?
     jmp printloop	" Yes, stuff left to print
   jmp fileloop		" Nothing in the buffer, try reading some more

fileend:
   " Close the open file descriptor and exit
   lac fd
   sys close
   sys exit
   
curdir: <. 040; 040040; 040040; 040040		" i.e. "."
newline: 012000

fd: 0
d1: 1				" stdout fd
d4: 4
count: 0

" Input buffer for read
ibufptr: buf			" Constant pointer to the buffer
buf: .=.+64
