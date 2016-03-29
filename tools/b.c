/* b.c - B compiler for PDP-7 Unix

   Implemented in a subset of the C language compatible with B.
   Coding style and organization based on lastc1120c.c
 
   (C) 2016 Robert Swierczek, GPL3
 
   To compile hello.b:
      gcc -Wno-multichar b.c -o b
      ./b hello.b hello.s
      perl as7 --out a.out bl.s hello.s bi.s
      perl a7out a.out
*/

#ifdef _WIN32
#include <io.h>
#else
#include <unistd.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <fcntl.h>

/* runtime */
int fin;
int fout = 1;

void pexpr();
void error(int code);
void stmt();
void blkend();
void stmtlist();
void getcc();
void extdef();

xread() {
  char buf[1];
  if (read(fin, buf, 1) <= 0)
    return 4;
  return buf[0];
}

xwrite(c) {
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
#define eof xeof
#define read xread
#define write xwrite
#define flush xflush

main(int argc, char **argv) {
  extern symtab[], eof, *ns, nerror;
  extern fin, fout;

  if (argc > 1) {
    if (argc > 2) {
      if ((fout = creat(argv[2], 0777))<0) {
        error('fo');
        return(1);
      }
    }
    if ((fin = open(argv[1],0))<0) {
      error('fi');
      return(1);
    }
  }

  while (!eof) {
    ns = symtab + 51;
    extdef();
    blkend();
  }
  return(nerror!=0);
}

int *lookup() {
  extern symtab[], symbuf[], eof, *ns;
  auto *np, *sp, *rp;

  rp = symtab;
  while (rp < ns) {
    np = rp + 2;
    sp = symbuf;
    while (*np==*sp) {
      if (!*np)
        return(rp);
      np = np+1;
      sp = sp+1;
    }
    while (*np)
      np = np+1;
    rp = np+1;
  }
  sp = symbuf;
  if (ns >= symtab + 290) {
    error('sf');
    eof = 1;
    return(rp);
  }
  *ns = 0;
  ns[1] = 0;
  ns = ns+2;
  while (*ns = *sp) {
    ns = ns+1;
    sp = sp+1;
  }
  ns = ns+1;
  return(rp);
}

symbol() {
  extern symbuf[], ctab[], peeksym, peekc, eof, line, *csym, cval;
  auto b, c, ct, *sp;

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
    c = read();
  }
loop:
  ct = ctab[c];
 
  if (ct==0) { /* eof */
    eof = 1;
    return(0);
  }
 
  if (ct==126) { /* white space */
    if (c=='\n')
      line = line+1;
    c = read();
    goto loop;
  }

  if (c=='=')
    return(subseq('=',80,60));

  if (c=='<')
    return(subseq('=',63,62));

  if (c=='>')
    return(subseq('=',65,64));

  if (c=='!')
    return(subseq('=',34,61));

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
    c = read();
com1:
    if (c==4) {
      eof = 1;
      error('*/'); /* eof */
      return(0);
    }
    if (c=='\n')
      line = line+1;
    if (c!='*')
      goto com;
    c = read();
    if (c!='/')
      goto com1;
    c = read();
    goto loop;
  }
  if (ct==124) { /* number */
    cval = 0;
    if (c=='0')
      b = 8;
    else
      b = 10;
    while(c >= '0' & c <= '9') {
      cval = cval*b + c -'0';
      c = read();
    }
    peekc = c;
    return(21);
  }
  if (c=='\'') { /* ' */
    getcc();
    return(21);
  }
  if (ct==123) { /* letter */
    sp = symbuf;
    while(ct==123 | ct==124) {
      if (sp<symbuf+9) {
        *sp = c;
        sp = sp+1;
      }
      ct = ctab[c = read()];
    }
    *sp = 0;
    peekc = c;
    csym = lookup();
    if (csym[0]==1) {
      cval = csym[1];
      return(19); /* keyword */
    }
    return(20); /* name */
  }
  if (ct==127) { /* unknown */
    error('sy');
    c = read();
    goto loop;
  }
  return(ctab[c]);
}

subseq(c,a,b) {
  extern peekc;

  if (!peekc)
    peekc = read();
  if (peekc != c)
    return(a);
  peekc = 0;
  return(b);
}

