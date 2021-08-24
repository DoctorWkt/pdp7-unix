"** 13-120-147.pdf page 28
" op.s is the op code defination file
" for the assembler
" no iot ops are defined
" system cal entries are defined
"
dac = 0040000		" MEM: deposit AC
jms = 0100000		" MEM: jump to subroutine
dzm = 0140000		" MEM: deposit zero to memory
lac = 0200000		" MEM: load AC
xor = 0240000		" MEM: XOR with AC
add = 0300000		" MEM: one's complement add
tad = 0340000		" MEM: two's complement add
xct = 0400000		" MEM: execute
isz = 0440000		" MEM: increment and skip if zero
and = 0500000		" MEM: AND
sad = 0540000		" MEM: skip if AC different
jmp = 0600000		" MEM: jump
eae = 0640000		" Extended Arithmetic Element
i = 020000		" indirect
opr = 0740000		" Operator (bit encoded)
law = opr i		" OPR: load accumulator with (instr)
cma = opr 1		" OPR: complement AC
cml = opr 2		" OPR: complement LINK
ral = opr 010		" OPR: rotate AC left
rar = opr 020		" OPR: rotate AC right
sma = opr 0100		" OPR: skip on minus AC
sza = opr 0200		" OPR: skip on zero AC
snl = opr 0400		" OPR: skip on non-zero link
skp = opr 01000		" OPR: skip unconditionally
spa = opr 01100		" OPR: skip on positive AC
sna = opr 01200		" OPR: skip on non-zero AC
szl = opr 01400		" OPR: skip on zero link
cll = opr 04000		" OPR: clear link
cla = opr 010000	" OPR: clear AC
las = opr 010004	" OPR: load AC from switches
lrs = eae 0500		" EAE: long right shift
lrss = i lrs		" EAE: long right shift, signed
lls = eae 0600		" EAE: long left shift
llss = i lls		" EAE: long left shift, signed
als = eae 0700		" EAE: AC left shift
alss = i als		" EAE: AC left shift, signed
lacq = eae 01002	" EAE: load AC with MQ
lacs = eae 01001	" EAE: load AC with SC (not used)
clq = eae 010000	" EAE: clear MQ
omq = eae 2		" EAE: OR MQ into AC
cmq = eae 4		" EAE: complement MQ
lmq = eae 012000	" EAE: load MQ from AC

sys = i			" CAL instruction w/ indirect bit
save = 1
open = 3
read = 4
write = 5
creat = 6
seek = 7
close = 9
exit = 14
