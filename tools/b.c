// b.c - B compiler for PDP-7 Unix
//
// Implemented in a subset of the C language compatible with B.
// Coding style and organization based on lastc1120c.c
//
// (C) 2016 Robert Swierczek, GPL3
//

// Just enough working to compile hello.b:
//    gcc -m32 -Wno-multichar b.c -o b
//    ./b hello.b hello.s
//    perl as7 --out a.out bl.s hello.s bi.s
//    perl a7out a.out

#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <fcntl.h>
#define eof xeof

int fin = 0;
int fout = 1;

int symtab[500] = { /* , type = 1, value = 1, name = 4 */
  1, 5,'a','u','t','o',0,
  1, 6,'e','x','t','r','n',0,
  1,10,'g','o','t','o',0,
  1,11,'r','e','t','u','r','n',0,
  1,12,'i','f',0,
  1,13,'w','h','i','l','e',0,
  1,14,'e','l','s','e',0,
  0
};

int ctab[] = {
    0,127,127,127,  0,127,127,127, /* NUL SOH STX ETX EOT ENQ ACK BEL */
  127,126,126,127,127,127,127,127, /* BS  TAB LF  VT  FF  CR  SO  SI  */
  127,127,127,127,127,127,127,127, /* DLE DC1 DC2 DC3 DC4 NAK SYN ETB */
  127,127,127,127,127,127,127,127, /* CAN EM  SUB ESC FS  GS  RS  US  */
  126, 34,122,127,127, 44, 47,121, /* SPC  !   "   #   $   %   &   '  */
    6,  7, 42, 40,  9, 41,127, 43, /*  (   )   *   +   ,   -   .   /  */
  124,124,124,124,124,124,124,124, /*  0   1   2   3   4   5   6   7  */
  124,124,  8,  1, 63, 80, 65, 90, /*  8   9   :   ;   <   =   >   ?  */
  127,123,123,123,123,123,123,123, /*  @   A   B   C   D   E   F   G  */
  123,123,123,123,123,123,123,123, /*  H   I   J   K   L   M   N   O  */
  123,123,123,123,123,123,123,123, /*  P   Q   R   S   T   U   V   W  */
  123,123,123,  4,127,  5, 48,127, /*  X   Y   Z   [   \   ]   ^   _  */
  127,123,123,123,123,123,123,123, /*  `   a   b   c   d   e   f   g  */
  123,123,123,123,123,123,123,123, /*  h   i   j   k   l   m   n   o  */
  123,123,123,123,123,123,123,123, /*  p   q   r   s   t   u   v   w  */
  123,123,123,  2, 48,  3,127,127, /*  x   y   z   {   |   }   ~  DEL */
};

/* storage */

int symbuf[10];
int peeksym = -1;
int peekc = 0;
int eof = 0;
int line = 1;
int *csym = 0;
int cval = 0;
int isn = 1;
int nerror = 0;
int nauto = 0;

int main(int argc, char **argv) {
  if (argc > 1) {
    if (argc > 2) {
      if ((fout = creat(argv[2], 0777))<0) {
        error('fo');
        exit(1);
      }
    }
    if ((fin = open(argv[1],0))<0) {
      error('fi');
      exit(1);
    }
  }

  while (!eof) {
    extdef();
//    blkend();
  }
  xflush();
  
  exit(nerror);
}

int *lookup() {
  int *np, *sp, *rp;
 
  rp = symtab;
  while (*rp) {
    np = rp + 2;
    sp = symbuf;
    while (*np==*sp) {
      if (!*np)
        return rp;
      np = np + 1;
      sp = sp + 1;
    }
    while (*np)
      np = np + 1;
    rp = np + 1;
  }
  sp = symbuf;
  np = rp + 2;
  if (np >= symtab + 490) {
    error("sf");
    exit(1);
  }
loop:
  *np = *sp;
  np = np + 1;
  sp = sp + 1;
  if (*sp)
    goto loop;
  *np = 0;
  return rp;
}

