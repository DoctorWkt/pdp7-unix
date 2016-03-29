/* brtb.b - B run-time library */

char(s, n) {
  if (n & 1) return ((s[n/2]/512) & 0777);
  return(s[n/2] & 0777);
}

lchar(s, n, c) {
  if (n & 1) s[n/2] = (s[n/2] & 0777) | (c*512);
  else s[n/2] = (s[n/2] & 0777000) | c;
}

putstr(s) {
  auto c, i;

  i = 0;
  while ((c = char(s,i)) != '*e') {
    putchr(c);
    i = i+1;
  }
}

/*
getstr(s) {
	auto c, i;

  i = 0;
	while ((c = getch()) != '*n' & c != '*e') {
		lchar(s,i,c);
    i = i+1;
  }
	lchar(s,i,'*e');
	return(s);
}
*/

putnum(n) {
  if (n > 9) {
    putnum(n / 10);
    n = n % 10;
  }
  putchr(n + '0');
}

printf(fmt,x1,x2,x3,x4,x5,x6,x7,x8,x9) {
  auto adx, c, i;
  
  i = 0;
  adx = &x1;
loop:
  while ((c = char(fmt,i)) != '%') {
    if (c=='*e')
      return;
    putchr(c);
    i = i+1;
  }
  i = i+1;
  c = char(fmt,i);
  if (c=='d') {
    if (*adx < 0) {
      putchr('-');
      *adx = -*adx;
    }  
    putnum(*adx);
  } else if (c=='c')
    putchr(*adx);
  else if (c=='s')
    putstr(*adx);
  else {
    putchr('%');
    goto loop;
  }
  i = i+1;
  adx = adx+1;
  goto loop;
}
