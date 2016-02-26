" Simple cat program: echo stdin to stdout until no more words to read

main:
   " Read 5 words into the buffer from stdin
   lac d0
   sys read; buf; 5
   spa			" Skip if result was >= 0
     jmp error		" Result was -ve, so error result
   sna			" Skip if result was >0
     jmp end		" Result was zero, so nothing left to read

   " Save the count of words read in
   dac 1f

   " Write 5 words from the buffer to stdout
   lac d1
   sys write; buf; 1:0
   jmp main

error:
end:
   " exit
   sys exit

d0: 0
d1: 1

" Input buffer for read
buf: 0; 0; 0; 0; 0
