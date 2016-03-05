" Octal test: This code borrowed from ds.s to test the llss
" instruction. It should print out num in octal followed by
" a space.

   lac num
   jms octal; -3
   sys exit

octal: 0
   lmq			" Move the negative argument into the MQ
			" as we will use shifting to deal with the
			" number by shifting groups of 3 digits.

   lac d5		" By adding 5 to the negative count and
   tad octal i		" complementing it, we set the actual
   cma			" loop count up to 6 - count. So, if we
   dac c		" want to print 2 digits, we lose 6 - 2 = 4 digits
1:
   llss 3		" Lose top 3 bits of the MQ
   isz c		" Do we have any more to lose?
     jmp 1b		" Yes, keep looping
   lac octal i		" Save the actual number of print digits into c
   dac c		" as a negative number.
1:
   cla
   llss 3		" Shift 3 more bits into AC
   tad o60		" Add AC to ASCII '0'
   dac buf		" and print out the digit
   lac fd1
   sys write; buf; 1
   isz c		" Any more characters to print out?
     jmp 1b		" Yes, loop back
   lac o40		" Print out a space
   dac buf
   lac fd1
   sys write; buf; 1
   isz octal		" Move return address 1 past the argument
   jmp octal i		" and return from subroutine

fd1: 1
d5: 5
o40: 040
o60: 060
num: 0126
buf: 0
c: .=.+1
