/* test.b - test program for B run-time library brt.s brtb.b

   b test.b test.s
   b brtb.b brtb.s
   echo abcABC > abc
   perl as7 --out test.out brt.s brtb.s test.s bi.s
   perl a7out test.out
*/

/* convert command line argument into a string */
strarg(s, a) {
  auto i, c;
  i = 0;
  while (i < 8) {
    if ((c = char(a,i)) == ' ')
      goto done;
    lchar(s,i,c);
    i = i+1;
  }
done:
  lchar(s,i,'*e');
  return(s);
}

main {
  extrn fname, fin, fout, argv;
  auto ch,p,n,str 5;

  p = 017777;
  printf("mem[0%o] = 0%o*n",p,*p);
  printf("mem[0%o] = %d*n",*p,**p);
  
  printf("argv = %d*n",argv);
  printf("**argv = %d*n",*argv);
  printf("argv[0] = %d*n",argv[0]);
  n = 0;
  while (n < argv[0]) {
    n = n+1;
    printf("argv[%d] = 0%o *"%s*"*n",n,argv[n],strarg(str,argv[n]));
  }

  printf("array(0)  = 0%o*n",array(0));
  printf("array(64) = 0%o*n",array(64));
  printf("array(0)  = 0%o*n",array(0));
  
/*  fin = open(fname, 0); */
  fin = open("abc     ", 0);

  goto loop;
  while (ch != 04) {
    putchr(ch);
loop:
    ch = getchr();
  }
  
  flush();  
}

fname [] 'ab','c ','  ','  ';
