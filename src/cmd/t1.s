"** 13-120-147.pdf page 5
	" TMG
	" console switches:
	"	bit 0: do not save/dump core!!
	"	bit 15: trace first recognition or generate instruction & halt
	"	bit 16: trace all generation instructions
	"	bit 17: trace all recognition instructions
t=0
main:
  lac 017777 i
  sad d4
  jmp 2f
  sad d8
  jmp 1f
  law 9
  tad 017777
  dac 0f
  law 017
  sys creat;0:0
  dac output
1:law 5
  tad 017777
  dac 0f
  sys open;0:0;0
  dac input
  spa
  sys exit
2:
  jms advance; jmp 1f
  jmp rinterp

0:lac 2f		" get EOS
  jms obuild		" add to obuf
1:lac owrite		" here on retreat
  spa			" anything in obuf?
  jmp 0b		" no, put EOS
  jms oflush		" flush buffered output
  las			" get switches
  spa			" high bit set?
  sys exit		" yes: exit
  sys save		" no, dump core!!!!
2:o777


"special machine language code

"puts out and octal strin g from symtab entry

symoct:				" BUILTIN: (output last symtab ent in octal?)
  lac equ
  add equbot
  dac 9f+t			" save temp pointer
  lac 1f			" fetch "gf" (execute native code) inst below
  jms twoktab; lac 9f+t i	" second word is contents of word *temp
				" first word of "two word ktab" entry:
1:gf  .+1 x			" invoke native code (below), and exit
  lac ii			" fetch instruction pointer
  dac 8				" save in auto-increment register 8
  lac 8 i			" fetch word after *ii
  add symbot			" use as offset into symtab
  dac 9f+t			" save in temp

2:lac 9f+t i			" fetch symtab word *temp
  jms putoct			" output octal
  lac onenl			" output newline
  jms obuild
  lac 9f+t i
  and o600600
  sza    "skip unless word contained eof (0777)
  jmp ggoon
  
"** 13-120-147.pdf page 6
  isz 9f+t
  jmp 2b
t=t+1
o600600:0600600
