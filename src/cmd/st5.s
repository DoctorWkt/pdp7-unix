"** 12-92-119.pdf page 19
" space travel 5

dsplanet: 0		" display planet center
	tad points	" add points address to ac (planet index)
	dac 9f+t
	lac i 9f+t
	dac i clistp	" set planet brightness
	lac o246256
	dac i clistp
	lac o253052
	dac i clistp
	lac o246036
	dac i clistp
	jmp dsplanet i

dispname: 0		" display planet name
	tad names	" add names address to ac (planet index)
	dac 9f+t
	lac i 9f+t
	tad dm1
	dac 8
	law namedsp-1
	dac 9
	-10
	dac 9f+t
1:
	lac i 8
	sna
	jmp 2f
	dac 9f+t+1
	lrss 9
	dac i 9
	isz 9f+t
	skp
	jmp i dispname
	lac 9f+t+1
	and o177
	sna
	jmp 2f
	dac i 9
	isz 9f+t
	jmp 1b
	jmp i dispname
2:
	dzm i 9
	isz 9f+t
	jmp 2b
	jmp i dispname

t = t+2

dspsca: 0		" display scale
	lac scale	" AC = scale
	sma
	jmp 1f		" if (scale < 0) {
	lac o55 "-
	dac dssca	" dssca[0] = '-'
	-1
	tad scale
	cma		" AC = -AC
	jmp 2f
1:			" } else {
"** 12-92-119.pdf page 20
	lac o53 "+
	dac dssca	" dssca[0] = '+'
	lac scale
2:			" }
	cll; idiv; 10
	tad o60
	dac dssca+2	" dssca[2] = (AC % 10) + '0'
	lacq
	tad o60
	dac dssca+1	" dssca[1] = (AC / 10) + '0'
	jmp i dspsca
