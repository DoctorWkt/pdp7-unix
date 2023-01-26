"** 12-92-119.pdf page 10
	" space travel 3

updshp: 0
	lac forflg
	spa
	jmp .+4
	lac bacflg
	sma
	jmp 3f		" if (forflg || bacflg) {
	fld; ascale	" FAC = ascale
	lac  forflg
	sma
	jmp 1f
	lac bacflg
	sma
	jmp 1f+1
	fld; fpzero	" if (forflg && bacflg) FAC = 0
	jmp 2f
1:
	fng		" if (!forflg) FAC = -FAC
	lac scale
	tad aexp
	dac aexp	" FAC = FAC * 2**scale
	lac forflg
	sma
	jmp .+3
2:
	lac accflg	"[arrow pointing here from the text "how to set?" - scan markup]
	sma
	jmp .+3
	fad; maxa	" if (accflg) FAC += maxa
	fng		" FAC = -FAC
	fst; ftmp1
	fmp; ctheta
	fad; ax
	fst; ax		" ax += ftmp1 * ctheta
	fld; ftmp1
	fmp; stheta
	fad; ay
	fst; ay		" ay += ftmp1 * stheta
3:			" }
	fld; ox
	fng
	fad; ax
	fst; ftmp1	" ftmp1 = -ox + ax
	fld; x
	lac aexp
	tad d1
	dac aexp
	fad; ftmp1
	fst; ftmp1	" ftmp1 += x*2
	fld; x
	fst; ox		" ox = x
	fld; ftmp1
	fst; x		" x = ftmp1
	fld; oy
	fng
	fad; ay
	fst; ftmp1	" ftmp1 = -oy + ay
	fld; y
	lac aexp
	tad d1
"** 12-92-119.pdf page 11
	dac aexp
	fad; ftmp1
	fst; ftmp1	" ftmp1 += y*2
	fld; y
	fst; oy		" oy = y
	fld; ftmp1
	fst; y		" y = ftmp1
	lac par
	sad maxj
	jmp i updshp	" if (par == maxj) return
	jms absxy	" absxy(par)
	jms shipxy	" shipxy()
	lac par
	jms absv	" absv(par)
	fld; ox
	fng
	fad; x
	fad; absx
	fst; ox		" ox = -ox + x + absx
	fld; oy
	fng
	fad; y
	fad; absy
	fst; oy		" oy = -oy + y + absy
	lac maxj
	dac par		" par = maxj
	jms absv	" absv(par)
	fld; ox
	fng
	fad; absx
	fst; ox		" ox = -ox + absx
	fld; oy
	fng
	fad; absy
	fst; oy		" oy = -oy + absy
	lac par
	jms absxy	" absxy(par)
	fld; absx
	fad; shipx
	fng
	fst; x		" x = -(absx + shipx)
	fad; ox
	fst; ox		" ox += x
	fld; absy
	fad; shipy
	fng
	fst; y		" y = -(absy + shipy)
fadins:			" fad instruction
	fad; oy
	fst; oy		" oy += y
	lac par
	tad fppar
	dac 1f
	lac i 1f
	tad prsq
	dac 1f
	fld; 1:..
	sqrt
	fst; rpar	" rpar = sqrt(prsq[par])
	jms dspsca	" dspsca()
	lac par
"** 12-92-119.pdf page 12
	jms dispname	" dispname(par)
	jmp i updshp

inscr: 0		" in screen
	fng
	fix		" AC = (int) -FAC
	tad d383	" AC += 383
	spa
	jmp i inscr	" if (AC < 0) return
	tad dm768	" AC -= 768
	sma		" if (AC >= 0) return
	jmp i inscr
	isz inscr
	jmp i inscr	" return AC

absxy: 0
	sna
	jmp 7f		" if (AC) {
	lmq
	lac fldins
	dac 2f-1	" C(2f-1) = fld
	dac 4f-1	" C(4f-1) = fld
	lacq
1:			" while (true) {
	dac absi	" absi = AC
	sna
	jmp i absxy	" if (!absi) return
	tad fppar
	dac 9f+t
	lac i 9f+t
5:
	tad px
	dac 2f
fldins:			" fld instruction
	fld; absx
	fad; 2:..
	fst; absx	" if (i==0) absx = px[absi]; else absx += px[absi]
	lac i 9f+t
6:
	tad py
	dac 4f
	fld; absy
	fad; 4:..
	fst; absy	" if (i==0) absy = py[absi]; else absy += py[absi]
	lac fadins
	dac 2b-1
	dac 4b-1
	lac absi
	tad ppar
	dac 9f+t
	lac i 9f+t	" AC = ppar[absi]
	jmp 1b		" }
7:			" } else {
	dzm absx	" absx = 0
	dzm absx+1
	dzm absx+2
	dzm absy	" absy = 0
	dzm absy+1
	dzm absy+2
	jmp i absxy	" }
"** 12-92-119.pdf page 13
	t = t+1
