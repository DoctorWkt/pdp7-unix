" Warren's cat program: cat [arg1 arg2 ...]
"
" Because the a7out simulator currently doesn't deal with ASCII files,
" here is how you can test it:
" ./as7 wktcat.s > a.out
"
" ./a7out a.out > z1
" <type some lines and end in ctrl-D>
"
" ./a7out a.out z1 z1
" <the text you typed in will be displayed twice>
"
" Also, the current coding is hideous and needs refactoring.
" I'm still coming to grips with PDP-7 assembly code.


main:
   " Load the pointer pointer in 017777 to see if we have any arguments
   lac 017777 i
   sza			" No args, so copy stdin to stdout
     jmp catfiles	" Yes args, so deal with them below

" This section copies from standard input to standard output
stdinout:
   " Read five words into the buffer from stdin
   " Five was chosen arbitrarily
   lac d0
   sys read; buf; 5
   spa			" Skip if result was >= 0
     jmp error		" Result was -ve, so error result
   sna			" Skip if result was >0
     jmp end		" Result was zero, so nothing left to read

   " Save the count of words read in
   dac 1f

   " Write five words from the buffer to stdout
   lac d1
   sys write; buf; 1:0

   " and loop back for more words to read
   jmp stdinout

" This section opens files, and copies their contents to standard output
catfiles:
   " We start with AC pointing to an argument. Save it at label 1f
   dac 1f

   " Open the file and get the fd into AC
   sys open; 1:0; 0; 0
   spa
     jmp noopen		" Bad fd, exit with an error message
   dac fd		" Save the file descriptor

fileloop:
   " Read five words into the buffer from the input file
   lac fd
   sys read; buf; 5
   spa			" Skip if result was >= 0
     jmp error		" Result was -ve, so error result
   sna			" Skip if result was >0
     jmp fileend	" Result was zero, so nothing left to read

   " Save the count of words read in
   dac 1f

   " Write five words from the buffer to stdout
   lac d1
   sys write; buf; 1:0

   " and loop back for more words to read
   jmp fileloop

fileend:
   " Close the open file descriptor
   lac fd
   sys close

   " Load and increment the 017777 pointer
   lac 017777
   tad d1
   dac 017777

   " Load the pointer pointer in 017777 to see if we have any more arguments
   lac 017777 i
   sna			" No args, so end the program
     jmp end
   jmp catfiles		" Otherwise loop back to cat this file

end:
   " exit
   sys exit

noopen:
   " Print an "err open" string and exit
   lac d1
   sys write; noopenstr; 5
   sys exit

noopenstr:
   <er>;<r 040;<op>;<en>;012000

error:
   " Print an "err read" string and exit
   lac d1
   sys write; noreadstr; 5
   sys exit

noreadstr:
   <er>;<r 040;<re>;<ad>;012000

fd: 0		" fd of the open file
d0: 0		" Constants 0 and 1
d1: 1

" Input buffer for read
buf: 0; 0; 0; 0; 0
