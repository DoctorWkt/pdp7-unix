"** 09-1-35.pdf page 1
jms = 0100000
"
q:0
fmp = jms q

  lac i q
  garg
  isz q
  -1
  tad aexp
  tad hexp
  dac aexp
  lac ans
  lmq
  lac ams
  sna cll
  jmp 2f
  lls 1
  dac 3f
  dac 4f
  lacq
  dac 1f
  lac hls
  lmq
  lac hms
  sna cll
  jmp 2f
  lls 1
  dac hms
  lacq
  dac hls
  lac hms
  mul
1:0
  dac ans
  lacq
  dac ce10
  lac hls
  mul
3:0
  dac ams
  lacq
  tad ce10
  glk
  dzm ce10
  tad ams
  szl cll
  isz ce10
  tad ans
  szl cll
  isz ce10
  dac ans
  lac hms
  mul
4:0
  dac ams
  lacq
  tad ans
  szl cll
  isz ce10
  lmq
  lac ce10
"** 09-1-35.pdf page 2
  tad ams
  sma
  jmp 5f
  isz aexp
  nop
  lrs 1
5:xor rsign
  dac ams
  lacq
  dac ans
  jmp i q
2:dzm aexp
  dzm ams
  dzm ans
  jmp i q
"
q:0
fdv = jms q
  lac i q
  garg
  isz q
  lac hms
  sna
  sys save
  ral
  dac 2f
  dac 3f
  dac 4f
  -1
  tad hexp
  cma
  tad aexp
  dac aexp
  lac ans
  lmq
  lac ams
  sna cll
  jmp 8f
  div
2:0
  szl
  sys save
  dac ce10
  lacq
  dac 5f
  lac ce10
  frdiv
3:0
  szl
  sys save
  lacq
  dac ce10
  lac hls
  and o377777
  frdiv
4:0
  szl
  sys save
  lacq
  dac 2b
  spa cla
"** 09-1-35.pdf page 3
  -1
  tad 2b
  cll
  mul
5:0
  dzm 2b
  spa
  isz 2b
  lls 1
  dac 3b
  lacq
  spa
  isz 3b
  skp
  isz 2b
  lac ce10
  lmq
  lac 3b
  sna
  jmp 6f
  cma
  tad d1
  stl
  tad ce10
  lmq
  szl
  isz 2b
6:lac 2b
  sma
  tad d1
  tad 5b
  sma cll
  jmp 7f
  lrs 1
  isz aexp
  nop
7:xor rsign
  dac ams
  lacq
  dac ans
  jmp i q
8:dzm aexp
  dzm ams
  jmp i q

q:0
fad = jms q
  lac i q
  garg
  isz q
  lac hms
  sna
  jmp 4f
  lac ams
  sna
  jmp 8f
7:lac aexp
  cma
  tad hexp
  sma
  jmp 5f
"** 09-1-35.pdf page 4
  dac ce10
  tad d34
  spa cla
  jmp 0f
  lac ce10
  cma
  tad d1
  xor o640500
  dac 1f
  lac hls
  lmq
  lac hms
  cll
1:lrs 0
  dac hms
  lacq
  dac hls
  lac rsign
  sma
  jmp 2f
  lac hls
  cll cma
  tad d1
  dac hls
  lac hms
  szl cma
  tad d1
  dac hms
2:lac ams
  rcr
  dac ams
  lac ans
  rar
  cll
  tad hls
  dac ans
  glk
  tad ams
  tad hms
  dac ams
  sma
  jmp 3f
  lac ans
  cma cll
  tad d1
  dac ans
  lac ams
  szl cma
  tad d1
  dac ams
  lac o400000
3:isz aexp
  nop
0:xor asign
  and o400000
  dac rsign
  fno
4:lac ams
  xor rsign
  dac ams
  jmp i q
"** 09-1-35.pdf page 5
5:jms 6f
  lac rsign
  xor asign
  dac asign
  jmp 7b
8:jms 6f
  jmp 4b
6:0
  lac ans
  lmq
  lac hls
  dac ans
  lacq
  dac hls
  lac ams
  lmq
  lac hms
  dac ams
  lacq
  dac hms
  lac hexp
  lmq
  lac aexp
  dac hexp
  lacq
  dac aexp
  jmp i 6b
