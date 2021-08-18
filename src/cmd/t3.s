"** 13-120-147.pdf page 14
	" move characters
	" call with source address in AC
	" dest addr after "jms move" instruction
move: 0
  dac 9f+t			" save source addr
  lac move i			" get dest addr
1:dac 2f			" save dest addr after dchar call
  lac 9f+t			" restore source addr
  jms lchar			" load char
  dac 9f+t+1			" save source char
  jms dchar			" store char
2: 0				" dest addr
  lac 9f+t+1			" examine source char
  sad o777			" EOS?
  jmp 3f			" yes
  lac o400000			" get char addr increment
  add 9f+t			" add to source addr
  dac 9f+t			" save incremented source addr
  lac o400000			" get char addr increment
  add 2b			" get incremented dest addr
  jmp 1b			" go back to top of loop (save dest addr)

3:isz move			" skip dest addr arg
  lac 2b			" return dest addr
  jmp move i
t=t+1   "source address
t=t+1   "source character

				" load character
				" takes source character address in AC
lchar:0
  dac junk			" save source address
  ral				" rotate addr up (high bit into link)
  lac junk i			" fetch source word
  snl				" link set?
  lrs 9				" no: move high 9 down
  and o777			" get just 9 bits
  jmp lchar i			" return

				" deposit character
				" takes dest addr after jms instruction
dchar:0
  lmq				" save char in MQ
  lac dchar i			" get dest addr
  dac junk			" save
  spa				" high bit set?
  jmp 1f			"  yes: get mask for high 9
  llss 9			" no: shift AC/MQ up 9 (LINK fills MQ low bits)
  lac o777			" get mask for low 9
  jmp .+2
1:0777000			" get mask for high 9
  and junk i			" and dest word w/ mask
  omq				" or MQ in
  dac junk i			" deposit in dest word
  isz dchar			" increment return to skip dest addr
  jmp dchar i			" return


"     gets designated character from input
				" (reads block from disk if needed)
				" does not increment j
jget:0
1:lac j				" get input char addr [here also from jmore]
  jms cbetween; add jmin; add jmax	" in current block?
  jmp jmore			" no: not in memory, read block
  cma
  add jmin
  cma				" get j-jmin
  add jbot			" make buffer address
  jms lchar			" fetch character from buffer
  jms class; add ignore		" char in "ignore" mask?

"** 13-120-147.pdf page 15
  jmp jget i			" no: return character
  lac j				" yes: get source char addr
  add o400000			" increment
  dac j				" save
  jmp 1b			" try again (may have crossed block boundary)

" read more input - filthy code, enough to make disk &
" terminal input work.  Theae only deliver full count
" except at eof or 1 word

jmore:
and o377700			" get char offset for start of block
  dac jmin			" save as first
  add ljsiz			" add buf size
  dac 9f+t			" save in t0
  lac jmax			" get current end addr
  jms cbetween; add jmin; add 9f+t	" in range jmin<=jmax<t0?
  lac jmin			" not in range: get jmin
  dac jmax			" save as new jmax
  dac 1f			" and for seek
  cma
  add jmin			" 1's complement add!
  cma				" get jmin-jmax
  add jbot			" make buffer address
  dac 2f			" save as read dest
  lac input			" get input fd
  sys seek			" seek fd
1:0;0
  -1				" get 0777777
  dac 2f i			" save in first word of read buffer
  lac input			" get input fd
  sys read			" read (ptr, count follow)
2:0;jsiz
  sna				" get anything?
  lac d1			" zero: get 1 instead (will fetch 0777)
  add jmax			" add to block base
  dac jmax			" save as max char
  jmp jget+1			" try jget again
t=t+1

"     gets next character from input
				" called only from "rx" instruction
getj:0
  lac j				" input char addr
  jms jget			" get character
  dac junk			" save
  lac j				" increment character addr
  add o400000
  dac j
  lac junk			" return character
  jmp getj i

" compare two strings - assume both left justified
				" called only from "find"
				" takes one addr in AC, other following jms
				" skips on match(?)
comp:0
  dac 9f+t			" save first argument pointer
  lac comp i			" fetch word after jms
  dac 9f+t+1			" save second argument pointer
  isz comp			" skip argument word
