" Code to test the teleprinter output. Some code borrowed from s7.s

iof = 0700002                   " PIC: interrupts off
ion = 0700042                   " PIC: interrupts on
tsf = 0700401                   " TTY: skip if flag set
tcf = 0700402                   " TTY: clear flag
tls = 0700406                   " TTY: load buffer, select

. = 020

   iof			" Interrupts off, do we need this?

1: tsf			" Is the teleprinter ready to print?
   jmp 1b		" No, loop back

   tcf			" Clear the ready flag
   jms ttyrestart	" Print out a character
   hlt			" and halt for now


ttyrestart: 0
   lac ttydelay		" Is the ttydelay positive?
   spa
     jmp ttyrestart i	" Yes, can't print the character yet
   lac nttychar
   dzm nttychar
   sza
     jmp 3f
   isz ttydelay		" Increment the tty delay towards zero
   lac d2		" Why 2?
   jms getchar		" Get a character to print
     jmp 2f		" Why the jump, does getchar skip? Yes if no char
3:
   tls			" Send the character to the teleprinter
   sad o12
     jms putcr		" It's a newline, also send a CR?
   sad o15
     skp		" It was CR, so now insert a delay
   jmp ttyrestart i	" Not CR, so return from the routine

   lac ttydelay		" Add 020 to the ttydelay
   tad o20
   rcr			" Rotate right once
   cma			" Invert the AC
   dac ttydelay		" and save back in ttydelay
   jmp ttyrestart i	" Now return from the routine
2:
   " lac sfiles+1
   " jms wakeup
   " dac sfiles+1
   jmp ttyrestart i	" Now return from the routine

getchar: 0
   lac d65		" For now, return ASCII A
   isz getchar
   jmp i getchar

putcr: 0
   lac o15
   dac nttychar
   cla
   jmp putcr i

d2: 2
d65: 64
o12: 012
o15: 015
o20: 020

ttydelay: 0
nttychar: .=.+1
