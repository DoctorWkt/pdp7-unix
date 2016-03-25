/* test.b - test program for B run-time library brt.s

   b test.b test.s
   echo abcABC > abc
   perl as7 --out test.out brt.s test.s bi.s
   perl a7out test.out
*/

main {
  extrn fname, fin;
  auto ch;
  
  fin = open(fname, 0);

  goto loop;
  while (ch != 04) {
    putchr(ch);
loop:
    ch = getchr();
  }
  
  flush();  
}

fname [] 'ab','c ','  ','  ';