1:lac 9f+t i			" top of loop: fetch word from arg1
  sad 9f+t+1 i			" compare to arg2

"** 13-120-147.pdf page 16
  jmp 3f			" identical: check for EOS
  and 9f+t+1 i   "do both start with eof?
  spa				" no: return without skip
2:isz comp			" yes, give skip return
  jmp comp i
3:and o600600  "is there an eof?
  sza				" NO
  jmp 2b			" YES: saw EOS w/ matching words: skip return
  isz 9f+t			" no EOS, increment ptr 1
  isz 9f+t+1			" increment ptr 2
  jmp 1b			" loop.
t=t+1   "address of string 1
t=t+1  "address of string 2


obuild:0			" copy string to output
  lmq				" save char addr in AC in MQ
  lac owrite			" get obuf index
  add obot			" get obuf addr
  dac 2f			" save as move dest
  lacq				" get char addr back
1:jms move			" move
2:0				" move dest
  cma				
  add obot
  cma
  dac owrite
  jms cbetween; add d0; add omax	" obuf full?
   skp				" yes
  jmp obuild i			" no: return

  lac lochunk
  jms oflush
  lac obot
  dac 2b
  add lochunk
  jmp 1b

oflush:0
  dac 2f
  lac obot
  dac 1f
  lac output
  sys write
1:0
2:0
  jmp oflush i

" outputs octal string from sesignated value

octal:				" BUILTIN
  isz ii			" increment instruction pointer
  lac ii i			" fetch instruction word
  dac 2f			" save as geoctal argument??
  lac 1f			" fetch "gf geoctal x" instr
  jms twoktab			" make two word ktab entry and goon
  lac 2f i

1:gf geoctal x
2:0				" copy of inst word after octal invocation
				" (ptr to word to output????)

"** 13-120-147.pdf page 17
geoctal:			" native code invoked by "gf" inst in ktab
  lac ii			" get instruction pointer
  dac 8				" save in auto-pre-increment reg 8
  lac 8 i			" fetch second ktab word
  jms putoct			" output as octal
  jmp ggoon			" success


" converts word in ac into ocatl on output stream

putoct:0
  dac 9f+t			" save output value
  lac 7f			" output "0"
  jms obuild
  dzm 9f+t+2			" clear non-zero digit flag
  -6
  dac 9f+t+1			" init digit count to -6

1:lac 9f+t			" get value
  cll				" clear link
  lrs 15			" get high 3 bits right justified
  add o60			" convert to ASCII digit
  dac 8f+1			" save in output buffer
  lls 18			" left justify remaining bits
  dac 9f+t			" save back in value
  lac 9f+t+2   "have nonzero digits been seen?
  sza
  jmp 2f			" yes: go output
  lac 8f+1   "no,is this nonzero?
  sad o60
  jmp 3f   "no
2:lac 8f			" output non-zero digit
  jms obuild
  law				" get 760000
  dac 9f+t+2			" save as non-zero digit seen flag
3:isz 9f+t+1			" increment digit count
  jmp 1b			"  non-zero: keep going
  jmp putoct i			" count now zero: return
t=t+1   "value to convert
t=t+1   "digit count
t=t+1   "nonzero digit flag
7: .+1; 060777			" "0" + EOS
8:0400000 .+1;0;end		" digit, two 0777 EOS bytes


eof:				" BUILTIN (succeed at EOF)
  lac j
  dac jsav			" save j
  jms jget
  sad o777			" at EOF?
  jmp goon			" yes, succeed
  jmp backup			" no, restore j from jsav, and fail
	"
	" called with jms class; add chrtabptr
	" skip on return if char in AC in referened character table
class:0
  dac junk1			" save input char
  lrss 7
  sza				" high (0200) bit of input set?
  jmp 2f			" yes, fail	
  lls 3				" get word number (16 bits per word)
  xct class i			" execute "add table" instr after "jms class"
  isz class			" skip the add on return
  dac junk			" save word pointer

"** 13-120-147.pdf page 18
  cla
  llss 4			" get low four of character (bit number)
  add l.llss			" make into lls instr
 dac 1f
  lac junk i			" get word from mask
1:llss				" shift up by bit number (into sign bit)
  spa				" bit set?
2:isz class			" yes: give skip return
  lac junk1			" restore character
  jmp class i
