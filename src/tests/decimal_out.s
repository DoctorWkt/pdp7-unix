" Routine to print AC in decimal
   lac testnum		" Print an example number
   jms decprnt; -5	" with five digits
   sys exit


decprnt: 0
   dac num
   lac endptr		" Point at the end of the buffer
   dac dbufptr
   dzm count		" and set no characters so far
   lac num
1: cll
   sza			" Is there anything left in the number?
     jmp 3f
   lac o60		" No, so put a space into the buffer
   jmp 4f

3: idiv; 10		" Divide AC by 10
   tad o60		" Add ASCII '0'
4: dac dbufptr i	" and save the character into the buffer
   -1			" Move pointer back a word
   tad dbufptr
   dac dbufptr
   isz count		" Bump up the count of characters
   lacq			" and move the quotient into AC
   isz decprnt i	" Add 1 to the # digits the user wants
     jmp 1b		" Loop back for the next digit

5: isz dbufptr		" Restore the pointer to the first digit
   lac d1		" Print as a string on stdout
   sys write; dbufptr:dbufend; count:0
   isz decprnt
   jmp decprnt i	" and return from the routine

" We set aside 5 words to buffer the characters, and we write
" from the end backwards to the front
dbuf: .=.+4		" First 4 words in the buffer
dbufend: 0		" and the last word
endptr: dbufend

d1: 1
o40: 040
o60: 060
num: 0
zero: 0>

testnum: 1234
