"** 13-120-147.pdf page 21
char:				" BUILTIN: match one char from bitset or fail.
  lac j
  dac jsav
 isz ii
  jms ctest
 jmp backup			" not in bitset: restore j from jsav, fail
  jmp goon

string:				" BUILTIN: match zero or more chars from bitset
  isz ii
  jms ctest
  jmp goon			" not in bitset, quit (but do not fail)
  jmp string+1

ctest:0
  jms jget
  jms class; add ii i		" bitset check w/ table ptr *ii
  jmp ctest i			" char not in bitset, return w/o skip
  jms sbput			" matched: add to symbuf
  lac j				" increment j (char ptr)
  add o400000
  dac j
  isz ctest			" give skip return
  jmp ctest i

mark:				" BUILTIN: clear symbuf
  jms jget			" consume ignored characters
  dzm sbwrite
  jmp goon

parsedo:			" BUILTIN: invoke rule
  isz ii
  jms advance; jmp 3f		" on retreat restore k
  jms advance; jmp 1f		" on retreat switch to generation
  jms aget			" get new instruction pointer
  dac ii
  jmp rinterp

1:lac frame			" on retreat (second advance call)
  add refrsz
  dac ii			" set instruction pointer to "nframe"
  sad nframe			" was anything pushed onto nframe??
  jmp retreat			" no: retreat again.
  dac gflag			" yes: set gflag (don't bundle on retreat)
  lac gefrsz
  dac dffrmsz			" change (advance) frame size to generate size
  jms advance; jmp 2f		" on retreat switch back to recognition mode
  jmp ginterp			" interpret generate instructions!

2:lac refrsz			" on retreat from generate mode
  dac dffrmsz			" switch back to recognition sized frames
  add frame
  dac nframe			" reset nframe pointer
  dzm gflag			" clear gflag (resume bundling on retreat)
  jmp retreat			" retreat (again)!!

3:jms s0get; add d.k		" on retreat (first advance call)
  dac k				" restore k from current frame
  jmp goon

bundle:				" BUILTIN: bundle results
  jms bundlep			" get bundle of results (if more than one)

"** 13-120-147.pdf page 22
  dac 9f+t
  sna				" got any?
  jmp goon			" nope.
  jms nframe0
  dac nframe
  lac 9f+t
  dac nframe i
  isz nframe
  jmp goon
t=t+1

"   jms between;add a; add b; skip if a<=ac<b

between:0
  dac 9f+t
  cma
  xct between i
  isz between
  sma
  jmp 1f
  lac 9f+t
  cma
  xct between i
  isz between
  sma
1:isz between
  lac 9f+t
  jmp between i
t=t+0   "shared with next temporary



"  jms cbetween; add a; add b; skip if a<=ac<b where ac
"   contains a character address

cbetween:0
  dac 9f+t
  cma
  xct cbetween i
  isz cbetween
  ral
  sma
  jmp 1f
  lac 9f+t
  cma
  xct cbetween i
  isz cbetween
  ral
  sma
1:isz cbetween
  lac 9f+t
  jmp cbetween i
t=t+1   "ac contents