symbol() {
//  extern peeksym, peekc, eof, xread, subseq, error, line;
//  extern *csym, symbuf[], namsiz, lookup[], ctab, cval;
//  auto b, c, ct;
// char symbuf[], sp[], ctab[];
  int b, c, ct;
  int *sp;

  if (peeksym>=0) {
    c = peeksym;
    peeksym = -1;
    return(c);
  }
  if (peekc) {
    c = peekc;
    peekc = 0;
  } else {
    if (eof)
      return(0);
  else
      c = xread();
  }
loop:
  ct = ctab[c];
 
  if (ct==0) { /* EOT */
    eof++;
    return(0);
  }
 
  if (ct==126) { /* white space */
    if (c=='\n')  /* newline */
      line = line + 1;
    c = xread();
    goto loop;
  }

  if (c=='=') {
    return(subseq('=',80,60));
  }
  if (c=='<') {
    return(subseq('=',63,62));
  }
  if (c=='>') {
    return(subseq('=',65,64));
  }
  if (c=='!') {
    return(subseq('=',34,61));
  }
  if (c=='$') {
    if (subseq('(',0,1))
      return(2);
    if (subseq(')',0,1))
      return(3);
  }
  if (c=='/') {
    if (subseq('*',1,0))
      return(43);
com:
    c = xread();
com1:
    if (c==4) {
      eof++;
      error('*/'); /* end of text */
      return(0);
    }
    if (c=='\n')
      line++;
    if (c!='*')
      goto com;
    c = xread();
    if (c!='/')
      goto com1;
    c = xread();
    goto loop;
  }
  if (ct==124) {    /* number */
    cval = 0;
    if (c=='0')
      b = 8;
    else
      b = 10;
    while(c >= '0' && c <= '9') {
      cval = cval*b + c -'0';
      c = xread();
    }
    peekc = c;
    return(21);
  }
  if (c=='\'') {    /* ' */
    getcc();
    return(21);
  }
  if (ct==123) {    /* letter */
    sp = symbuf;
    while(ctab[c]==123 | ctab[c]==124) {
      if (sp<symbuf+9) *sp++ = c;
      c = xread();
    }
    *sp = '\0';
    peekc = c;
    csym = lookup();
    if (csym[0]==1) {    /* keyword */
      cval = csym[1];
      return(19);
    }
    return(20);
  }
  if (ct==127) {    /* unknown */
    error('sy');
    c = xread();
    goto loop;
  }
  return(ctab[c]);
}

subseq(c,a,b) {
  extern peekc; //    extern xread, peekc;
 
  if (!peekc)
    peekc = xread();
  if (peekc != c)
    return(a);
  peekc = 0;
  return(b);
}

getcc() {
  extern cval;
  auto c;

  cval = 0;
  if ((c = mapch('\'')) < 0) return;
  cval = c;
  if ((c = mapch('\'')) < 0) return;
  cval = cval * 512 + c;
  if ((c = mapch('\'')) >= 0)
  error('cc');
}

mapch(c) {
  extern peekc, line;
  auto a;

  if((a=xread())==c)
    return(-1);
 
  if (a=='\n' | a==0 | a==4) {
    error('cc');
    peekc = a;
    return(-1);
  }

  if (a=='*') {
    a=xread();

    if (a=='0')
      return('\0');

    if (a=='e')
      return(4);

    if (a=='(')
      return('{');

    if (a==')')
      return('}');

    if (a=='t')
      return('\t');

    if (a=='r')
      return('\r');

    if (a=='n')
      return('\n');
  }
  return(a);
}

void expr(int lev) {
  int o;

  o = symbol();
  
  if (o==21) { /* constant */
case21:
    gen('n',5); /* litrl */
    number(cval); 
    xwrite('\n');
    goto loop;
  }
   
  if (o==20) { /* name */
    if (*csym==0) { /* not seen */
//      if((peeksym=symbol())==6) { /* ( */
        *csym = 6;  /* extern */
//      }
//      else {
//        if(csym[2]==0)  /* unseen so far */
//          csym[2] = isn++;
//      }
    }
    if(*csym==6)  /* extern */
      gens('x',csym+2);
    else
      gen('a',csym[1]);
    goto loop;
  }
  
  if (o==34) { /* ! */
    expr(1);
    gen('u',4); /* unot */
    goto loop;
  }

  if (o==41) { /* - */
    peeksym = symbol();
    if (peeksym==21) { /* constant */
      peeksym = -1;
      cval = -cval;
      goto case21;
    }
    expr(1);
    gen('u',2); /* umin */
    goto loop;
  }
  
  if (o==47) { /* & */
    expr(1);
    gen('u',1); /* uadr */
    goto loop;
  }
  
  if (o==42) { /* * */
    expr(1);
    gen('u',3); /* uind */
    goto loop;
  }
  
  if (o==6) { /* ( */
    peeksym = o;
    pexpr();
    goto loop;
  }
  error('ex');

loop:
  o = symbol();

  if (lev>=14 & o==80) { /* = */
    expr(14);
    gen('b',1); /* asg */
    goto loop;
  }
  if (lev>=10 & o==48) { /* | ^ */
    expr(9);
    gen('b',2); /* bor */
    goto loop;
  }
  if (lev>=8 & o==47) { /* & */
    expr(7);
    gen('b',3); /* band */
    goto loop;
  }
  if (lev>=7 & o>=60 & o<=61) {  /* == != */
    expr(6);
    gen('b',o-56); /* beq bne */
    goto loop;
  }
  if (lev>=6 & o>=62 & o<=65) {  /* <= < >= > */
    expr(5);
    gen('b',o-56); /* ble blt bge bgt */
    goto loop;
  }  
  if (lev>=4 & o>=40 & o<=41) {  /* + - */
    expr(3);
    gen('b',o-28); /* badd bmin */
    goto loop;
  }  
  if (lev>=3 & o>=42 & o<=43) {  /* * / */
    expr(2);
    gen('b',o-27); /* bmul bdiv */
    goto loop;
  }  
  if (lev>=3 & o==44) {  /* % */
    expr(2);
    gen('b',14); /* bmod */
    goto loop;
  }  
  if (o==4) { /* [ */
    expr(15);
    if (symbol() != 5)
      error('[]');
    gen('b',12); /* badd */
    gen('u',3); /* uind */
    goto loop;
  }
  if (o==6) { /* ( */
    o = symbol();
    if (o==7) /* ) */
      gen('n',1); /* mcall */
    else {
      gen('n',2); /* mark */
      peeksym = o;
      while (o!=7) {
        expr(15);
        o = symbol();
        if (o!=7 && o!=9) { /* ) , */
          error('ex');
          return;
        }
      }
      gen('n',3);
    }
    goto loop;
  }
  
  peeksym = o;
}

