" init

   -1
   sys intrp
   jms init1			" Fork the first child connected to ttyin/ttyout
   jms init2			" Fork the second child connected to keyboard/display
1:
   sys rmes			" Wait for a child to exit
   sad pid1
     jmp 1f			" It was child 1, so jump to 1f and restart it
   sad pid2
     jms init2			" It was child 2, so restart it
   jmp 1			" and loop back. XXX: weird use of 1: not 1b. I don't like it!
1:
   jms init1
   jmp 1			" Weird use of 1: not 1b. I don't like it!

init1: 0
   sys fork			" Fork a child process
     jmp 1f
   sys open; ttyin; 0		" which opens the ttyin
   sys open; ttyout; 1		" and ttyout files, and
   jmp login			" waits for a user to log in
1:
   dac pid1			" Parent stores childs pid in pid1
   jmp init1 i			" and returns

init2: 0
   sys fork			" Fork a child process
     jmp 1f
   sys open; keybd; 0		" which opens the keyboard
   sys open; displ; 1		" and display files, and
   jmp login			" waits for a user to log in
1:
   dac pid2			" Parent stores childs pid in pid2
   jmp init2 i			" and returns

login:
   -1
   sys intrp
   sys open; password; 0	" Open the passwd file
   lac d1
   sys write; m1; m1s		" Write "\nlogin:" on the terminal
   jms rline			" and read the user's username
   lac ebufp
   dac tal
1:
   jms gline
   law ibuf-1
   dac 8
   law obuf-1
   dac 9
2:
   lac 8 i
   sac o12
   lac o72
   sad 9 i
     skp
   jmp 1b
   sad o72
     skp
   jmp 2b
   lac 9 i
   sad o72
     jmp 1f
   -1
   tad 9
   dac 9
   lac d1
   sys write; m3; m3s	" Write "password: " on the terminal
   jms rline		" and read the user's password
   law ibuf-1
   dac 8
2:
   lac 8 i
   sad o12
     lac o72
   sad 9 i
     skp
   jmp error
   sad o72
     skp
   jmp 2b
1:
   dzm nchar
   law dir-1
   dac 8
1:
   lac 9 i
   sad o72
     jmp 1f
   dac char
   lac nchar
   sza
     jmp 2f
   lac char
   alss 9
   xor o40
   dac 8 i
   dac nchar
   jmp 1b
2:
   lac 8
   dac nchar
   lac nchar i
   and o777000
   xor char
   dac nchar i
   dzm nchar
   jmp 1b
1:
   dzm nchar
1:
   lac 9 i
   sad o12
     jmp 2f
   tad om60
   lmq
   lac nchar
   cll; als 3
   omq
   dac nchar
   jmp 1b
2:
   lac nchar
   sys setuid		" Set the user's user-id
   sys chdir; dd	" and change into the "dd" directory
   sys chdir; dir

   lac d2		" Close file descriptor 2
   sys close
   sys open; sh; 0	" Open the shell executable file (we get fd 2)
   sma
     jmp 1f
   sys link; system; sh; sh
   spa
     jmp error
   sys open; sh; 0
   spa
     jmp error
   sys unlink; sh
1:
   law 017700		" Copy the code at the boot label below
   dac 9		" up to location 017700
   law boot-1
   dac 8
1:
   lac 8 i
   dac 9 i
   sza			" Stop copying when we hit the 0 marker
     jmp 1b
   jmp 017701		" and then jump to the code

boot:
   lac d2
   lmq				" Save the fd into MQ
   sys read; 4096; 07700	" Read 4,032 words into locations 4096 onwards
				" leaving the top 64 words for this boot code.
   lacq				" Get the fd back and close the file
   sys close	
   jmp 4096			" and jump to the beginning of that executable
   0				" 0 marks the end of the code, used by the copy routine above

rline: 0
   law ibuf-1
   dac 8
1:
   cla
   sys read; char; 1
   lac char
   lrss 9
   sad o100
     jmp rline+1
   sad o43
   jmp 2f
   dac 8 i
   sad o12
     jmp rline i
   jmp 1b
2:
   law ibuf-1
   sad 8
     jmp 1b
   -1
   tad 8
   dac 8
   jmp 1b

gline: 0
   law obuf-1
   dac 8
1:
   jms gchar
   dac 8 i
   sad o12
     jmp gline i
   jmp 1b

gchar: 0
   lac tal
   sad ebufp
     jmp 1f
   ral
   lac tal i
   snl
     lrss 9
   and o777
   lmq
   lac tal
   add o400000
   dac tal
   lacq
   sna
     jmp gchar+1
   jmp gchar i
1:
   lac bufp
   dac tal
1:
   dzm tal i
   isz tal
   lac tal
   sad ebufp
     skp
   jmp 1b
   lac bufp
   dac tal
   lac d2
   sys tead; buf; 64
   sna
     jmp error
   jmp gchar+1

error:
   lac d1
   sys write; m2; m2s
   lac d1
   sys smes
   sys exit

m1:
   012; <lo>;<gi>;<n;<:;<
m1s = .-m1
m2:
   <?; 012
m2s = .-m2
m3:
   <pa>;<ss>;<wo>;<rd>;<: 040
m3s = .-m3
dd:
   <dd>;040040;040040;040040
dir:
   040040;040040;040040;040040

ttyin:
   <tt>;<yi>;<n 040;040040
ttyout:
   <tt>;<yo>;<ut>; 040040
keybd:
   <ke>;<yb>;<oa>;<rd>
displ:
   <di>;<sp>;<la>;<y 040
sh: 
   <sh>; 040040;040040;040040
system:
   <sy>;<st>;<em>; 040040
password:
   <pa>;<ss>;<wo>;<rd>

d1: 1
o43: 043
o100: 0100
o400000; 0400000
d2: 2
o12: 012
om60: -060
d3: 3
ebufp: buf+64
bufp: buf
o777: 0777
o777000: 0777000
o40: 040
o72: 072

ibuf: .=.+100
obuf: .=.+100
tal: .=.+1
buf: .=.+64
char: .=.+1
nchar: .=.+1
pid1: .=.+1
pid2: .=.+1
