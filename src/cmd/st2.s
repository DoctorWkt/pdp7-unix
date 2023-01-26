"** 12-92-119.pdf page 6
	" space travel 2

absv: 0
	dzm absx
	dzm absx+1
	dzm absx+2
	dzm absy
	dzm absy+1
	dzm absy+2
1:
	dac absi	" absi = AC
	sna
	jmp i absv	" while (absi) {
	tad fppar
	dac 9f+t
	jms invert	" invert(absi) -> ftmp1 = px[absi], ftmp2 = py[absi]
	fld; ftmp1
	fng
	fad; absx
	fst; absx	" absx -= ftmp1
	fld; ftmp2
	fng
	fad; absy
	fst; absy	" absy -= ftmp2
	jms invert	" invert(absi) -> ftmp1 = px[absi], ftmp2 = py[absi]
	fld; ftmp1
	fad; absx
	fst; absx	" absx += ftmp1
	fld; ftmp2
	fad; absy
	fst; absy	" absy += ftmp2
	lac absi
	tad ppar
	dac 9f+t
	lac i 9f+t	" absi = ppar[absi]
	jmp 1b		" }

invert: 0
	lac i 9f+t
	dac fcplan
	tad pww
	dac 1f
	dac 2f
	lac fcplan
	tad px
	dac 3f
	lac fcplan
	tad py
	dac 4f
	fld; 1:..
	fng
	fst; 2:..	" pww[par] = -pww[par]
	jms updpln	" updpln()
	fld; 3:..
	fst; ftmp1	" ftmp1 = px[par]
	fld; 4:..
	fst; ftmp2	" ftmp2 = py[par]
	jmp i invert

	t = t+1

updpln: 0
"** 12-92-119.pdf page 7
	lac fcplan
	lmq
	tad px
	dac 1f
	dac 5f
	lacq
	tad py
	dac 3f
	dac 6f
	dac 0f
	lacq
	tad pw
	dac 2f
	dac 7f
	lacq
	tad pww
	dac 4f
	dac 8f

	fld; 1:..
	fst; ftmp1	" ftmp1 = px[fcplan]
	fmp; 2:..
	fst; ftmp2	" ftmp2 = ftmp1 * pw[fcplan]
	fld; 3:..
	fmp; 4:..
	fng
	fad; ftmp2
	fst; 5:..	" px[fcplan] = - (py[fcplan] * pww[fcplan]) + ftmp2
	fld; 6:..
	fmp; 7:..
	fst; ftmp2	" ftmp2 = py[fcplan] * pw[fcplan]
	fld; ftmp1
	fmp; 8:..
	fad; ftmp2
	fst; 0:..	" py[fcplan] = ftmp1 * pww[fcplan] + ftmp2
	jmp updpln i

updacc: 0		" update acceleration
	lac cplan
	sad par
	jmp upda2	" if (cplan != par) {
	jms absxy	" absxy(cplan)
	fld; absx
	fad; shipx	" FAC = absx + shipx
	jmp 1f		" } else {
upda2:
	fld; x
	fng		" FAC = -x
1:			" }
	fst; absx	" absx = FAC
	fmp; absx
	fst; ftmp1	" ftmp1 = absx * absx
	lac cplan
	sad par
	jmp 1f		" if (cplan != par)
	fld; absy
	fad; shipy	" FAC = absy + shipy
	jmp 2f
1:
	fld; y
	fng		" else FAC = -y
"** 12-92-119.pdf page 8
2:
	fst; absy
	fmp; absy
	fad; ftmp1
	fst; dtmp1	" dtmp1 = absy * absy + ftmp1
	sqrt
	fst; dpar	" dpar = sqrt(dtmp1)
	lac cplan
	sad par
	skp
	jmp upda5	" if (cplan == par) {
	fld; ox
	fng
	fad; x
	fst; ftmp1	" ftmp1 = -ox + x
	fmp; y
	fst; horizv	" horizv = ftmp1 * y
	fld; y
	fng
	fad; oy
	fst; ftmp2	" ftmp2 = -y + oy
	fmp; x
	fad; horizv
	fdv; dpar
	fst; horizv	" horizv = (ftmp2 * x + horizv) / dpar
	fld; dpar
	fcp; rpar
	sma
	jmp upda5	" if (dpar < rpar) {
	lac lanflg
	spa
	jmp upda5	" if (!lanflg) {
	fld; ftmp1
	fmp; ftmp1
	fst; ftmp1	" ftmp1 *= ftmp1
	fld; ftmp2
	fmp; ftmp2
	fad; ftmp1
	fcp; crash
	spa
	jmp 1f		" if (ftmp2 * ftmp2 + ftmp1 > crash) {
	lac dhalt
	dac goflg	" goflg = true
	dac crflg	" crflg = true
1:			" }
	lac dhalt
	dac lanflg	" lanflg = true
	fld; rpar
	fdv; dpar
	fst; ftmp1	" ftmp1 = rpar / dpar
	fmp; x
	fst; x		" x *= ftmp1
	fst; ox		" ox = x
	fld;  ftmp1
	fmp; y
	fst; y		" y *= ftmp1
	fst; oy		" oy = y
	lac par
	jms absxy	" absxy(par)
	jms shipxy	" shipxy()
	jmp upda2	" } } }
"** 12-92-119.pdf page 9
upda5:
	fcp; fardst
	spa
	jmp 1f		" if (dpar > fardst) {
	lac cplan
	sna
	jmp 1f		" if (cplan) {
	lac dhalt
	dac grvflg	" grvflg = true
	jmp i updacc	" return
1:			" } }
	dzm grvflg	" grvflg = false
	lac fcplan
	tad accl
	dac 1f
	fld; 1:..
	fdv; dtmp1
	fcp; maxa
	spa
	jmp 2f		" if (accl[fcplan] / dtmp1 > maxa) {
	fst; maxa	" maxa = accl[fcplan] / dtmp1
	lac cplan
	dac maxj	" maxj = cplan
2:			" }
	fdv; dpar
	fst; ftmp1	" ftmp1 = (accl[fcplan] / dtmp1) / dpar
	fmp; absx
	fad; ax
	fst; ax		" ax += ftmp1 * absx
	fld; ftmp1
	fmp; absy
	fad; ay
	fst; ay		" ay += ftmp1 * absy
	jmp i updacc