declare(kw) {
//  extern csym[], symbol, paraml[], parame[];
//  extern error, cval, peeksym, exit;
//  int t[], n, o;
  int o;

  while((o=symbol())==20) {        /* name */
    *csym = kw;
#if 0
    while((o=symbol())==4) {    /* [ */
      if((o=symbol())==21) {    /* const */
        if(csym[1]>=020)
          error('de'); //error("Bad vector");
        csym[3] = cval;
        o = symbol();
      }
      if (o!=5)        /* ] */
        goto syntax;
      csym[1] += 020;
    }
#endif
    if(kw==5) {        /* auto */
      csym[1] = nauto;
      nauto++;
      *csym = -1;
    }
    if (o!=9)    /* , */
      goto done;
  }
done:
  if(o==1 | o==7)    /* ; or ')' */
    return;
syntax:
  error('[]'); //error("Declaration syntax");
}

extdef() {
//  extern eof, cval;
//  extern symbol, block, printf, pname, csym[];
//  extern error;
  auto o, c, *cs;
//  char s;

  o = symbol();
  if(o==0 | o==1)    /* EOF */
    return;

  if(o!=20)
    goto syntax;

  csym[0] = 6;
  cs = csym + 2;
  xwrite('.');
  name(cs);
  xwrite(': ');
  xwrite('.+');
  xwrite('1\n');
//  s = ".data; %p:1f\n";
  o=symbol();
  
  if (o==6) { /* ( */
    nauto = 2;
    declare(5);
    statement(1);
    gen('n',7); /* retrn */
    return;
  }

  if (o==2) { /* $( */
    peeksym = o;
    nauto = 2;
    statement(1);
    gen('n',7); /* retrn */
    return;
  }
  
  if (o==21) { /* const */
    printf(".data; %p: %o\n", cs, cval);
    if((o=symbol())!=1)    /* ; */
      goto syntax;
    return;
  }
  
  if (o==1) { /* ; */
    printf(".bss; %p: .=.+2\n", cs);
    return;
  }
  
  if (o==4) { /* [ */
    c = 0;
    if((o=symbol())==21) {    /* const */
      c = cval<<1;
      o = symbol();
    }
    if(o!=5)        /* ] */
      goto syntax;
    if((o=symbol())==1) {    /* ; */
      printf(".bss; 1:.=.+%o\n", c);
      return;
    }
    printf("1:");
    while(o==21) {        /* const */
      printf("%o\n", cval);
      c =- 2;
      if((o=symbol())==1)    /* ; */
        goto done;
      if(o!=9)        /* , */
        goto syntax;
      else
        o = symbol();
    }
    goto syntax;
done:
    if(c>0)
      printf(".=.+%o\n", c);
    return;
  }
  
  if (o==0) /* EOF */
    return;

syntax:
  error('xx');
  statement(0);
}

