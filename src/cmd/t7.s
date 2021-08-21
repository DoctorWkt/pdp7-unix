"** 13-120-147.pdf page 26
9:.=.+t

end = -1			" end of string (two 0777 bytes)
				" recognition / generation opcodes:
no = 0000000
rx = 0040000; gx = rx
rc = 0100000
rt = 0140000; gc = rt
rf = 0200000; gf = rf
rw = 0240000; gk = rw
ra = 0300000; gp = ra
rb = 0340000;gq = rb
ro = 0400000
rm = 0440000
rs = 0500000
rv = 0540000

				" literal words
ljmp:jmp
l.llss:llss
l.lrs:lrs
l.lls:lls
l.ra:ra				" used for comparison
l.rb:rb				" used for comparison
l.rw:rw				" used for comparison
l.gk:gk				" used to create instr in twoktab
l.gcx:gc x			" NOT USED?

x = 020000			" exit bit (on all recog/gen instrs)
st = 0100			" store(?) bit on recog op (ro) instrs
fi = 0200			" final(?) bit on recog op (ro) instrs
opmask:0740000			" opcode mask
exitmask: x			" exit bit mask
				" number lits:
m1:0-1
d0:o0:0
d1:o1:1
d2:o2:2
d3:o3:3
d4:o4:4
d5:o5:5
d6:o6:6
d7:o7:7
d8:o10:8
asciisp:040			" ascii space (NOT USED)
asciinl:012			" ascii newline (NOT USED)
nl:012777			" newline + EOS
onenl:nl			" pointer to newline+EOS
bugr:.+1;<rn>;<rx>;<rc>;<rt>;<rf>;<rw>;<ra>;<rb>	" ptr to rec. op names
  <ro>;<rm>;<rs>;<rv>
bugg:.+1;<gn>;<gx>;<gz>;<gc>;<gf>;<gk>;<gp>;<gq>	" ptr to gen. op names
				" NOTE! ginterp ignores high bit of
				" opcode (to allow as char indicator
				" bit for gx instruction), but bug
				" routine does not, so table should
				" include two more entries???

o17:017
o60:060
o77:077
o777:0777

o417777:0417777
o400000:0400000
o740000:0740000
o377700:0377700
o17777:017777

"** 13-120-147.pdf page 27
o757777:0757777
o600600:0600600

				" variables
junk:0
junk1:0

output:1
input:0

stbit:st
fibit:fi
holdlv:0
rand1:0
rand2:0


symwrite:0
symbot: symtab
symsiz = 500
symmax:symsiz

equwrite:0
equread:0
equ = equread
equbot: equtab
equsiz = 500
equmax: equsiz
delta: 2
mdelta:0-2

sbsiz=50
sbmax:sbsiz
sbwrite:0
sbbot:sbbuf

fflag:0
gflag:0
ignore:.+1;0400000;0;0;0;0;0;0;4	" pointer to ignored character set
				" default ignore set (NUL and DEL)
				" set stored using first (high) 16 of each wd.
frame:rstack			" frame pointer
nframe:rstack+6			" next frame pointer
env = ignore
d.ii = d2			" frame offset for instruction pointer
d.env = d3			" frame offset for env/ignore
d.blkmod = d3			" SYMBOL NOT USED
d.j = d4			" frame offset for saved j
d.k = d5			" frame offset for saved k
dffrmsz:6			" current frame size (one of [rg]efrsz)
framsiz:4			" LOCATION NOT USED
refrsz = d6			" recognition frame size
gefrsz = d4			" generation frame size
ii: start			" interpreter instruction pointer
k:0				" saved data (ktab) pointer

rsiz = 500			" stack size
rmax: rsiz			" stack size as variable
rbot:rstack			" pointer to first stack entry
rtop:rstack+rsiz		" pointer to last stack entry

owrite:0			" index into obuf
obot:obuf			" pointer to first word of output buffer
osiz=64				" output buffer size