void getcc() {
  extern cval;
  auto c;

  cval = 0;
  if ((c = mapch('\'')) < 0)
    return;
  cval = c;
  if ((c = mapch('\'')) < 0)
    return;
  cval = cval * 512 + c;
  if (mapch('\'') >= 0)
    error('cc');
}

getstr() {
  auto i, c, d;

  i = 1;
loop:
  if ((c = mapch('"')) < 0) {
    number(2048);
    write('\n');
    return(i);
  }
  if ((d = mapch('"')) < 0) {
    number(c*512+4);
    write('\n');
    return(i);
  }
  number(c*512+d);
  write('\n');
  i = i+1;
  goto loop;
}

mapch(c) {
  extern peekc;
  auto a;

  if ((a=read())==c)
    return(-1);
 
  if (a=='\n' | a==0 | a==4) {
    error('cc');
    peekc = a;
    return(-1);
  }

  if (a=='*') {
    a=read();

    if (a=='0')
      return(0);

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

void expr(lev) {
  extern peeksym, *csym, cval, isn;
  auto o;

  o = symbol();
 
  if (o==21) { /* number */
case21:
    if ((cval & 017777)==cval) {
      gen('c',cval); /* consop */
      goto loop;
    }
    gen('n',5); /* litrl */
    number(cval);
    write('\n');
    goto loop;
  }

  if (o==122) { /* string */
    write('x ');
    write('.+');
    write('2\n');
    write('t ');
    write('2f');
    write('\n');
    write('.+');
    write('1\n');
    getstr();
    write('2:');
    write('\n');
    goto loop; 
  }

  if (o==20) { /* name */
    if (*csym==0) { /* not seen */
      if ((peeksym=symbol())==6) { /* ( */
        *csym = 6; /* extrn */
      } else {
        *csym = 2; /* internal */
        csym[1] = isn;
        isn = isn+1;
      }
    }
    if (*csym==5) /* auto */
      gen('a',csym[1]);
    else {
      write('x ');
      if (*csym==6) { /* extrn */
        write('.');
        name(csym+2);
      } else { /* internal */
        write('1f');
        write('+');
        number(csym[1]);
      }
      write('\n');
    }
    goto loop;
  }
 
  if (o==34) { /* ! */
    expr(1);
    gen('u',4); /* unot */
    goto loop;
  }

  if (o==41) { /* - */
    peeksym = symbol();
    if (peeksym==21) { /* number */
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
  if (lev>=7 & o>=60 & o<=61) { /* == != */
    expr(6);
    gen('b',o-56); /* beq bne */
    goto loop;
  }
  if (lev>=6 & o>=62 & o<=65) { /* <= < >= > */
    expr(5);
    gen('b',o-56); /* ble blt bge bgt */
    goto loop;
  }
  if (lev>=4 & o>=40 & o<=41) { /* + - */
    expr(3);
    gen('b',o-28); /* badd bmin */
    goto loop;
  }
  if (lev>=3 & o>=42 & o<=43) { /* * / */
    expr(2);
    gen('b',o-27); /* bmul bdiv */
    goto loop;
  }
  if (lev>=3 & o==44) { /* % */
    expr(2);
    gen('b',14); /* bmod */
    goto loop;
  }
  if (o==4) { /* [ */
    expr(15);
    if (symbol() != 5)
      error('[]');
    gen('n',4); /* vector */
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
        if (o!=7 & o!=9) { /* ) , */
          error('ex');
          return;
        }
      }
      gen('n',3); /* call */
    }
    goto loop;
  }
 
  peeksym = o;
}

void pexpr() {
  if (symbol()==6) { /* ( */
    expr(15);
    if (symbol()==7) /* ) */
      return;
  }
  error('()');
}

void declare(kw) {
  extern *csym, cval, nauto;
  auto o;

  while((o=symbol())==20) { /* name */
    if (kw==6) { /* extrn */
      *csym = 6;
      o = symbol();
    } else { /* auto/param */
      *csym = 5; /* auto */
      csym[1] = nauto;
      o = symbol();
      if (kw==5 & o==21) { /* auto & number */
        gen('y',nauto); /* aryop */
        nauto = nauto + cval;
        o = symbol();
      }
      nauto = nauto+1;
    }
    if (o!=9) /* , */
      goto done;
  }
done:
  if (o==1 & kw!=8 | o==7 & kw==8) /* auto/extrn ;  param ')' */
    return;
syntax:
  error('[]'); /* declaration syntax */
}

void extdef() {
  extern peeksym, *csym, cval, nauto;
  auto o, c;

  o = symbol();
  if (o==0 | o==1) /* eof ; */
    return;

  if (o!=20) /* name */
    goto syntax;

  csym[0] = 6; /* extrn */
  write('.');
  name(csym + 2);
  write(':');
  o=symbol();
 
  if (o==2 | o==6) { /* $( ( */
    write('.+');
    write('1\n');
    nauto = 2;
    if (o==6) { /* ( */
      declare(8); /* param */
      if ((o=symbol())!=2) /* $( */
        goto syntax;
    }
    while((o=symbol())==19 & cval<10) /* auto extrn */
      declare(cval);
    peeksym = o;
    gen('s',nauto); /* setop */
    stmtlist();
    gen('n',7); /* retrn */
    return;
  }

  if (o==41) { /* - */
    if (symbol()!=21) /* number */
      goto syntax;
    number(-cval);
    write('\n');
    return;
  }

  if (o==21) { /* number */
    number(cval);
    write('\n');
    return;
  }

  if (o==1) { /* ; */
    write('0\n');
    return;
  }

  if (o==4) { /* [ */
    c = 0;
    if ((o=symbol())==21) { /* number */
      c = cval;
      o = symbol();
    }
    if (o!=5) /* ] */
      goto syntax;
    write('.+');
    write('1\n');
    if ((o=symbol())==1) /* ; */
      goto done;
    while (o==21 | o==41) { /* number - */
      if (o==41) { /* - */
        if (symbol()!=21)
          goto syntax;
        cval = -cval;
      }
      number(cval);
      write('\n');
      c = c-1;
      if ((o=symbol())==1) /* ; */
        goto done;
      if (o!=9) /* , */
        goto syntax;
      else
        o = symbol();
    }
    goto syntax;
done:
    if (c>0) {
      write('.=');
      write('.+');
      number(c);
      write('\n');
    }
    return;
  }

  if (o==0) /* eof */
    return;

syntax:
  error('xx');
  stmt();
}

void stmtlist() {
  extern peeksym, eof;
  auto o;

  while (!eof) {
    if ((o = symbol())==3) /* $) */
      return;
    peeksym = o;
    stmt();
  }
  error('$)'); /* missing $) */
}

void stmt() {
  extern peeksym, peekc, *csym, cval, isn, nauto;
  auto o, o1, o2;

next:
  o = symbol();

  if (o==0) { /* eof */
    error('fe'); /* Unexpected eof */
    return;
  }
 
  if (o==1 | o==3) /* ; $) */
    return;
 
  if (o==2) { /* $( */
    stmtlist();
    return;
  }

  if (o==19) { /* keyword */

    if (cval==10) { /* goto */
      expr(15);
      gen('n',6); /* goto */
      goto semi;
    }

    if (cval==11) { /* return */
      if ((peeksym=symbol())==6) /* ( */
        pexpr();
      gen('n',7); /* retrn */
      goto semi;
    }

    if (cval==12) { /* if */
      pexpr();
      o1 = isn;
      isn = isn+1;
      jumpc(o1);
      stmt();
      o = symbol();
      if (o==19 & cval==14) { /* else */
        o2 = isn;
        isn = isn+1;
        jump(o2);
        label(o1);
        stmt();
        label(o2);
        return;
      }
      peeksym = o;
      label(o1);
      return;
    }

    if (cval==13) { /* while */
      o1 = isn;
      isn = isn+1;
      label(o1);
      pexpr();
      o2 = isn;
      isn = isn+1;
      jumpc(o2);
      stmt();
      jump(o1);
      label(o2);
      return;
    }

    error('sx');
    goto syntax;
  }

  if (o==20 & peekc==':') { /* name : */
    peekc = 0;
    if (!*csym) {
      *csym = 2; /* param */
      csym[1] = isn;
      isn = isn+1;
    } else if (*csym != 2) {
      error('rd');
      goto next;
    }
    label(csym[1]);
    goto next;
  }

  peeksym = o;
  expr(15);
  gen('s',nauto); /* setop */

semi:
  o = symbol();
  if (o==1) /* ; */
    return;

syntax:
  error('sz');
  goto next;
}

void blkend() {
  extern isn;
  auto i;

  if (!isn)
    return;
  write('1:');
  i = 0;
  while (i < isn) {
    write('l');
    number(i);
    write('\n');
    i = i+1;
  }
  isn = 0;
}

gen(o,n) {
  write(o);
  write(' ');
  number(n);
  write('\n');
}

jumpc(n) {
  write('f '); /* ifop */
  write('1f');
  write('+');
  number(n);
  write('\n');
}

jump(n) {
  write('x ');
  write('1f');
  write('+');
  number(n);
  gen('\nn',6); /* goto */
}

label(n) {
  write('l');
  number(n);
  write('=.');
  write('\n');
}

printn(n) {
  if (n > 9) {
    printn(n / 10);
    n = n % 10;
  }
  write(n + '0');
}

number(x) {
  if (x < 0) {
    write('-');
    x = -x;
  }
  printn(x);
}

name(int *s) {
  while (*s) {
    write(*s);
    s = s+1;
  }
}

void error(code) {
  extern line, eof, *csym, nerror, fout;
  auto f;

  if (eof | nerror==20) {
    eof = 1;
    return;
  }
  nerror = nerror+1;
  flush();
  f = fout;
  fout = 1;
  write(code);
  write(' ');
  if (code=='rd' | code=='un') {
    name(csym + 2);
    write(' ');
  }
  printn(line);
  write('\n');
  flush();
  fout = f;
}

/* storage */

int symtab[300] = { /* class value name */
  1, 5,'a','u','t','o', 0 ,
  1, 6,'e','x','t','r','n', 0 ,
  1,10,'g','o','t','o', 0 ,
  1,11,'r','e','t','u','r','n', 0 ,
  1,12,'i','f', 0 ,
  1,13,'w','h','i','l','e', 0 ,
  1,14,'e','l','s','e', 0 };

int ctab[] = {
    0,127,127,127,  0,127,127,127,  /* NUL SOH STX ETX EOT ENQ ACK BEL */
  127,126,126,127,127,127,127,127,  /* BS  TAB LF  VT  FF  CR  SO  SI  */
  127,127,127,127,127,127,127,127,  /* DLE DC1 DC2 DC3 DC4 NAK SYN ETB */
  127,127,127,127,127,127,127,127,  /* CAN EM  SUB ESC FS  GS  RS  US  */
  126, 34,122,127,127, 44, 47,121,  /* SPC  !   "   #   $   %   &   '  */
    6,  7, 42, 40,  9, 41,127, 43,  /*  (   )   *   +   ,   -   .   /  */
  124,124,124,124,124,124,124,124,  /*  0   1   2   3   4   5   6   7  */
  124,124,  8,  1, 63, 80, 65, 90,  /*  8   9   :   ;   <   =   >   ?  */
  127,123,123,123,123,123,123,123,  /*  @   A   B   C   D   E   F   G  */
  123,123,123,123,123,123,123,123,  /*  H   I   J   K   L   M   N   O  */
  123,123,123,123,123,123,123,123,  /*  P   Q   R   S   T   U   V   W  */
  123,123,123,  4,127,  5, 48,127,  /*  X   Y   Z   [   \   ]   ^   _  */
  127,123,123,123,123,123,123,123,  /*  `   a   b   c   d   e   f   g  */
  123,123,123,123,123,123,123,123,  /*  h   i   j   k   l   m   n   o  */
  123,123,123,123,123,123,123,123,  /*  p   q   r   s   t   u   v   w  */
  123,123,123,  2, 48,  3,127,127}; /*  x   y   z   {   |   }   ~  DEL */

int symbuf[10];
int peeksym = -1;
int peekc;
int eof;
int line = 1;
int *csym;
int *ns;
int cval;
int isn;
int nerror;
int nauto;
