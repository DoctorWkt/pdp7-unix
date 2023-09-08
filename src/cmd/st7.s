"** 12-92-119.pdf page 26
" space travel 7

clistp = 017
br0 = 040004			" intens 0
br1 = 040005			" intens 1
br2 = 040006			" intens 2
br3 = 040007			" intens 3

d10: 10
d3: 3
o246256: 0246256		" incr n=1 dir=1 (NE), n=2 dir=6 (W)
o253052: 0253052		" incr n=2 dir=4 (S), n=2 dir=2 (E)
o246036: 0246036		" incr n=1 dir=0 (N), n=1 dir=6 (W)
o177: 0177			" 7-bit mask (127)
nplan: 32			" number of planets
d1: 1
d20: 20
dm1: -1
o141577: 0141577		" dsetx 895 (view right)
o161577: 0161577		" dsetx (delay) 895 (view right)
o164372: 0164372		" dsety (delay) 250 (view bottom)
o114: 0114			" ascii L
o20714: 020714			" ascii "CL"
d383: 383			" 895 (view right) - 512 (scope width / 2)
dm768: -768			" 127 (view left) - 895 (view right)
o145777: 0145777		" dsety 1023 (view top)
o165777: 0165777		" dsety (delay) 1023 (view top)
o7: 7
o60: 060
o55: 055
o53: 053
o41: 041
o220000: 0220000		" short vec vis
d400: 400
dm20: -20
o40004: 040004

fardst: 020;0200000; 0		" fardst = 32768
f2pi: 03;0311037;552421		" 2 * pi, missing octal prefix
pid10: -01;0240662;756647	" pi / 10, missing octal prefix
thrs: 02;0200000;0		" threshold = 2.0
f400: 011;0310000;0
crash: -028;0200000;0		" crash ~ 0
stheta: 01;0200000;0
ctheta: 0;0;0
fpzero: 0;0;0
scale: 0
vscale: 6
ascale: -1			" loaded as a float = -1;0777773;0253436 ~ -0.5
sdphi: -05;0253436;0700177	" sin(1.2 deg)
cdphi: 000;0377743;0201725	" cos(1.2 deg)
dhalt: 0400000
fpone: 01;0200000;0

9: .=.+t
horizv: .=.+3		" horizontal velocity
.pbson: .=.+1
.pbsint: .=.+1
dspflg: .=.+1
par: .=.+1		" current planet
absi: .=.+1
absx: .=.+3
"** 12-92-119.pdf page 27
absy: .=.+3
v: .=.+3
vv: .=.+3
spx: .=.+3		" screen position x
spy: .=.+3		" screen position y
wx: .=.+3
wy: .=.+3
twx: .=.+3
twy: .=.+3
setx: .=.+1
sety: .=.+1
narcs: .=.+1		" number of arcs
nt: .=.+1
inflg: .=.+1
grvflg: .=.+1		" gravity flag
dtmp1: .=.+3
dtmp2: .=.+3
delx: .=.+1
dely: .=.+1
tsetx: .=.+1
tsety: .=.+1
accflg: .=.+1
locpar: .=.+1
crflg: .=.+1		" crash landing flag
rpar: .=.+3		" planet radius
dpar: .=.+3		" distance to planet
ax: .=.+3
ay: .=.+3
maxa: .=.+3		" strongest gravity acceleration
maxj: .=.+1		" index of planet with strongest gravity
dcplan: .=.+1
fcplan: .=.+1		" floating point count planet (float index)
cplan: .=.+1		" count planet (index)
shipx: .=.+3
shipy: .=.+3
x: .=.+3		" x position relative to planet
y: .=.+3		" y position relative to planet
ox: .=.+3
oy: .=.+3
lanflg: .=.+1		" landing flag
goflg: .=.+1		" game over flag
forflg: .=.+1		" forward flag
bacflg: .=.+1		" backward flag
sphi: .=.+3
cphi: .=.+3
ftmp1: .=.+3
ftmp2: .=.+3
locflg: .=.+3

dsetx = 0140000
dsety = 0164000
vecx = 0120000
vecy = 0124000
m = 02000
displist:		" display list
	075057 "scale 1 intens 3 blink on lp 0 sym 0
	dsetx 800
	dsety 20
dispcl:			" display L/CL
	0
	060004 "intens 0 blink off
"** 12-92-119.pdf page 28
	dsetx 0
	dsety 20
namedsp:		" display name
	.=.+10
	dsetx 400
	dsety 20
dssca:			" display scale
	.=.+3
	040040 "scale 0
	dsetx 127
	dsety 250
	vecx 768
	dsetx 895
	dsety 255
	vecy 768
	dsetx 895
	dsety 1023
	vecx m 768
	dsetx 127
	dsety 1023
	vecy m 768
	dsetx 127
	dsety 255
	vecx 768
	dsetx 511
	dsety 255
	vecy 767
	dsetx 127
	dsety 639   "[--- - scan markup]
	vecx 767    "[an arrow starts between vecx and dspl, it points to the right - scan markup]
dspl:			" display planets
	0400000
