/* string.b - B string library

   mostly from: https://www.bell-labs.com/usr/dmr/www/btut.html
*/

strcopy(sl, s2) {
  auto i;
  i = 0;
  while (lchar(sl,i,char(s2,i)) != '*e')
    i = i+1;
  return(s1);
}

strcat(s1, s2) {
  auto i,j;
  i = j = 0;
  while (char(s1,i) != '*e')
    i = i+1;
  while(lchar(s1,i,char(s2,j)) != '*e') {
    i = i+1;
    j = j+1;
  }    
  return(s1);
}

strlen(s) {
  auto i;
  i = 0;
  while (char(s,i) != '*e')
    i = i+1;
  return(i);
}

strcmp(s1, s2) {
  auto c,i;
  i = 0;
  while ((c=char(s1,i)) == char(s2,i)) {
    if (c == '*e')
      return(0);
    i = i+1;
  }
  return(c - char(s2,i));
}

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
