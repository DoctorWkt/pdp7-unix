" Subroutine to print out the number in AC as a decimal value.

   lac num
   jms decprnt
   sys exit

decprnt: 0
   cll
   idiv; 10		" Divide AC by 10
   sna			
     jmp 1f		" No remainder, stop
   tad o60		" Add ASCII '0'
   dac dbufptr i	" and save the character into the buffer
   -1			" Move pointer back a word
   tad dbufptr
   dac dbufptr
   isz count		" Bump up the count of characters
   lacq			" and move the quotient into AC
   jmp decprnt+1	" Loop back for the next digit

1: isz dbufptr		" Restore the pointer to the first digit
   lac d1		" Print as a string on stdout
   sys write; dbufptr:dbufend; count:0
   jmp decprnt i	" and return from the routine


" We set aside 5 words to buffer the characters, and we write
" from the end backwards to the front
dbuf: .=.+4		" First 4 words in the buffer
dbufend: .=.+1		" and the last word

d1: 1
d10: 10
o60: 060

num: 1234		" Test number
