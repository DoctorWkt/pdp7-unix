"** 01-s1.pdf page 14
" s3

	" call:
	"   jms searchu; addr

searchu: 0
   lac searchu i		" fetch argument
   dac 9f+t+1			" in t1
   -mnproc			" loop counter
   dac 9f+t			" in t0
   law ulist-1			" ulist ptr
   dac 8			" in index 8
1:
   lac 8 i			" copy ulist entry to lu
   dac lu
   lac 8 i
   dac lu+1
   lac 8 i
   dac lu+2
   lac 8 i
   dac lu+3
   jms 9f+t+1 i			" call argument as subroutine
   isz 9f+t			" returned: loop done?
   jmp 1b			"  no, do it again
   isz searchu			" skip argument
   jmp searchu i
t = t+2

	" look for process:
	"   jms lookfor; status
	"    found: ulist ptr in AC
	"   not found
lookfor: 0
   jms searchu; 1f
   isz lookfor			" skip argument
   isz lookfor			" give skip return
   jmp lookfor i
1: 0				" worker called by searchu
   lac lu
   rtl; rtl; and o7		" bits 0:2 of lu
   sad lookfor i		" match argument?
   skp				"  yes
   jmp 1b i			"   no, return, keep going
   -3
   tad 8			" roll index 8 back to this entry
   and o17777
   isz lookfor			" skip argument
   jmp lookfor i		" non-skip return

.fork:
   jms lookfor; 0 " not-used	" find an unused process slot
      skp
      jms error			" none found- return error
   dac 9f+t			" save ulist ptr in t0
   isz uniqpid			" generate new pid
   lac uniqpid
   dac u.ac			" return in AC
   law sysexit
   dac u.swapret		" return from system call when swapped back in
   lac o200000			" change process status to out/ready
   tad u.ulistp i
   dac u.ulistp i
   jms dskswap; 07000		" swap parent out
   lac 9f+t			" get unused ulist slot back
   dac u.ulistp			" set ulist pointer
   lac o100000			" mark child in/ready
   xor u.ulistp i
   dac u.ulistp i
   lac u.pid
"** 01-s1.pdf page 15
   dac u.ac			" return parent pid in AC?
   lac uniqpid
   dac u.pid			" set child pid
   isz 9f+t
   dac 9f+t i			" set pid in process table
   isz u.rq+8			" increment return address from sys call
   dzm u.intflg			" clear int flag
   jmp sysexit			" return in child process
t= t+1

badcal:				" bad (unimplemented) system call
   clon				" clear any pending clock interrupt?
   -1
   dac 7			" set location 7 to -1
.save:
   lac d1
   jms iget
   cla
   jms iwrite; 4096; 4096
   jms iwrite; userdata; 64
   jms iput

.exit:
   lac u.dspbuf
   sna					" process using display?
   jmp .+3				"  no
   law dspbuf				"   yes
   jms movdsp
   jms awake
   lac u.ulistp i
   and o77777				" mark process table entry free
   dac u.ulistp i
   isz u.ulistp
   dzm u.ulistp i			" clear pid in process table
   jms swap

.rmes:
   jms awake
   lac o100000
   tad u.ulistp i
   dac u.ulistp i
   law 2
   tad u.ulistp
   dac 9f+t
   -1
   dac 9f+t i
   jms swap
   law 2
   tad u.ulistp
   dac 9f+t
   lac 9f+t i
   cma
   dac u.ac
   dzm 9f+t i
   isz 9f+t
   lac 9f+t i
   dac u.mq
   dzm 9f+t i
   jmp sysexit
t = t+1

"** 01-s1.pdf page 16
.smes:
   lac u.ac
   sna spa
   jms error
   jms searchu; 1f
   law 2
   tad u.ulistp
   dac 9f+t
   dzm 9f+t i
   jms error
1: 0
   lac lu+1
   sad u.ac
   skp
   jmp 1b i
   lac lu+2
   sad dm1
   jmp 1f
   lac o100000
   tad u.ulistp i
   dac u.ulistp i
   law 2
   tad u.ulistp
   dac 9f+t
   lac u.ac
   dac 9f+t i
   jms swap
   law 2
   tad u.ulistp
   dac 9f+t
   dzm 9f+t i
   jmp .smes
1:
   -3
   tad 8
   dac 9f+t
   lac o700000
   tad 9f+t i
   dac 9f+t i
   isz 9f+t
   isz 9f+t
   lac u.pid
   cma
   dac 9f+t i
   isz 9f+t
   lac u.mq
   dac 9f+t i
   jmp okexit
t = t+1

awake: 0
   jms searchu; 1f
   jmp awake i
1: 0
   lac u.pid
   sad lu+2
   skp
   jmp 1b i
   -3
   tad 8
   dac 9f+t
"** 01-s1.pdf page 17
   lac o700000
   tad 9f+t i
   dac 9f+t i
   jmp 1b i
t = t+1

swr:
sww:
   jmp .-4 i
   .halt; rttyi; rkbdi; rppti; .halt
   .halt; wttyo; wdspo; wppto

.halt: jms halt

rttyi:
   jms chkint1
   lac d1
   jms getchar
      jmp 1f
   and o177
   jms betwen; o101; o132
      skp
   tad o40
   alss 9
   jmp passone
1:
   jms sleep; sfiles+0
   jms swap
   jmp rttyi

wttyo:
   jms chkint1
   jms forall
   sna
   jmp fallr
   lmq
   lac sfiles+1
   spa
   jmp 1f
   xor o400000
   dac sfiles+1
   lacq
   tls
   sad o12
   jms putcr
   jmp fallr
1:
   lacq
   dac char
   lac d2	"** written: d6 ttyout
   jms putchar
      skp
   jmp fallr
   jms sleep; sfiles+1
   jms swap
   jmp wttyo

rkbdi:
   jms chkint1
   lac d3
   jms getchar
"** 01-s1.pdf page 18
      jmp 3f
   lmq
   and o155
   sad o55
   jmp 1f
   lacq
   and o137
   sad o134
   skp
   jmp 2f
1:
   lacq
   xor o20
   lmq
2:
   lacq
   dac u.limit
1:
   jms chkint1
   lac u.limit
   jms dspput
      jmp 1f
   jms sleep; sfiles+6
   jms swap
   jmp 1b
1:
   lac u.limit
   alss 9
   jmp passone
3:
   jms sleep; sfiles+2
   jms swap
   jmp rkbdi

wdspo:
   jms chkint1
   jms forall
   jms dspput
      jmp fallr
   jms sleep; sfiles+6
   jms swap
   jmp wdspo


rppti:
   lac d4
   jms getchar
      jmp .+3
   alss 9
   jmp passone
   lac sfiles+3
   sma
   rsa
1:
   jms sleep; sfiles+3
   jms swap
   jmp rppti
"** 01-s1.pdf page 19

wppto:
   jms forall
   sna
   jmp fallr
   lmq
   lac sfiles+4
   spa
   jmp 1f
   xor o400000
   dac sfiles+4
   lacq
   psa
   jmp fallr
1:
   lacq
   dac char
   lac d5
   jms putchar
      skp
   jmp fallr
   jms sleep; sfiles+4
   jms swap
   jmp wppto

passone:
   sad o4000
   jmp okexit
   dac u.base i
   lac d1
   dac u.ac
   jmp sysexit

error: 0
   -1
   dac u.ac
   jmp sysexit

chkint1: 0
   dzm .insys
   jms chkint
      skp
   jmp .save
   -1
   dac .insys
   jmp chkint1 i