statement(d) {
//  extern symbol, error, blkhed, eof, peeksym;
//  extern blkend, csym[], rcexpr, block[], tree[], regtab[];
//  extern jumpc, jump, label, contlab, brklab, cval;
//  extern swp[], isn, pswitch, peekc, slabel;
//  extern efftab[], declare, deflab, swtab[], swsiz, branch;

//  int o, o1, o2, np[];
  int o, o1, o2, n, *np;

stmt:
  o = symbol();
  
  if (o==0) /* EOF */
  {
    error('fe'); //"Unexpected EOF");
    return;
  }
  
  if (o==1 || o==3) /* ; } */
    return;
  
  if (o==2) { /* { */
    if(d) {
      declist();
      gen('s',nauto); /* setop */
    }
    while (!eof) {
      o = symbol();
      if (o==3) /* } */
        return;
      peeksym = o;
      statement(0);
    }
    error('$)'); //error("Missing '}'");
    return;
  }

  if (o==19) { /* keyword */

    if (cval==10) { /* goto */
      expr(15);
      gen('n',6); /* goto */
      goto semi;
    }
    
    if (cval==11) { /* return */
      if((peeksym=symbol())==6)    /* ( */
        pexpr();
      gen('n',7); /* retrn */
      goto semi;
    }
    
    if (cval==12) { /* if */
      pexpr();
      o1 = isn;
      isn++;
      jumpc(o1);
      statement(0);
      o = symbol();
      if (o==19 & cval==14) { /* else */
        o2 = isn;
        isn++;
        jump(o2);
        label(o1);
        statement(0);
        label(o2);
        return;
      }
      peeksym = o;
      label(o1);
      return;
    }

    if (cval==13) {  /* while */
      o1 = isn;
      isn++;
      label(o1);
      pexpr();
      o2 = isn;
      isn++;
      jumpc(o2);
      statement(0);
      jump(o1);
      label(o2);
      return;
    }

    error('sx');
    goto syntax;
  }

  if (o==20) { /* name */
    if (peekc==':') {
      peekc = 0;
      if (csym[0]>0) {
        error('rd');
        goto stmt;
      }
      csym[0] = 2;
      csym[1] = 020;    /* int[] */
//      if (csym[2]==0)
//        csym[2] = isn++;
//      slabel();
      goto stmt;
    }
  }

  peeksym = o;
  expr(15);
  gen('s',nauto); /* setop */

semi:
  o = symbol();
  if (o==1)        /* ; */
    return;

syntax:
  error('sz');
  goto stmt;
}

pexpr()
{
  auto o, t;

  if ((o=symbol())==6) { /* ( */
    expr(15);
    if ((o=symbol())==7) /* ) */
      return;
  }
  error('()');
}

declist()
{
//	extern peeksym, peekc, csym[], cval;
	auto o;

	while((o=symbol())==19 & cval<10)
		declare(cval);
	peeksym = o;
}

gens(o,n) {
  xwrite(o);
  xwrite(' .');
  name(n);
  xwrite('\n');
}

gen(o,n) {
  xwrite(o);
  xwrite(' ');
  number(n);
  xwrite('\n');
}

jumpc(n) {
  xwrite('f'); /* ifop */
  xwrite(' .');
  number(n);
  xwrite('\n');
}

jump(lbl) {
  xwrite('t'); /* traop */
  xwrite(' .');
  number(lbl);
  xwrite('\n');
}

label(lbl) {
  xwrite('.');
  number(lbl);
  xwrite(': ');
  xwrite('t ');
  xwrite('.+');
  xwrite('1\n');
}

printn(n) {
  if (n > 9) {
    printn(n / 10);
    n = n % 10;
  }
  xwrite(n + '0');
}

number(x) {
  if (x < 0) {
    xwrite('-');
    x = -x;
  }
  printn(x);
}

name(int *s) {
  while (*s) {
    xwrite(*s);
    s = s + 1;
  }
}

error(code)
{
  extern line;
  int f;
  
  nerror++;
  xflush();
  f = fout;
  fout = 1;
  xwrite(code);
  xwrite(' ');
  if (code=='rd' | code=='un') {
    name(csym + 2);
    xwrite(' ');
  }
  printn(line);
  xwrite('\n');
  fout = f;
}

// runtime:

xread() {
  char buf[1];
  if (read(fin, buf, 1) <= 0)
  return 4;
  return buf[0];
}

xwrite(int c) {
  char buf[2];
  if (c & 0xff00) {
    buf[0] = (c >> 8) & 0xff;
    buf[1] = c & 0xff;
    write(fout, buf, 2);
  } else {
    buf[0] = c & 0xff;
    write(fout, buf, 1);
  }
}

xflush() {
}