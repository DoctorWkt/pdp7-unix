"** 13-120-147.pdf page 19
"     put symbuf symbol into table

table:				" BUILTIN
  lac equwrite			" get equtab write index
  dac equ			" save as last found
  jms between; add d0; add equmax
  jms halt			" overflow
  add delta			" increment
  dac equwrite			" save as next to write
  lac equ			" get our entry index
  add equbot			" get our entry address
  tad m1			" decrement for pre-auto-increment
  dac 8				" save in auto-increment reg
  lac symwrite			" get name index into symtab
  dac 8 i			" save in equtab
  add symbot			" get symtab addr
  dac 2f			" save as move dest
  lac mdelta			" get negative equtab entry word count
1:dzm 8 i			" zero equtab word
  tad d1			" increment count
  spa				" positive?
  jmp 1b			"  no, loop and zero another
  lac sbbot			" yes, get symbuf base
  jms move			" copy string into symtab (string table)
2:0
  add o400000			" increment char addr
  cma
add symbot
  cma
  add o400000
  and o17777
  dac symwrite			" save new symtab write pointer
  jms between; add d0; add symmax
  jms halt			" symtab overflow
  jmp goon			" success

"     find occurrence of symbuf symbol in equtab

prev:				" BUILTIN
  lac equ			" last entry found/created
  jmp find+1			" start search
find:				" BUILTIN
  lac equwrite			" get end index to equ table
  dac 9f+t			" save
  lac o777			" get EOS
  jms sbput			" append to sbbuf
  lac sbbot			" get sbbuf base
  dac 2f			" stash as "comp" argument 2 (loop invariant)
1:lac 9f+t			" get equbuf index
  tad mdelta			" decrement (by two)
  dac 9f+t			" save
  spa				" still positive?
  jmp nuts			"  no: return failure
  add equbot			" turn into equbuf pointer
  dac junk			" save as temp
  lac junk i			" get symtab entry offset
  add symbot			" get symtab entry address
  jms comp			" compare
2:0				" compare arg2 here
  jmp 1b			" non-skip return: continue
  lac 9f+t			" skipped: get offset
  dac equ			" save as last found

"** 13-120-147.pdf page 20
  jmp goon			" success!
t=t+1 "next equtab location to test

sbput:0				" put character in AC into symbuf (sbbuf)
  lmq				" save character in MQ
  lac sbwrite			" get sbbut write index
  add sbbot			" add to start of sbbuf
  dac 1f			" save as dchar dest
  lacq				" get char back
  jms dchar			" save
1:0
  lac sbwrite			" get sbbuf write index
  add o400000			" increment
  dac sbwrite			" save back
  jms cbetween; add d0; add sbmax
  jms halt			" sbbuf overflow
  jmp sbput i

getname:			" BUILTIN
  lac equ			" get last entry index
  add equbot			" get equtab addr (addr of pointer to string)
  dac 9f+t			" save in temp
  lac 1f			" get "gf" instruction
  jms twoktab; lac 9f+t i

1:gf .+1 x			" jump to native code & exit
  lac ii			" get instruction pointer
  dac 8				" save in auto-pre-increment reg 8
  lac 8 i			" fetch next word (symtab index)
  add symbot			" make pointer into symtab
  and o17777			" get just address
  jms obuild			" send to output
  jmp ggoon			" success
t=t+1   "equtable entry

" puts double word entries in ktab and gives
"pointer to first as result
		" takes first word (addr for gk instr) in AC
		" and indirect load instr after "jms twoktab"
		" called (as final action) by generate builtins?
		" DOES NOT RETURN!!!
twoktab:0
  jms kput			" save in ktab
  lac l.gk
  add k				" make gk intruction, pointing to new entry
dac nframe i			" push onto nframe
  isz nframe
  xct twoktab i			" execute lac i instruction after "jms twoktab"
  jms kput			" save in ktab as second word
  jmp goon			" success
