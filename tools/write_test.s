" Test program for several system calls: open, read, write, close, exit
" Do:
"     ./as7 write_test.s > a.out
"     ./a7out -d a.out
main:
   " Test the lac, dac instructions
   lac in
   dac out

   " The assembler doesn't know sys write, so iot 5 for now
   lac d1
   iot 5; hello; 7

   " open file fred
   iot 3; fred; 0; 0

   " read 5 words into the buffer from stdin: type in 10 or more characters!
   lac d0
   iot 4; buf; 5

   " Stop and dump memory, so you can see five words at location 0400
   " Comment out the hlt instruction to test close and exit
   hlt

   " close stdin
   lac d0
   iot 9

   " exit
   iot 14

   " We should not get to the halt instruction
   hlt


" Some memory locations for lac and dac
. = 0100
in: 023

. = 0200
out: 0

" Hello, world\n, two ASCII chars per word
d0: 0
d1: 1
hello: 0110145; 0154154; 0157054; 040; 0167157; 0162154; 0144012

" fred as a string, NUL terminated
fred: 0146162; 0145144; 0

" Input buffer for read
. = 0400
buf: 0