"
q:0
fno = jms q
  lac ans
  sad ams
  sza cll
  jmp 1f
  dzm aexp
  dzm rsign
  jmp i q
 "
1:lmq
  lac ams
  and o200000
  sza
  jmp i q
  lac ams
  cll
  norm 36
  dac ams
  lacq
  dac ans
  lacs
  tad o777743
  cma
  tad aexp
  dac aexp
  jmp i q
"
q:0
fcp = jms q
  lac i q
  garg
  isz q
"** 09-1-35.pdf page 6
  lac rsign
  spa
  jmp 1f
  lac ams
  dac 5f
  xor asign
  dac ams
  sna
  jmp 2f
  lac hms
  sna cma
  jmp 3f
  lac hexp
  cma
  tad d1
  tad aexp
  sza
  jmp 4f
2:lac hms
  cma
3:tad d1
  tad 5f
  sza
  jmp 4f
  lac hls
  cma
  tad d1
  tad ans
  sza
4:xor asign
  jmp i q
1:lac ams
  xor d1
  jmp i q
5:0

q: 0
garg = jms q
   tad dm1
   dac 8
   lac i 8
   dac hexp
   lac i 8
   lmq
   and o377777
   dac hms
   lac i 8
   dac hls
   lacq
   xor ams
   and o400000
   dac rsign
   lac ams
   and o400000
   dac asign
   lac ams
   and o377777
   dac ams
   jmp i q

q: 0
"** 09-1-35.pdf page 7
sfmp = jms q
  lac i q
  garg
  isz q
   -1
  tad aexp
  tad hexp
  dac aexp
   lac ams
   sna rcl
   jmp 2f
   lmq
   lac hms
   sna rcl
   jmp 2f
   dac .+2
   0641122; 0
   sma
   jmp 1f
   rcr
   xor rsign
   dac ams
   isz aexp
   jmp i q
   jmp i q
1:
   xor rsign
   dac ams
   jmp i q
2:
   dzm aexp
  dzm ams
  jmp i q

q: 0
sfdv = jms q
   lac i q
   garg
   isz q
   lac hexp
   cma
   tad aexp
   tad d1
   dac aexp
   lac hms
   sna ral cll
   sys save
   dac 1f
   lac ams
   frdiv; 1: 0
   szl
   sys save
   lacq
   spa
   jmp 1f
   xor rsign
   dac ams
   jmp i q
1:
   rcr
   xor rsign
"** 09-1-35.pdf page 8
   dac ams
   isz aexp
   jmp i q
   jmp i q
q:0
   sfad = jms q
   -1
   tad i q
   isz q
   dac 8
   lac i 8
   dac hexp
   lac i 8
   sma
   jmp 1f
   xor o377777
   tad d1
1:
   lrss 1
   dac hms
   lac ams
   sma
   jmp 1f
   xor o377777
   tad d1
1:
   lrss 1
   dac ams
   lac hexp
   cma
   tad aexp
   tad d1
   sma
   jmp 1f
   cma
   tad d1
   dac tmp
   lac ams
   lmq
   lac hms
   dac ams
   lacq
   dac hms
   lac hexp
   dac aexp
   lac tmp
1:
   tad dm18
   sma
   jmp 3f
   tad o660522
   dac 1f
   lac hms
1:
   lrss 0
   dzm rsign
   tad ams
   cll sma
   jmp 1f
   lmq
   and o400000
"** 09-1-35.pdf page 9
   dac rsign
   lacq
   cma
   tad d1
   cll sma
   jmp 1f
   isz aexp
   nop
   rar
1:
   sna
   jmp 1f
   norm 18
   xor rsign
   dac ams
   lacs
   tad om60
   cma
   tad aexp
   dac aexp
   jmp i q
1:
   dzm aexp
   dzm ams
   jmp i q
3:
   lac ams
   rcl
   sma
   jmp 1f
   cma
   tad d1
   xor o400000
1:
   dac ams
   jmp i q
q: 0
fld = jms q
   -1
   tad i q
   dac 8
   lac i 8
   dac aexp
   lac i 8
   dac ams
   lac i 8
   dac ans
   isz q
   jmp i q

q: 0
fst = jms q
   -1
   tad i q
   dac 8
   lac aexp
   dac i 8
   lac ams
   dac i 8
   lac ans
   dac i 8
"** 09-1-35.pdf page 10
   isz q
   jmp i q

