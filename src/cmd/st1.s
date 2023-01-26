"** 12-92-119.pdf page 1
" space travel 1

t = 0

start:			"[------ stuff for gravity - scan markup]
	law 13		" 13 = pbsflgs
	sys sysloc	" get pbsflgs location
	dac .pbson	" store in .pbson
	lac pww
	dac 1f
	dac 2f
	lac pw
	dac 3f
	-32
	dac cplan	" cplan = -32
4:			" while (cplan != 0) {
	fld; 1:0
	fmp; 2:0
	-1
	tad aexp
	dac aexp
	fng
	fad; fpone
	fst; 3:0	" pw[i] = - (pww[i] * pww[i]) / 2 + 1
	lac 1b
	tad d3
	dac 1b
	dac 2b
	lac 3b
	tad d3
	dac 3b
	isz cplan	" cplan++
	jmp 4b		" }
	law dspl-1
	dac clistp
	dac lanflg	" lanflg = true
	dzm crflg	" crflg = false
	dzm goflg	" goflg = false
	dzm .pbsint	" pbsint = 0
	dzm forflg	" forflg = false
	dzm bacflg	" bacflg = false
	dzm dspflg	"[line connecting this instruction to... - scan markup]
	dzm locflg	" locflg = false
	dzm locpar	"[... this instruction - scan markup]
	lac d1
	dac par		" par = 1
	jms dispname	" dispname()
	fld; prsq+4
	sqrt
	fst; rpar	" rpar = sqrt(prsq[par])
	fst; y		" y = rpar
	fst; oy		" oy = y
	fld; fpone
	fst; sphi	" sphi = 1
	fst; stheta	" stehta = sphi
	jms dspsca	" dspsca()
	fld; fpzero
	fst; x		" x = 0
	fst; ox		" ox = x
	fst; cphi	" cphi = ox
	fst; ctheta	" ctheta = cphi
	law displist
"** 12-92-119.pdf page 2
	sys capt
	jmp loop

loop:
	law dspl-1
	dac clistp
	jms contrl	"[arrow from below points to this instruction - scan markup]
	lac par
	jms absxy	" absxy(par)
	jms shipxy	" shipxy()
	lac goflg
	spa
	jmp loop3	"[long dash after loop3 - scan markup]	if (!goflg) {
	fld; fpzero
	fst; ax		" ax = 0
	fst; ay		" ay = 0
	fst; maxa	" maxa = 0
	lac nplan	" AC = nplan
	skp
loop1:
	lac cplan	" AC = cplan
	tad dm1		" AC--
	spa
	jmp loop2	" while (AC >= 0) {
	dac cplan	" cplan = AC
	tad fppar
	dac fcplan
	lac i fcplan
	dac fcplan
	jms updacc	" updacc()
	jms displa	" displa()
	lac cplan
	sza
	jms updpln	" if (cplan) updpln()
	lac cplan
	and o7
	sad o7
	jms contrl	" if (cplan & 7 == 7) contrl()
	jmp loop1	" }

loop2:
	lac lanflg
	sma
	jms updshp	" if (!lanflg) updshp()
loop3:			" }
	fld; horizv	"[a box enclosing all code from loop3 to loop4 - scan markup]
	lac scale	"[arrow drawn from box up to location above - scan markup]
	cma
	tad vscale
	tad aexp
	dac aexp
	jms inscr
		jmp loop4 " if ((AC = inscr(horizv / 2**(vscale-scale-1)))) {
	tad o141577
	dac i clistp	"[crossed out with an arrow pointint to "dac dspvel" - scan markup]
	lac o164372	"[crossed out - scan markup]
	dac clistp i	"[crossed out - scan markup]
	cla		"[crossed out - scan markup]
	jms dsplanet	"[crossed out - scan markup] dsplanet(0)
loop4:			"[inside a drawn box - scan markup] }
	sys time "put delay here.....
"** 12-92-119.pdf page 3
	dzm dispcl	" dispcl = ""
	lac crflg
	sma
	jmp 1f		" if (crflg)
	lac o20714 "cl
	dac dispcl	" dispcl = "CL"
	jmp 2f
1:
	lac lanflg
	sma
	jmp 2f		" else if (lanflg)
	lac o114 "l
	dac dispcl	" dispcl = "L"
2:
	lac dhalt
	dac i clistp
	jmp loop " check 2-display question

contrl: 0
	lac i .pbson	" load push button flags
	xor .pbsint
	and .pbson i	" AC = (.pbson ^ .pbsint) & .pbson
	sna
	jmp noneon	" if (AC) {
	lmq
	spa ral
	sys exit	" if (pbson[0]) exit()
	sma
	jmp 1f		" if (pbson[1]) {
	dzm goflg	" goflg = false
	dzm crflg	" crflg = false
1:			" }
	lacq
	als 6
	sma ral
	jmp 1f		" if (pbson[6]) {
	spa
	jmp noneon	" if (!pbson[7]) {
	isz scale	" scale++
	nop
	jms dspsca "uprange
	jmp noneon	" }
1:			" }
	sma
	jmp noneon	" if (pbson[7]) {
	-1
	tad scale
	dac scale	" scale--
	jms dspsca "downrange
noneon:			" } }
	dzm forflg	" forflg = false
	dzm bacflg	" bacflg = false
	lac i .pbson
	dac .pbsint
	als 2
	sma
	jmp 1f		" if (pbson[2]) {
	lac dhalt
	dac forflg	" forflg = true
	lac goflg
	sma
"** 12-92-119.pdf page 4
	dzm lanflg	" if (!goflg) lanflg = false
1:			" }
	lac i .pbson
	als 3
	sma
	jmp 1f		" if (pbson[3]) {
	lac dhalt
	dac bacflg	" bacflg = true
	lac goflg
	sma
	dzm lanflg	" if (!goflg) lanflg = false
1:			" }
	lac i .pbson
	als 4
	sma
	jmp 1f		" if (pbson[4]) {
	ral
	spa
	jmp i contrl	" if (pbson[5]) return
	dzm 9f+t	" 9f+t = false
	jmp 2f
1:			" } else {
	ral
	sma
	jmp i contrl	" if (!pbson[5]) return
	lac dhalt
	dac 9f+t	" 9f+t = true
2:			" }
	fld; cphi
	fmp; sdphi
	lac 9f+t
	sma
	fng
	fst; ftmp1	" ftmp1 = cphi * sdphi * (9f+t ? 1 : -1)
	fld; sphi
	fmp; cdphi
	fad; ftmp1
	fst; ftmp2	" ftmp2 = sphi * cdphi + ftmp1
	fld; sphi
	fmp; sdphi
	lac 9f+t
	spa
	fng
	fst; ftmp1	" ftmp1 = sphi * sdphi * (9f+t ? -1 : 1)
	fld; cphi
	fmp; cdphi
	fad; ftmp1
	fst; cphi	" cphi = cphi * cdphi + ftmp1
	fld; ftmp2
	fst; sphi	" sphi = ftmp2
	jmp i contrl

t = t+1

shipxy: 0
	fld; absx
	fad; x
	fng
	fst; shipx	" shipx = -(absx + x)
	fld; absy
	fad; y
"** 12-92-119.pdf page 5
	fng
	fst; shipy	" shipy = -(absy + y)
	jmp i shipxy
