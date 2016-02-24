" cat

   lac 017777 i			" exit if four argument words only?
   sad d4
   jmp nofiles
   lac 017777
   tad d1			" why not tad d5 (add 5)?
   tad d4
   dac name			" name = *(017777) + 5

loop:
   sys open; name; 0; 0		" open file, get fd back
   spa				" exit if fd == -1
   jmp badfile
   dac fi			" save file descriptor in fi

1:
   jms getc			" get a character in AC
   sad o4
   jmp 1f
   jms putc			" write the character on stdout
   jmp 1b

1:
   lac fi
   sys close

loop1:
   -4
   tad 017777 i
   dac 017777 i
   sad d4
   jmp done
   lac name
   tad d4
   dac name
   jmp loop

badfile:
   lac name
   dac 1f
   lac d8
   sys write; 1:0; 4
   lac d8
   sys write; 1f; 2
   jmp loop1

1: 040;077012
nofiles:
   lac d8
   sys write; 1f; 5		" write 5 words to fd 8?
   sys exit			" and exit

1: <no>; 040;  <fi>;<le>;<s 012

done:
   lac noc
   sns
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
   lac fo			" load fd 1, stdout
   sys write; iopt+1; 1:..
   sys exit

getc: 0
   lac ipt
   sad eipt
   jmp 1f
   dac 1f
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
   lac 64
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
name: 0				" not in the original

d1: 1				" octal and decimal constants
o4:d4: 4
d8: 8
o400000: 0400000
o177: 0177
d128: 128
