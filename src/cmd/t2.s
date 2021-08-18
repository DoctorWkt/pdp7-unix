"** 13-120-147.pdf page 7
"     recognition stack frame advance

		" push stack frame: called in both recognition and generation
		" (despite above comment).
		" jump instruction following "jms advance" is saved,
		"	and executed by retreat.
		" recognition frame size is 6, generation frame size is 4.
		" 0: pointer to previous frame
		" 1: PDP-7 instr after "jms advance" (on retreat)
		" 2: saved ii (inst ptr)
		" 3: saved ignore/env
		" 4: saved j  (always overwritten by nframe in recog. mode)
		" 5: saved k

advance:0
  lac frame			" get frame pointer
  dac 8				" save in auto-increment register 8
  lac advance i			" get (retreat) instruction after "jms advance"
  dac 8 i			" save at offset 1
  lac ii			" instruction pointer
  dac 8 i			" save at offset 2
  lac ignore			" ignore mask pointer (env in recog. mode?)
  dac 8 i			" save at offset 3
  lac j				" input char pointer
  dac 8 i			" save at offset 4
  lac k				" result pointer
  dac 8 i			" save at offset 5
  lac frame			" save current frame pointer
  dac nframe i			" at nframe offset zero
  lac nframe
  dac frame			" set frame pointer to nframe (new frame)
  add dffrmsz			" add current frame size
  dac nframe			" set new new frame pointer
  dac nframe			" AGAIN??!!
  jms between; add rbot; add rtop	" check for overflow
  jms halt
  isz advance			" skip instruction after jms
  jmp advance i			" return

	" Here on failure/backup (w/ fflag set to 760000)
	" AND at (successful) end of rule
	" (exit/indirect bit set on last instr).
	" Always restores j/k on failure:
	"  (no such thing as "failure" in generation mode(?))

retreat:
  dzm junk
  lac gflag			" in generation mode?
  sza
  jmp 1f			" yes, skip bundling
  jms bundlep			" no, bundle
  dac junk			" save pointer (may be zero if no result)
1:lac frame
  dac nframe			" reset nframe to current frame pointer
  lac frame i			" fetch prev. frame pointer from current frame
  dac frame			" pop current frame
  dac 8				" save in (pre) auto-increment register 8
  lac 8 i			" restore saved instruction
  dac 3f   "retrun address
  lac 8 i
  dac ii			" restore saved instruction pointer
  lac 8 i
  dac ignore			" restore saved ignore ("env" in gen mode???)
  lac fflag			" get failure flag
  sna				" any bits set?
  jmp 2f			" no, skip
  lac 8 i   "restore j and k on failure
  dac j
  lac 8 i
  dac k
2:lac junk			" get bundle/result(s)
  sna				" got anything?
  jmp 3f			" no
  dac nframe i   "stass reslts
  isz nframe
3:jmp				" (jump following original "jms advance" call)

" bundle up results and return single pointer to them in ac
" return 0 if no results

"** 13-120-147.pdf page 8
bundlep:0
  lac fflag			" check failure flag
  sza				" clear?
  jmp 2f   "no results on failure
  jms nframe0			" yes: get initial nframe pointer
  dac 9f+t			" save
  cma				" get negative, minus one
  tad nframe			" add current value
  cma				" get nframe0 - nframe! (-N or zero)
  dac 9f+t+1			" save
  sma				" negative result?
  jmp 2f			" no, no change
  sad m1			" -1 (one result)
  jmp 3f   "only one result, no bundling necessary
  lac 9f+t			" get initial nframe
  tad m1			" decrement
  dac 8				" save in (pre-)auto-increment reg. 8

1:lac 8 i			" fetch result
  jms kput			" save in ktab
  isz  9f+t+1			" increment negative count until zero
  jmp 1b			" more left, continue
  lac k   "make up result pointer
  add l.gk			" return as gk instruction
  jmp bundlep i

2:cla				" here with no results, return zero
  jmp bundlep i
3:lac 9f+t i			" here with one result, fetch it
  jmp bundlep i
t=t+1   "where to find results
t=t+1   "negative of result count

"     the main interpreter loop
" locate original value of nframe for present stack level.
nframe0:0
  jms s1get; add d.ii		" fetch instr. at saved intruction pointer
  dac junk
  lac junk i			" fetch word referenced by instruction
  dac junk
  lac junk i			" fetch word referenced by that word!!
  and opmask			" get instruction portion
  sad l.rw			" is it an "rw" instruction?
  jmp 1f			" yes.
  lac refrsz			" no, use recog frame size as offset
  jmp 2f
1:lac junk i			" get contents of word ref'ed by rw instr
  and o17777			" get rw instr address portion (offset)
2:add frame			" make nframe pointer
  jmp nframe0 i			" return

	" halt on various error conditions:
	" various table overflows
	" console switch 15 set (trace and halt)
	" invalid recognize/generate opcodes
