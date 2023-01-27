"** 12-92-119.pdf page 14
	" space travel 4

displa: 0
	lac locpar
	sad cplan
	skp
	jmp 2f		" if (cplan == locpar) {
	lac locflg	"[arrow points here from the text "how to set?" - scan markup]
	sma
	jmp 1f		" if (locflg) {
	fld; cphi	"[-\                     - scan markup]
	fmp; absy	"[  |			 - scan markup]
	fst; ftmp1	"[  |			 - scan markup] ftmp1 = cphi * absy
	fld; sphi	"[  |			 - scan markup]
	fmp; absx	"[  |			 - scan markup]
	fad; ftmp1	"[  |			 - scan markup]
	fdv; dpar	"[  |			 - scan markup]
	fst; stheta	"[  \  lock calculation	 - scan markup] stheta = (sphi * absx + ftmp1) / dpar
	fld; sphi	"[  /			 - scan markup]
	fmp; absy	"[  |			 - scan markup]
	fng		"[  |			 - scan markup]
	fst; ftmp1	"[  |			 - scan markup] ftmp1 = - (sphi * absy)
	fld; cphi	"[  |			 - scan markup]
	fmp; absx	"[  |			 - scan markup]
	fad; ftmp1	"[  |			 - scan markup]
	fdv; dpar	"[  |			 - scan markup]
	fst; ctheta	"[  |			 - scan markup] ctheta = (cphi * absx + ftmp1) / dpar
	jmp 2f		"[-/			 - scan markup]
1:			" } else {
	fld; sphi
	fst; stheta	" stheta = sphi
	fld; cphi
	fst; ctheta	" ctheta = cphi
2:			" } }
	fld; absx
	sfmp; ctheta
	fst; ftmp1	" ftmp1 = absx * ctheta
	fld; absy
	sfmp; stheta
	fad; ftmp1
	lac aexp
	cma
	tad scale
	cma
	dac aexp
	fst; spy	" spy = (absy * stheta + ftmp1) / 2**scale
	dzm inflg	" inflg = false
	jms inscr
		jmp 1f	" if ((AC = inscr(spy))) {
	tad o145777
	dac clistp i
	jms rotx	" rotx()
	lac dhalt
	dac inflg	" inflg = true
	jms inscr
		jmp 1f	" if ((AC = inscr(spx))) {
	tad o161577
	dac i clistp
	lac cplan
	jms dsplanet	" dsplanet(cplan)
1:			" } }
	jms drcirc	" drcirc()
"** 12-92-119.pdf page 15
	jmp i displa

rotx: 0
	fld; absx
	sfmp; stheta
	fst; ftmp1	" ftmp1 = absx * stheta
	fld; absy
	sfmp; ctheta
	fng
	fad; ftmp1
	lac aexp
	cma
	tad scale
	cma
	dac aexp
	fst; spx	" spx = (-(absy * ctheta) + ftmp1) / 2**scale
	jmp i rotx

surf: 0
	-1
	tad setx
	cma
	dac tsetx	" tsetx = -setx
	lac setx
	tad o141577
	dac i clistp
	-1
	tad sety
	cma
	dac tsety	" tsety = -sety
	lac sety
	tad o165777
	dac clistp i
	lac narcs
	dac nt		" nt = narcs
	fld; wx
	fst; twx	" twx = wx
	fld; wy
	fst; twy	" twy = wy
	fld; v
	fng
	fst; v		" v = -v
2:			" while (nt != 0) {
	fld; v
	sfmp; twy
	fng
	fst; ftmp1	" ftmp1 = -(v * twy)
	fld; vv
	sfmp; twx
	fad; ftmp1
	fst; ftmp2	" ftmp2 = vv * twx + ftmp1
	fld; v
	sfmp; twx
	fst; ftmp1	" ftmp1 = v * twx
	fld; vv
	sfmp; twy
	fad; ftmp1
	fst; twy	" twy = vv * twy + ftmp1
	fad; spy
	jms inscr
		jmp 1f	" if (!(AC = inscr(twy + spy))) return false
"** 12-92-119.pdf page 16
	tad tsety
	dac dely	" dely = AC + tsety
	cma
	tad d1
	tad tsety
	dac tsety	" tsety -= dely
	fld; ftmp2
	fst; twx	" twx = ftmp2
	fad; spx
	jms inscr
		jmp 1f	" if (!(AC = inscr(twx + spx))) return false
	tad tsetx
	dac delx	" delx = res + tsetx
	cma
	tad d1
	tad tsetx
	dac tsetx	" tsetx -= delx
	lac delx
	sma
	jmp .+3
	cma
	tad o41
	alss 6
	dac delx
	lac dely
	sma
	jmp .+3
	cma
	tad o41
	tad delx
	tad o220000
	dac i clistp
	isz nt		" nt++
	jmp 2b		" }
	jmp i surf	" return true
1:
	isz surf
	jmp i surf

drcirc: 0		" draw circle
	lac grvflg
	spa
	jmp i drcirc	" if (grvflg) return
	lac fcplan
	tad prsq
	dac .+2
	fld; ..
	sqrt
	lac aexp
	cma
	tad scale
	cma
	dac aexp
	fst; dtmp1	" dtmp1 = sqrt(prsq[fcplan]) / (2**scale)
	fcp; thrs
	spa
	jmp i drcirc	" if (dtmp1 < thrs) return
	fng
	lac dpar
	cma
	tad scale
"** 12-92-119.pdf page 17
	cma
	dac dpar	" dpar /= (2**scale)
	fad; dpar
	sfdv; dpar
	fst; dtmp2	" dtmp2 = (-dtmp1 + dpar) / dpar
	sfmp; spy
	fst; wy		" wy = dtmp2 * spy
	jms inscr	" if (!(AC = inscr(wy)))
		jmp i drcirc	" return
	dac sety	" sety = AC
	lac inflg
	sma
	jms rotx	" if (!inflg) rotx()
	fld; dtmp2
	sfmp; spx
	fst; wx		" wx = dtmp2 * spx
	jms inscr	" if (!(AC = inscr(wx)))
		jmp i drcirc	" return
	dac setx	" setx = AC
	fld; spy
	fng
	fad; wy
	fst; wy		" wy -= spy
	fld; spx
	fng
	fad; wx
	fst; wx		" wx -= spx
	fld; dtmp1
	sfmp; pid10	" FAC = dtmp1 * pid10
	fcp; f400
	spa
	jmp 1f		" if (FAC > 400) {
	lac d400
	dac narcs	" narcs = 400
	jmp 2f		" } else {
1:
	fix		" AC = (int) FAC
	tad dm20
	spa
	cla		" if (AC - 20 < 0) AC = 0
	tad d20		" AC += 20
	dac narcs	" narcs = AC
	flt		" }
2:
	fst; dtmp1
	-1
	tad narcs
	cma
	dac narcs	" narcs = -narcs
	fld; f2pi
	sfdv; dtmp1
	fst; v		" v = f2pi / dtmp1
	sfmp; v
	-1
	tad aexp
	dac aexp
	fng
	fad; fpone
	fst; vv		" vv = -(v*v)/2 + 1
	lac o40004	" intens 0
	dac i clistp
"** 12-92-119.pdf page 18
	jms surf
		jmp i drcirc	" if (surf()) return
	jms surf
		jmp i drcirc	" if (surf()) return
	jmp i drcirc