q: 0
fng = jms q
   lac ams
   sza
   xor o400000
   dac ams
   jmp i q

q: 0
fix = jms q
   lac aexp
   spa sna
   jmp 1f
   tad dm18
   sma
   jmp 3f
   cma
   tad o660500
   dac 2f
   lac ams
   sma
   jmp 2f
   xor o377777
   tad d1
2:
   lrss 0
   jmp i q
1:
   lac ams
   lrss 18
   jmp i q
3:
   lac ams
   and o400001
   sma
   lac o377777
   jmp i q

q: 0
flt = jms q
   dac tmp
   dzm ans
   sma
   jmp 1f
   cma
   tad d1
   spa
   cla
1:
   sza
   jmp 1f
   dzm aexp
   dzm ams
   jmp 2f
1:
   clq
   norm 36
   dac ams
"** 09-1-35.pdf page 11
   lacs
   tad om56
   cma
   dac aexp
2:
   lac tmp
   and o400000
   xor ams
   dac ams
   jmp i q

tmp: 0
stmp: 0
ce10: 0
asign: 0
aexp: 0
ams: 0
ans: 0
hexp: 0
hms: 0
hls: 0

q: 0
sin = jms q
   lac ams
   and o400000
   dac sign
   lac ams
   and o377777
   dac ams
   fst; ftmp1
   fdv; fpi
   fix
   dac stmp
   and d1
   sna
   jmp 1f
   lac o400000
   xor sign
   dac sign
1:
   lac stmp
   flt
   fmp; fpi
   fng
   fad; ftmp1
   fst; strm
   fst; sres
   fst; ftmp2
   fld; fp1
   fst; sfac
   -6
   dac scnt
1:
bsin:
   fld; sfac
   fad; fp1
   fst; ftmp1
   fad; fp1
   fst; sfac
   fld; strm
"** 09-1-35.pdf page 12
   fmp; ftmp2
   fmp; ftmp2
   fdv; sfac
   fdv; ftmp1
   fng
   fst; strm
   fad; sres
   fst; sres
   isz scnt
   jmp 1b
   lac ams
   xor sign
   dac ams
   jmp i q

q: 0
sqrt = jms q
   lac aexp
   tad d1
   llss 0
   rar
   dac aexp
   lac ans
   lmq
   lac ams
   spa
   sys save
   dac 1f
   snl
   jmp 5f
   lls 1
   dac ams
   lacq
   dac ans
5:
   lac 1f
   sna
   jmp q i
   snl cll
   xor o200000
   xor o400000
   dac 1f
   lac ams
   frdiv; 1:..
   szl
   clq
   lacq
   tad 1b
   rar
   cll
   dac 2f
   lac ams
   frdiv; 2:..
   szl
   clq
   lacq
   tad 2b
   rar
   dac 3f
   dac 4f
   lac ans
"** 09-1-35.pdf page 13
   lmq
   lac ams
   cll
   div; 3:..
   szl
   clq ecla
   dac 1b
   lacq
   tad 3b
   clq lrs 1
   cll
   lrs 1
   dac ams
   lacq
   dac 2b
   lac 1b
   frdiv; 4:..
   szl
   sys save
   lacq
   lrs 2
   tad 2b
   dac ans
   jmp q i

sfac: 0;0;0
ftmp1: 0;0;0
ftmp2: 0;0;0
strm: 0;0;0
scnt: 0
sres: 0;0;0
rsign: 0
sign: 0

fp1: 1;0200000;0

o400000: 0400000
o640500: 0640500
o200000: 0200000
d34: 34
o777743: 0777743
o2: 02
o377777: 0377777
dm18: -18
o377777: 0377777
om60: -060
o660522: 0660522
o660500: 0660500
o400001: 0400001
dm1: -1
om56: -056
fpi: 2;0311037; 0552421
fpid2: 1; 0311037;0552421
buf:
cgarg = garg-jms
cfmp = fmp-jms
cfdv = fdv-jms
cfad = fad-jms
cfno = fno-jms
cfcp = fcp-jms
csfmp = sfmp-jms
"** 09-1-35.pdf page 14
csfdv = sfdv-jms
csfad = sfad-jms
cfld = fld-jms
cfst = fst-jms
cfng = fng-jms
cfix = fix-jms
cflt = flt-jms
csin = sin-jms