halt:0
  lac 1f
  jms obuild			" output "\n?"
  lac halt
  jms putoct			" output return address in octal
  lac onenl
  jms obuild			" output newline
  xct rstack+1			" execute retreat jump from initial advance?!
1:.+1;012077;end		" "\n?"; end=-1 -- two 0777 EOSes

"** 13-120-147.pdf page 9
rinterp:			" recognition mode interpreter
  las   "trace check
  and d5
  sna
  jmp .+3
  lac bugr
  jms bug			" trace

  lac fflag			" fetch failure flag
  ral				" rotate top bit into LINK
  lac ii i			" fetch current instruction
  and opmask			" get opcode
  sad l.ra			" "ra" (conditional branch on LINK set/fail)?
  jmp rera			"  yes
  sad l.rb			" "rb" (conditional branch on LINK clear/succ)?
  jmp rerb			"  yes
  szl				" LINK set (failure)?
  jmp retreat			"  yes: retreat!!
  lrs 14			" no: shift opcode bits down
  and o17			" isolate opcode bits
  add rbranch			" create indirect jmp thru rbranch tabe
  dac .+1			" save as next
  jmp

rbranch:
  jmp .+1 i
  reno
  rerx
  rerc
  regc
  rerf
  rerw
  rera
  reuu
  rero
  rerm
  rers
  rerv
  reuu
  reuu
  reuu
  reuu

reuu:				" recognition unused operation
  jms halt			" halt

rerb:				" recognition "rb" instruction
  cml				" complement LINK bit
rera:				" recognition "ra" instruction
  dzm fflag			" clear failure flag
  snl				" link bit set?
  jmp goon			"  no: continue (w/ exit check)
  jms aget			" yes: fetch address part
  dac ii			" save as new instruction pointer
  jmp rinterp			" go on (w/o exit check)

backup:				" here on failure from "rx", eof, char builtins
  lac jsav
  dac j
nuts:				" here on failure from find/prev builtins
  law				" get 0760000

"** 13-120-147.pdf page 10
  dac fflag			" set failure flag

reno:				" recognition no(op) instruction
goon:				" "go on" on success from recognition builtins, ops
  lac ii i			" fetch current instruction
  isz ii			" advance instruction pointer
  and exitmask			" was exit (indirect) bit set?
  sza
 jmp retreat			" yes, retreat/return
  jmp rinterp			" no, go on (w/o exit check)


rerw:				" recognition rw instruction (nframe0 looks for one!)
  jms aget			" get address from instruction
  add frame			" add to frame pointer
  dac nframe			" use to establish nframe
  jmp goon

rerc:				" recognition rc (call?) instruction
  jms advance; jmp goon		" push new frame, continue on retreat
  jms aget			" get address from instruction
  dac ii			" use as new instruction pointer
  jmp rinterp			" go on (w/o exit check)


gegf:				" generation gf inst (invoke builtin func)
rerf:				" recognition rf inst (invoke builtin func)
  jms aget			" get address from instruction
  add ljmp			" make into abs jmp to native code
  dac .+1
  jmp				" go to native code

rerx:				" recognition rx instruction (compare lit str)
  lac j
  dac jsav			" save j (input char pointer) in jsav
  jms aget			" get address from instruction
1:dac 9f+t
  jms lchar			" get lit character
  sad o777			" EOS?
  jmp goon			" yes, continue (success)
  dac 9f+t+1			" no, save char
  jms getj			" get next input char
sad 9f+t+1			" as expected?
  jmp 2f			" yes
  jmp backup			" no: restore j and fail.
2:lac 9f+t			" continue matching (increment lit ptr)
  add o400000
  jmp 1b
t=t+1   "address of next comparison char
t=t+1   "character itself

aget:0				" fetch address portion of current instruction
  lac ii i
  and o17777
  jmp aget i

regc:				" recognition "rc" instruction [SIC]
  lac ii i			" fetch instruction word
  and o757777			" get w/o exit bit
  xor exitmask			" set (toggle) exit bit
  dac nframe i			" save @nframe

"** 13-120-147.pdf page 11
  isz nframe			" advance nframe poiinter
  jmp goon			" succeed

	" push result in AC at "k" (kbuf)
	" called from bundlep and twice from twoktab (two word ktab entry)
	" returns w/ AC unmodified, k contains index of new entry
kput:0
  isz k
  dac junk1
  lac k
  jms between; add d0; add kmax
  jms halt			" halt on ktab overflow
  add kbot
  dac junk
  lac junk1
  dac junk i
  jmp kput i

	" fetch word from current frame using "add offset" following jms.
	" Only used by parsedo, to restore k.
s0get:0
  lac frame
  xct s0get i
  dac junk
  lac junk i
  isz s0get
  jmp s0get i

	" fetch word via ptr in current frame using "add offset" following jms.
	" Only used by nframe0, w/ "ii" instruction pointer
