" cat: cat [arg1 arg2 ...]

   " Load the pointer pointer in 017777 to see if we have any arguments
   lac 017777 i
   sad d4			" Skip if we have more than four argument words
     jmp nofiles		" Only four argument words, so no arguments
   lac 017777			" Move five words past the argument word count
   tad d1			" so that AC points at the first argument
   tad d4			" and save the pointer in name
   dac name

loop:
   sys open; name:0; 0;		" Open file, get fd back
   spa
     jmp badfile		" Negative fd, exit with an error message
   dac fi			" save file descriptor in fi

1:
   jms getc			" get a character in AC
   sad o4
     jmp 1f
   jms putc			" write the character on stdout
   jmp 1b

1:
   lac fi			" Close the file descriptor in fi
   sys close

loop1:
   -4
   tad 017777 i			" Subtract 4 from the count of argument words
   dac 017777 i
   sad d4			" Is the value 4, i.e. no args left?
     jmp done			" Yes, so exit

   lac name			" Still an argument, so move up
   tad d4			" to the next filename argument
   dac name
   jmp loop			" and loop back to cat this file

badfile:
   lac name			" Get the pointer to the filename
   dac 1f			" Store it in 1f below
   lac d8			" Load fd 8 which is stderr
   sys write; 1:0; 4		" Write the four words of the filename
   lac d8
   sys write; 1f; 2		" and then write " ?\n"
   jmp loop1			" Now try doing the next argument

1: 040;077012			" String literal: " ?\n"

nofiles:
   lac d8
   sys write; 1f; 5		" Write "No files\n" to stderr
   sys exit			" and exit

1: <no>; 040;  <fi>;<le>;<s 012

done:
   lac noc
   sna
     sys exit
   and d1
   sna cla
     jmp 1f
   jms putc
   jmp done
1:
   lac noc
   rcr
   dac 1f
   lac fo			" Load fd 1, stdout
   sys write; iopt+1; 1
   sys exit

getc: 0
   lac ipt
   sad eipt
     jmp 1f
   dac 2f
   add o400000
   dac ipt
   ral
   lac 2f i
   szl
   lrss 9
   and o177			" keep the lowest 7 bits
   sna
     jmp getc+1
   jmp getc i			" return from subroutine
1:
   lac fi
   sys read; iipt+1; 64
   sna
     jmp 1f
   tad iipt
   dac eipt
   lac iipt
   dac ipt
   jmp getc+1
1:
   lac o4
   jmp getc i			" return from subroutine

putc: 0
   and o177			" keep the lowest 7 bits
   dac 2f+1
   lac opt
   dac 2f
   add o400000
   dac opt
   spa
     jmp 1f
   lac 2f i
   xor 2f+1
   jmp 3f
1:
   lac 2f+1
   alss 9
3:
   dac 2f i
   isz noc
   lac noc
   sad d128
     skp
   jmp putc i
   lac fo			" load fd 1, stdout
   sys write; iopt+1; 64
   lac iopt
   dac opt
   dzm noc
   jmp putc i

2: 0;0
ipt: 0
eipt: 0
iipt: .+1; .=.+64		" 64 word input buffer
fi: 0
opt: .+2
iopt: .+1; .=.+64		" 64 word output buffer
noc: 0
fo: 1				" output file descriptor, fd 1 is stdout

d1: 1				" octal and decimal constants
o4:d4: 4
d8: 8
o400000: 0400000
o177: 0177
d128: 128
