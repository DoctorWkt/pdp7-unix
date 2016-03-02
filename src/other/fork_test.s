" Fork text code

main:
   sys fork
   jmp parent

child:
   lac d1
   sys write; childmsg;  3
   sys exit

parent:
   lac d1
   sys write; parentmsg; 4
   sys exit

d1: 1		" stdout fd

parentmsg: <pa>; <re>; <nt>; 012000
childmsg:  <ch>; <il>; <d 012
