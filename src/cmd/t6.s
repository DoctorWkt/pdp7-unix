"** 13-120-147.pdf page 23
rerm:				" recognition "rm" instruction
  jms aget			" get address portion (abs addr)
  jmp 1f			" join "rs"to fetch
rers:				" recognition "rs" instruction
  jms aget			" get address portion (positive frame offset)
  add frame			" add frame pointer
1:dac holdlv			" save as "hold lvalue"
  lac holdlv i			" fetch addressed word
  jmp 2f			" go push
rerv:				" recognition "rv" instruction
  jms aget			" get address portion
  lls 6				" discard high six bits
  lrs 6				" replac with six copies of LINK bit
2:dac nframe i			" save @nstack
  isz nframe			" increment
  jmp goon			" success

rero:				" recognition "ro" (opr) instruction
  jms decnf			" pop top of nstack
  dac rand1			" save as (op)rand 1
  jms aget			" get address portion of instruction
  and o77			" get low six bits for sub-opcode
  add obranch			" make xct into o(pr)branch table
  dac 2f			" save
  cma				" negate (minus one)
  tad unary			" add unary base xct
  spa				" positive?
  jmp 1f			" no: was unary, skip second arg fetch
  jms decnf			" yes: binary op, pop second arg from nstack
  dac rand2			" save as second (ope)rand
1:lac rand1			" get first (ope)rand in AC
2:xct				" execute instruction from obranch table
  jmp result			" if noop, join result processing

obranch:
  xct .+1
  opr        ;op=0400000+1	" (no)op
  jmp rorel  ;le=op;op=op+1	" relop <=
  jmp rorel  ;ne=op;op=op+1	" relop !=
  jmp rorel  ;lt=op;op=op+1	" relop <
  jmp rorel  ;ge=op;op=op+1	" relop >=
  jmp rorel  ;eq=op;op=op+1	" relop ==
  jmp rorel  ;gt=op;op=op+1	" relop >
  tad rand2  ;ad=op;op=op+1	" binop +
  jms sub    ;sb=op;op=op+1	" binop -
  and rand2  ;an=op;op=op+1	" binop &
  jmp roor   ;or=op;op=op+1	" binop |
  xor rand2  ;xo=op;op=op+1	" binop ^ (xor)
  jmp rosr   ;sr=op;op=op+1	" binop <<
  jmp rosl   ;sl=op;op=op+1	" binop >>
  jmp romn   ;mn=op;op=op+1	" binop min??
  jmp romx   ;mx=op;op=op+1	" binop max??
  lac rand2  ;as=op;op=op+1	" binop ??? (always returns rh operand)

  opr        ;pl=op;op=op+1	" unary + (noop)
  jmp romi   ;mi=op;op=op+1	" unary - (negate)
  cma        ;cm=op;op=op+1	" unary ~ (complement)
  jmp roindir;indir=op;op=op+1	" unary indirect (fetch *holdlv)
  lac holdlv ;addr=op;op=op+1	" unary addr (return last holdlv)
unary:xct obranch+1+pl

rorel:      "<= 001

"** 13-120-147.pdf page 24
  jms sub   "!= 010
  sna       "<  011
  jmp 2f    ">= 100
  spa       "=  101
  jmp 1f    ">  110
  lac d1   "a>b, code 001
  jmp 3f
1:lac d2   "a<b, code 100
2:add d2   "a=b, code 010
3:and ii i
  sza
  -1
  cma
  jmp result

				" return rand1 minus rand2
				" used by rorel, rosub
sub:0
  cma
  tad rand2
  cma
  jmp sub i

roor:
  lmq				" save rand1 in MQ
  lac rand2			" get rand2 in AC
  omq				" or AC and MQ
  jmp result

rosr:
  lac rand2			" get rh operand
  add l.lrs			" make long right shift (fills with LINK)
  cll				" clear link
  jmp 1f
rosl:
  lac rand2			" get rh operand
  add l.lls			" make long left shift (fills from MQ)
  clq				" clear MQ
1:dac .+2			" save shift instruction
  lac rand1			" get left hand operand
  0				" perform shift
  jmp result			" join result processing

romn:
  jms sub			" get rand1-rand2
  cma				" complement (rand2-rand1-1)
  jmp .+2
romx:
  jms sub			" get rand1-rand2
  ral				" rotate left (sign bit into LINK)
  lac rand1			" get first operand
  szl				" link clear?
  lac rand2			" no, get second operand instead
  jmp result			" return result

romi:				" unary minus
  cma				" complement
  tad d1			" add one
  jmp result

roindir:
  dac holdlv			" save as "hold lvalue"
  lac holdlv i			" fetch value

"** 13-120-147.pdf page 25
  jmp result			" return result

result:				" ro result processing
  dac junk			" save in temp
  dac nframe i			" store at *nframe++
  isz nframe
  lac ii i			" fetch original instruction
  and stbit			" get st(ore?) bit
  sna				" set?
  jmp exprtest			"  no
  lac junk			" yes: get result
  dac holdlv i			" store at *holdlv
  lac ii i			" fetch original instruction
  and fibit			" fi(nal?) bit set?
  sza				" no, skip
  jms decnf			"  yes: discard stacked result
  jmp goon			" succeed

exprtest:			" here if st(ore?) bit not set
  lac ii i			" fetch instruction
  and fibit			" get fi(nal?) bit
  sna				" set?
  jmp goon			"  no: succeed
  jms decnf			" yes: poped stacked result
  lac nframe i			" (redundant?????)
  sza				" was result zero?
  -1				"  no: get all ones
  cma				" complement (zero -> -1, -1 -> zero)
  dac fflag			" save as failure flag
  jmp goon

decnf:0				" decrement nframe, return stacked value
  -1
  tad nframe
  dac nframe
  lac nframe i
  jmp decnf i
