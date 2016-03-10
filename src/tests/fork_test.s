" Fork text code

main:
   sys fork
   jmp parent

child:
   lac d1
   sys write; childmsg;  3
   sys smes
   sys exit

parent:
   dac pid	" save the childs pid
   lac d1
   sys write; parentmsg; 4

   sys rmes	" wait for the child to exit
   sad pid	" did we get the same pid back?
     jmp ok

wrong:
   lac d1
   sys write; badpid;  4
   sys exit

ok:
   lac d1
   sys write; goodpid;  4
   sys exit

d1: 1		" stdout fd
pid: 0		" child's pid

parentmsg: <pa>; <re>; <nt>; 012000
childmsg:  <ch>; <il>; <d 012

goodpid: <go>; <od>; <pi>; <d 012
badpid: <ba>; <dp>; <id>; 012000