s1get:0
  lac frame i
  xct s1get i
  dac junk
  lac junk i
  isz s1get
  jmp s1get i

	" set word in current frame using "add offset" following jms.
	" Only used by "gk" instruction to set "ii"
s0put:0
  lmq
  lac frame
  xct s0put i
  dac junk
  lacq
  dac junk i
  isz s0put
  jmp s0put i
"     here is the generaion interpreter
"     the k table cant move while its active

geno:				" generate noop instruction
ggoon:				" "go on" from gen. builtins, ops
  lac ii i			" fetch prev instr
  isz ii			" increment
  and exitmask			" isolate exit bit
  sza
  jmp retreat			" exit bit set, return.
ginterp:
  las   "trace check
  and d6
  sna
  jmp .+3
  lac bugg
  jms bug			" trace

  lac ii i			" fetch current instruction
  lrss 14			" shift down to opcode
  and o7			" get low 3 of opcode

"** 13-120-147.pdf page 12
  add gbranch			" make indirect branch thru gbranch table
  dac .+1			" save as next instruction
  jmp

gbranch:
  jmp .+1 i
  geno
 gegx
  geuu				" was once "gz" (in bugg tab)
  gegc
  gegf
  gegk
  gegp
  gegq

geuu:				" generate ununimplemented instruction
  jms halt

	" pdp-11 analog is .txs?
gegx:				" generate "gx" instruction
  lac ii i			" fetch instruction
  and o417777			" extract character address
  jms obuild			" copy to output
  jmp ggoon			" continue (checking for exit)

	" pdp-11 analog is .tq?
gegq:				" generate "gq" instruction
  jms advance; jmp ggoon	" push state
  lac env
  add d.ii			" get addr of saved inst ptr in env
  dac junk
  jms aget			" get address portion of instruction
  add junk i			" add to env. inst ptr
  dac junk
  lac junk i			" fetch word indexed off of env inst ptr
  dac ii			" save as new instruction pointer
  lac env
  add d.env			" get addr of saved env ptr in env
  dac junk
  lac junk i			" fetch saved env ptr
  dac env			" restore env ptr
  jmp ginterp			" go on (w/o exit check)

	" pdp-11 analog is .tp?
	" execute rule called for by 1 2 ...
	" found relative to instruction counter in the k environment

gegp:				" generate "gp" instruction
  jms advance; jmp ggoon	" push current state
  lac env			" get saved env pointer
  add d.ii			" get pointer to saved instruction pointer
  dac junk			" save in temp
  lac frame i			" get prev frame pointer
  dac env			" save as env pointer
  jms aget			" get address portion of instruction
cma				" one's complement negation + one's c. add!!
  add junk i			" back up instruction pointer by inst. addr.
  dac ii
  jmp ginterp			" go on (w/o exit check)

	" NOTE only place that sets "env" w/o reading first
	" pdp-11 comment @ gk:
	" delivered compound translation
	" instruction counter is in ktable
	" set the k environment for understanding 1, 2 ...
	" to designate this frame
gegk:				" generate "gk" instruction
  lac ii i			" load instruction (value ignored)
  jms aget			" get address portion of instruction
  add kbot			" add to ktab base
  dac ii			" store as new instruction pointer
  jms s0put; add d.ii		" set frame saved instruction pointer too
  lac frame			" get frame pointer

"** 13-120-147.pdf page 13
  dac env			" save as env pointer
  jmp ginterp			" go on (w/o exit check)

gegc:				" generate "gc" (call tmg coded subroutine)
  jms advance; jmp ggoon	" push current state
  jms aget			" get address from instruction
  dac ii			" use as new instruction pointer
  jmp ginterp			" go on (w/o exit check)

	" trace routine (not a bug!)
	" invoked from rinterp if switch 15 or 17 set (mask 05)
	" invoked from ginterp if switch 15 or 16 set (mask 06)
	" calls halt if switch 15 set (mask 04)
bug:0
  dac 1f+2			" save pointer to instruction names
  lac onenl			" output newline
  jms obuild
  lac ii			" output instruction address in octal
  jms putoct
  lac ii i			" get instruction
  lrs 14	
  and o17			" get high four bits (opcode) 
  add 1f+2			" add to instruction name list pointer
  dac 1f+2			" save (into output string!)
  lac 1f+2 i			" fetch two character instruction name
  dac 1f+2			" save back into output string
  lac 1f			" get pointer to output string
  jms obuild			" output
  lac ii i			" get word referenced by instruction!!
				" (some have const/offset arg)
  jms putoct			" output in octal
  las				" get console switches
  and d4			" is bit 15 set?
  sza				" no.
  jms halt			" yes: halt (output return address, then quit)
  jmp bug i			" no: continue.

1:0400000 .+1; 040; 0; 040777	" char ptr to <SPACE> XX <SPACE> <EOS>
				" where XX will be instr name
