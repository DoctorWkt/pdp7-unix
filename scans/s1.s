" S1

.. = 0
t = 0
orig:
   hlt
   jmp pibreak

. = orig+7
   -1

. = orig+020
   1f
   iof
   dac u.ac
   lac 020
   dac 1f
   lac 1f-1
   dac 020
   lac u.ac
   jmp 1f+1
   1f
1: 0
   iof
   dac u.ac
   lacq
   dac u.mq
   lac 8
   dac u.rq
   lac 9
   dac u.rq+1
   jms copy; 10; u.rq+2; 6
   lac 1b
   dac u.rq+9
   -1
   dac .savblk
   dac .insys
   lac uquant
   jms betwen; 40; maxquant
      jms swap
   ion
   -1
   tad u.rq+8
   jms laci
   jms betwen; o20001; swp
      jmp badcal
   tad swp
   dac .+1
   jmp .. i

. = orig+0100
   jmp coldentry
   jms halt

okexit:
   dzm: u.ac
sysexit:
   ion
   lac .savblk
   sza
   jmp 1f
   jms copy; sysdata; dskbuf; 64
   cla
   jms dskio; o7000
1:
   dzm .insys
   jms chkint
      skp
   jmp .save
   jms copy; u.rq+2; 10; 6
   lac u.rq+1
   dac 9
   lac u.rq
   dac 8
   lac u.rq
   lmq
   lac u.ac
   jmp u.rq+8 i

swap: 0
   ion
1:
   jms lookfor; 3 " out/ready
      jmp 1f
   jms lookfor; 1 " in/ready
      skp
   jmp 1b
   dzm maxquant
   jmp 3f
1:
   dac 9f+t
   jms lookfor; 2 " in/notready
      jmp 1f
   jms lookfor; 1 " in/ready
   jmp 2f
1:
   lac swap
   dac u.swapret
   iof
   lac o200000
   tad u.ulistp i
   dac u.ulistp i
   ion
   jmp dskswap; 07000

" For now, this stuff is defined so that
" the assembler doesn't complain about it


pibreak: 23
u.ac: 100
u.mq: 3
u.rq: 3
copy: 7
.savblk: 0
.insys: 0
uquant: 0
betwen: 0
maxquant: 0
laci: 0
swp: 0
badcal: 0
coldentry: 0
halt: 0
dskio: 0
sysdata: 0
dskbuf: 0
o7000: 07000
o20001: 020001
chkint: 0
.save: 0
lookfor: 0
