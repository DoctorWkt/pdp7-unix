/* roff - text justifier		Author: George L. Sicherman */

/*
 *	roff - C version.
 *	the Colonel.  19 May 1983.
 *
 *	Copyright 1983 by G. L. Sicherman.
 *	You may use and alter this software freely for noncommercial ends
 *	so long as you leave this message alone.
 *
 *	Fix by Tim Maroney, 31 Dec 1984.
 *	.hc implemented, 8 Feb 1985.
 *	Fix to hyphenating with underlining, 12 Feb 1985.
 *	Fixes to long-line hang and .bp by Dave Tutelman, 30 Mar 1985.
 *	Fix to centering valve with long input lines, 4 May 1987.
 */
#include <stdio.h>
#include <stdlib.h>

#define TXTLEN	(o_pl-2)
#define IDTLEN	(o_ti>=0?o_ti:o_in)
#define MAXLENGTH 255
#define UNDERL	'\200'

int spacechars[] = { ' ', '\t', '\n', 0 };
int holdword[MAXLENGTH], *holdp;
int assyline[MAXLENGTH];
int assylen;
int ehead[100], efoot[100], ohead[100], ofoot[100];
int adjtoggle;
int isrequest = 0;
int o_tr[40][2];		/* OUTPUT TRANSLATION TABLE */
int o_cc = '.';			/* CONTROL CHARACTER */
int o_hc = -1;			/* HYPHENATION CHARACTER */
int o_tc = ' ';			/* TABULATION CHARACTER */
int o_in = 0;			/* INDENT SIZE */
int o_ix = -1;			/* NEXT INDENT SIZE */
int o_ta[20] = {
	9, 17, 25, 33, 41, 49, 57, 65, 73, 81, 89, 97, 105,
	113, 121, 129, 137, 145, 153, 161};
int n_ta = 20;			/* #TAB STOPS */
int o_ll = 65, o_ad = 1, o_po = 0, o_ls = 1, o_ig = 0, o_fi = 1;
int o_pl = 66, o_ro = 0, o_hx = 0, o_sp = 0, o_sk = 0;
int o_ce = 0, o_ul = 0;
int o_li = 0, o_bp = -1, o_hy = 1;
int o_nn = 0;			/* #LINES TO SUPPRESS NUMBERING */
int o_ti = -1;			/* TEMPORARY INDENT */
int page_no = -1;
int line_no = 9999;
FILE *File;
int *request[]= {
	   (int []){'a', 'd', 0 },
	   (int []){'a', 'r', 0 },
	   (int []){'b', 'p', 0 },
	   (int []){'b', 'r', 0 },
	   (int []){'c', 'c', 0 },
	   (int []){'c', 'e', 0 },
	   (int []){'d', 's', 0 },
	   (int []){'e', 'f', 0 },
	   (int []){'e', 'h', 0 },
	   (int []){'f', 'i', 0 },
	   (int []){'f', 'o', 0 },
	   (int []){'h', 'c', 0 },
	   (int []){'h', 'e', 0 },
	   (int []){'h', 'x', 0 },
	   (int []){'h', 'y', 0 },
	   (int []){'i', 'g', 0 },
	   (int []){'i', 'n', 0 },
	   (int []){'i', 'x', 0 },
	   (int []){'l', 'i', 0 },
	   (int []){'l', 'l', 0 },
	   (int []){'l', 's', 0 },
	   (int []){'n', 'a', 0 },
	   (int []){'n', 'e', 0 },
	   (int []){'n', 'f', 0 },
	   (int []){'n', 'n', 0 },
	   (int []){'o', 'f', 0 },
	   (int []){'o', 'h', 0 },
	   (int []){'p', 'a', 0 },
	   (int []){'p', 'l', 0 },
	   (int []){'p', 'o', 0 },
	   (int []){'r', 'o', 0 },
	   (int []){'s', 'k', 0 },
	   (int []){'s', 'p', 0 },
	   (int []){'s', 's', 0 },
	   (int []){'t', 'a', 0 },
	   (int []){'t', 'c', 0 },
	   (int []){'t', 'i', 0 },
	   (int []){'t', 'r', 0 },
	   (int []){'u', 'l', 0 },
	   NULL
};
int c;				/* LAST CHAR READ */

int main(int argc, char **argv);
void mesg(int f);
void readfile(void);
int readline(void);
void bumpword(void);
void dehyph(int *s);
int reallen(int *s);
void tabulate(void);
int readreq(void);
void snset(int *par);
int tread(int *s);
void nread(int *i);
int snread(int *i, int *s, int sdef);
int cread(int *k);
void do_ta(void);
void do_tr(void);
int skipsp(void);
void writebreak(void);
void blankline(void);
void writeline(int adflag, int flushflag);
void fillline(void);
void insrt(int p);
void newpage(void);
void beginpage(void);
void endpage(void);
void blankpage(void);
void writetitle(int *t);
int *pgform(void);
int titlen(int *t, int c, int k);
void spits(int *s);
void spit(int c);
int suck(void);
int *strhas(int *p, int c);
int *strend(int *p);
int isspace(int c);
int isalnum(int c);
int isdigit(int c);
int islegal(int c);
void bomb(void);
int * Strcpy(int * s1, int * s2);
int * Strcat(int * s1, int * s2);
int Strlen(int *s);
int Strcmp(int *s1, int *s2);
void printn(int *buf, int n, int len);

int main(argc, argv)
int argc;
char **argv;
{
  while (--argc) switch (**++argv) {
	    default:
		argc++;
		goto endargs;
	}
endargs:
  assylen = 0;
  assyline[0] = '\0';
  if (!argc) {
	File = stdin;
	readfile();
  } else
	while (--argc) {
		File = fopen(*argv, "r");
		if (NULL == File) {
			fprintf(stderr, "roff: cannot read %s\n", *argv);
			exit(1);
		}
		readfile();
		fclose(File);
		argv++;
	}
  writebreak();
  endpage();
  for (; o_sk; o_sk--) blankpage();
  return(0);
}


void readfile()
{
  while (readline()) {
	if (isrequest) continue;
	if (o_ce || !o_fi) {
		if (assylen)
			writeline(0, 1);
		else
			blankline();
		if (o_ce) o_ce--;
	}
  }
}

int readline()
{
  int startline, doingword;
  isrequest = 0;
  startline = 1;
  doingword = 0;
  c = suck();
  if (c == '\n') {
	o_sp = 1;
	writebreak();
	goto out;
  } else if (isspace(c))
	writebreak();
  for (;;) {
	if (c == EOF) {
		if (doingword) bumpword();
		break;
	}
	if (c != o_cc && o_ig) {
		while (c != '\n' && c != EOF) c = suck();
		break;
	}
	if (isspace(c) && !doingword) {
		startline = 0;
		switch (c) {
		    case ' ':
			assyline[assylen++] = ' ';
			break;
		    case '\t':	tabulate();	break;
		    case '\n':	goto out;
		}
		c = suck();
		continue;
	}
	if (isspace(c) && doingword) {
		bumpword();
		if (c == '\t')
			tabulate();
		else if (assylen)
			assyline[assylen++] = ' ';
		doingword = 0;
		if (c == '\n') break;
	}
	if (!isspace(c)) {
		if (doingword)
			*holdp++ = o_ul ? c | UNDERL : c;
		else if (startline && c == o_cc && !o_li) {
			isrequest = 1;
			return readreq();
		} else {
			doingword = 1;
			holdp = holdword;
			*holdp++ = o_ul ? c | UNDERL : c;
		}
	}
	startline = 0;
	c = suck();
  }
out:
  if (o_ul) o_ul--;
  if (o_li) o_li--;
  return c != EOF;
}

/*
 *	bumpword - add word to current line.
 */

int minus[2]={'-', 0};

void bumpword()
{
  int *hc;
  *holdp = '\0';
/*
 *	Tutelman's fix #1, modified by the Colonel.
 */
  if (!o_fi || o_ce) goto giveup;
/*
 *	We use a while-loop in case of ridiculously long words with
 *	multiple hyphenation indicators.
 */
  if (assylen + reallen(holdword) > o_ll - IDTLEN) {
	if (!o_hy)
		writeline(o_ad, 0);
	else
		while (assylen + reallen(holdword) > o_ll - IDTLEN) {
/*
 *	Try hyphenating it.
 */
			if (o_hc && strhas(holdword, o_hc)) {
/*
 *	There are hyphenation marks.  Use them!
 */
				for (hc = strend(holdword); hc >= holdword; hc--) {
					if ((*hc & ~UNDERL) != o_hc)
						continue;
					*hc = '\0';
					if (assylen + reallen(holdword) + 1 >
					    o_ll - IDTLEN) {
						*hc = o_hc;
						continue;
					}

/*
 *	Yay - it fits!
 */
					dehyph(holdword);
					Strcpy(&assyline[assylen], holdword);
					Strcat(assyline, minus);
					assylen += Strlen(holdword) + 1;
					Strcpy(holdword, ++hc);
					break;	/* STOP LOOKING */
				}	/* for */
/*
 *	It won't fit, or we've succeeded in breaking the word.
 */
				writeline(o_ad, 0);
				if (hc < holdword) goto giveup;
			} else {
/*
 *	If no hyphenation marks, give up.
 *	Let somebody else implement it.
 */
				writeline(o_ad, 0);
				goto giveup;
			}
		}		/* while */
  }
giveup:
/*
 *	remove hyphenation marks, even if hyphenation is disabled.
 */
  if (o_hc) dehyph(holdword);
  Strcpy(&assyline[assylen], holdword);
  assylen += Strlen(holdword);
  holdp = holdword;
}

/*
 *	dehyph - remove hyphenation marks.
 */

void dehyph(s)
int *s;
{
  int *t;
  for (t = s; *s; s++)
	if ((*s & ~UNDERL) != o_hc) *t++ = *s;
  *t = '\0';
}

/*
 *	reallen - length of a word, excluding hyphenation marks.
 */

int reallen(s)
int *s;
{
  int n;
  n = 0;
  while (*s) n += (o_hc != (~UNDERL & *s++));
  return n;
}

void tabulate()
{
  int j;
  for (j = 0; j < n_ta; j++)
	if (o_ta[j] - 1 > assylen + IDTLEN) {
		for (; assylen + IDTLEN < o_ta[j] - 1; assylen++)
			assyline[assylen] = o_tc;
		return;
	}

  /* NO TAB STOPS REMAIN */
  assyline[assylen++] = o_tc;
}

int readreq()
{
  int req[3];
  int r, s;
  if (skipsp()) return c != EOF;
  c = suck();
  if (c == EOF || c == '\n') return c != EOF;
  if (c == '.') {
	o_ig = 0;
	do
		(c = suck());
	while (c != EOF && c != '\n');
	return c != EOF;
  }
  if (o_ig) {
	while (c != EOF && c != '\n') c = suck();
	return c != EOF;
  }
  req[0] = c;
  c = suck();
  if (c == EOF || c == '\n')
	req[1] = '\0';
  else
	req[1] = c;
  req[2] = '\0';
  for (r = 0; request[r]; r++) {
	if (!Strcmp(request[r], req)) break;
  }
  if (!request[r]) {
	do
		(c = suck());
	while (c != EOF && c != '\n');
	return c != EOF;
  }
  switch (r) {
      case 0:			/* ad */
	o_ad = 1;
	writebreak();
	break;
      case 1:			/* ar */	o_ro = 0;	break;
      case 2:			/* bp */
      case 27:			/* pa */
	c = snread(&r, &s, 1);
/*
 *	Tutelman's fix #2 - the signs were reversed!
 */
	if (s > 0)
		o_bp = page_no + r;
	else if (s < 0)
		o_bp = page_no - r;
	else
		o_bp = r;
	writebreak();
	if (line_no) {
		endpage();
		beginpage();
	}
	break;
      case 3:			/* br */	writebreak();	break;
      case 4:			/* cc */
	c = cread(&o_cc);
	break;
      case 5:			/* ce */
/*
 *	Fix to centering.  Set counter _after_ breaking!  --G.L.S.
 */
	nread(&r);
	writebreak();
	o_ce = r;
	break;
      case 6:			/* ds */
	o_ls = 2;
	writebreak();
	break;
      case 7:			/* ef */
	c = tread(efoot);
	break;
      case 8:			/* eh */
	c = tread(ehead);
	break;
      case 9:			/* fi */
	o_fi = 1;
	writebreak();
	break;
      case 10:			/* fo */
	c = tread(efoot);
	Strcpy(ofoot, efoot);
	break;
      case 11:			/* hc */
	c = cread(&o_hc);
	break;
      case 12:			/* he */
	c = tread(ehead);
	Strcpy(ohead, ehead);
	break;
      case 13:			/* hx */	o_hx = 1;	break;
      case 14:			/* hy */	nread(&o_hy);	break;
      case 15:			/* ig */	o_ig = 1;	break;
      case 16:			/* in */
	writebreak();
	snset(&o_in);
	o_ix = -1;
	break;
      case 17:			/* ix */
	snset(&o_ix);
	o_in = o_ix;
	break;
      case 18:			/* li */	nread(&o_li);	break;
      case 19:			/* ll */	snset(&o_ll);	break;
      case 20:			/* ls */	snset(&o_ls);	break;
      case 21:			/* na */
	o_ad = 0;
	writebreak();
	break;
      case 22:			/* ne */
	nread(&r);
	if (line_no + (r - 1) * o_ls + 1 > TXTLEN) {
		writebreak();
		endpage();
		beginpage();
	}
	break;
      case 23:			/* nf */
	o_fi = 0;
	writebreak();
	break;
      case 24:			/* nn */	snset(&o_nn);	break;
      case 25:			/* of */
	c = tread(ofoot);
	break;
      case 26:			/* oh */
	c = tread(ohead);
	break;
      case 28:			/* pl */	snset(&o_pl);	break;
      case 29:			/* po */	snset(&o_po);	break;
      case 30:			/* ro */	o_ro = 1;	break;
      case 31:			/* sk */	nread(&o_sk);	break;
      case 32:			/* sp */
	nread(&o_sp);
	writebreak();
	break;
      case 33:			/* ss */
	writebreak();
	o_ls = 1;
	break;
      case 34:			/* ta */	do_ta();	break;
      case 35:			/* tc */
	c = cread(&o_tc);
	break;
      case 36:			/* ti */
	writebreak();
	c = snread(&r, &s, 0);
	if (s > 0)
		o_ti = o_in + r;
	else if (s < 0)
		o_ti = o_in - r;
	else
		o_ti = r;
	break;
      case 37:			/* tr */	do_tr();	break;
      case 38:			/* ul */	nread(&o_ul);	break;
  }
  while (c != EOF && c != '\n') c = suck();
  return c != EOF;
}

void snset(par)
int *par;
{
  int r, s;
  c = snread(&r, &s, 0);
  if (s > 0)
	*par += r;
  else if (s < 0)
	*par -= r;
  else
	*par = r;
}

int tread(s)
int *s;
{
  int leadbl;
  leadbl = 0;
  for (;;) {
	c = suck();
	if (c == ' ' && !leadbl) continue;
	if (c == EOF || c == '\n') {
		*s = '\0';
		return c;
	}
	*s++ = c;
	leadbl++;
  }
}

void nread(i)
int *i;
{
  int f;
  f = 0;
  *i = 0;
  if (!skipsp()) for (;;) {
		c = suck();
		if (c == EOF) break;
		if (isspace(c)) break;
		if (isdigit(c)) {
			f++;
			*i = *i * 10 + c - '0';
		} else
			break;
	}
  if (!f) *i = 1;
}

int snread(i, s, sdef)
int *i, *s, sdef;
{
  int f;
  f = *i = *s = 0;
  for (;;) {
	c = suck();
	if (c == EOF || c == '\n') break;
	if (isspace(c)) {
		if (f)
			break;
		else
			continue;
	}
	if (isdigit(c)) {
		f++;
		*i = *i * 10 + c - '0';
	} else if ((c == '+' || c == '-') && !f) {
		f++;
		*s = c == '+' ? 1 : -1;
	} else
		break;
  }
  while (c != EOF && c != '\n') c = suck();
  if (!f) {
	*i = 1;
	*s = sdef;
  }
  return c;
}

int cread(k)
int *k;
{
  int u;
  *k = -1;
  for (;;) {
	u = suck();
	if (u == EOF || u == '\n') return u;
	if (isspace(u)) continue;
	if (*k < 0) *k = u;
  }
}

void do_ta()
{
  int v;
  n_ta = 0;
  for (;;) {
	nread(&v);
	if (v == 1)
		return;
	else
		o_ta[n_ta++] = v;
	if (c == '\n' || c == EOF) break;
  }
}

void do_tr()
{
  int *t;
  t = &o_tr[0][0];
  *t = '\0';
  if (skipsp()) return;
  for (;;) {
	c = suck();
	if (c == EOF || c == '\n') break;
	*t++ = c;
  }
  *t = '\0';
}

int skipsp()
{
  for (;;) switch (c = suck()) {
	    case EOF:
	    case '\n':
		return 1;
	    case ' ':
	    case '\t':
		continue;
	    default:
		ungetc(c, File);
		return 0;
	}
}

void writebreak()
{
  int q;
  if (assylen) writeline(0, 1);
  q = TXTLEN;
  if (o_sp) {
	if (o_sp + line_no > q)
		newpage();
	else if (line_no)
		for (; o_sp; o_sp--) blankline();
  }
}

void blankline()
{
  if (line_no >= TXTLEN) newpage();
  spit('\n');
  line_no++;
}

void writeline(adflag, flushflag)
int adflag, flushflag;
{
  int j, q;
  int lnstring[7];
  for (j = assylen - 1; j; j--) {
	if (assyline[j] == ' ')
		assylen--;
	else
		break;
  }
  q = TXTLEN;
  if (line_no >= q) newpage();
  for (j = 0; j < o_po; j++) spit(' ');
  if (o_nn) o_nn--;
  if (o_ce) for (j = 0; j < (o_ll - assylen + 1) / 2; j++)
		spit(' ');
  else
	for (j = 0; j < IDTLEN; j++) spit(' ');
  if (adflag && !flushflag) fillline();
  for (j = 0; j < assylen; j++) spit(assyline[j]);
  spit('\n');
  assylen = 0;
  assyline[0] = '\0';
  line_no++;
  for (j = 1; j < o_ls; j++)
	if (line_no <= q) blankline();
  if (!flushflag) {
	if (o_hc) dehyph(holdword);
	Strcpy(assyline, holdword);
	assylen = Strlen(holdword);
	*holdword = '\0';
	holdp = holdword;
  }
  if (o_ix >= 0) o_in = o_ix;
  o_ix = o_ti = -1;
}

void fillline()
{
  int excess, j, s, inc, spaces;
  adjtoggle ^= 1;
  if (!(excess = o_ll - IDTLEN - assylen)) return;
  if (excess < 0) {
	fprintf(stderr, "roff: internal error #2 [%d]\n", excess);
	exit(1);
  }
  for (j = 2;; j++) {
	if (adjtoggle) {
		s = 0;
		inc = 1;
	} else {
		s = assylen - 1;
		inc = -1;
	}
	spaces = 0;
	while (s >= 0 && s < assylen) {
		if (assyline[s] == ' ')
			spaces++;
		else {
			if (0 < spaces && spaces < j) {
				insrt(s - inc);
				if (inc > 0) s++;
				if (!--excess) return;
			}
			spaces = 0;
		}
		s += inc;
	}
  }
}

void insrt(p)
int p;
{
  int i;
  for (i = assylen; i > p; i--) assyline[i] = assyline[i - 1];
  assylen++;
}

void newpage()
{
  if (page_no >= 0)
	endpage();
  else
	page_no = 1;
  for (; o_sk; o_sk--) blankpage();
  beginpage();
}

void beginpage()
{
  int i;
  writetitle(page_no & 1 ? ohead : ehead);
  line_no = 0;
}

void endpage()
{
  int i;
  for (i = line_no; i < TXTLEN; i++) blankline();
  writetitle(page_no & 1 ? ofoot : efoot);
  if (o_bp < 0)
	page_no++;
  else {
	page_no = o_bp;
	o_bp = -1;
  }
}

void blankpage()
{
  int i;
  writetitle(page_no & 1 ? ohead : ehead);
  for (i = 0; i < TXTLEN; i++) spit('\n');
  writetitle(page_no & 1 ? ofoot : efoot);
  page_no++;
  line_no = 0;
}


void writetitle(t)
int *t;
{
  int d, *pst;
  int j, l, m, n;
  d = *t;
  if (o_hx || !d) {
	spit('\n');
	return;
  }
  pst = pgform();
  for (j = 0; j < o_po; j++) spit(' ');
  l = titlen(++t, d, Strlen(pst));
  while (*t && *t != d) {
	if (*t == '%')
		spits(pst);
	else
		spit(*t);
	t++;
  }
  if (!*t) {
	spit('\n');
	return;
  }
  m = titlen(++t, d, Strlen(pst));
  for (j = l; j < (o_ll - m) / 2; j++) spit(' ');
  while (*t && *t != d) {
	if (*t == '%')
		spits(pst);
	else
		spit(*t);
	t++;
  }
  if (!*t) {
	spit('\n');
	return;
  }
  if ((o_ll - m) / 2 > l)
	m += (o_ll - m) / 2;
  else
	m += l;
  n = titlen(++t, d, Strlen(pst));
  for (j = m; j < o_ll - n; j++) spit(' ');
  while (*t && *t != d) {
	if (*t == '%')
		spits(pst);
	else
		spit(*t);
	t++;
  }
  spit('\n');
}

int s_cd[]= {'c', 'd', 0 };
int s_c[]= {'c', 0 };
int s_xc[]= {'x', 'c', 0 };
int s_l[]= {'l', 0 };
int s_xl[]= {'x', 'l', 0 };
int s_x[]= {'x', 0 };
int s_ix[]= {'i', 'x', 0 };
int s_v[]= {'v', 0 };
int s_iv[]= {'i', 'v', 0 };
int s_i[]= {'i', 0 };

int *
 pgform()
{
  static int pst[11];
  int i;
  if (o_ro) {
	*pst = '\0';
	i = page_no;
	if (i >= 400) {
		Strcat(pst, s_cd);
		i -= 400;
	}
	while (i >= 100) {
		Strcat(pst, s_c);
		i -= 100;
	}
	if (i >= 90) {
		Strcat(pst, s_xc);
		i -= 90;
	}
	if (i >= 50) {
		Strcat(pst, s_l);
		i -= 50;
	}
	if (i >= 40) {
		Strcat(pst, s_xl);
		i -= 40;
	}
	while (i >= 10) {
		Strcat(pst, s_x);
		i -= 10;
	}
	if (i >= 9) {
		Strcat(pst, s_ix);
		i -= 9;
	}
	if (i >= 5) {
		Strcat(pst, s_v);
		i -= 5;
	}
	if (i >= 4) {
		Strcat(pst, s_iv);
		i -= 4;
	}
	while (i--) Strcat(pst, s_i);
  } else
	printn(pst, page_no, 11);
  return pst;
}

int titlen(t, c, k)
int *t, c;
int k;
{
  int q;
  q = 0;
  while (*t && *t != c) q += *t++ == '%' ? k : 1;
  return q;
}

void spits(s)
int *s;
{
  while (*s) spit(*s++);
}

void spit(c)
int c;
{
  static int col_no, n_blanks;
  int ulflag;
  int *t;
  ulflag = c & UNDERL;
  c &= ~UNDERL;
  for (t = (int *) o_tr; *t; t++)
	if (*t++ == c) {
/*
 *	fix - last int translates to space.
 */
		c = *t ? *t : ' ';
		break;
	}
  if (c != ' ' && c != '\n' && n_blanks) {
	for (; n_blanks; n_blanks--) {
		putc(' ', stdout);
		col_no++;
	}
  }
  if (ulflag && isalnum(c)) fputs("_\b", stdout);
  if (c == ' ')
	n_blanks++;
  else {
	putc(c, stdout);
	col_no++;
  }
  if (c == '\n') {
	col_no = 0;
	n_blanks = 0;
  }
}

int suck()
{
  for (;;) {
	c = getc(File);
	if (islegal(c)) {
	  return c;
	}
  }
}

/*
 *	strhas - does string have character?  Allow UNDERL flag.
 */

int *
 strhas(p, c)
int *p, c;
{
  for (; *p; p++)
	if ((*p & ~UNDERL) == c) return p;
  return NULL;
}

/*
 *	strend - find NULL at end of string.
 */

int *
 strend(p)
int *p;
{
  while (*p++);
  return p;
}

/*
 *	isspace, isalnum, isdigit, islegal - classify a character.
 *	We could just as well use <ctype.h> if it didn't vary from
 *	one version of Unix to another.  As it is, these routines
 *	must be modified for weird character sets, like EBCDIC and
 *	CDC Scientific.
 */

int isspace(c)
int c;
{
  int *s;
  for (s = spacechars; *s; s++)
	if (*s == c) return 1;
  return 0;
}

int isalnum(c)
int c;
{
  return(c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9');
}

int isdigit(c)
int c;
{
  return c >= '0' && c <= '9';
}

int islegal(c)
int c;
{
  return (c >= ' ' && c <= '~') || isspace(c) || c == '\n' || c == EOF;
}

void bomb()
{
  fprintf(stderr, "Usage: roff [+00] [-00] [-s] [-h] file ...\n");
  exit(1);
}

/* These str functions come from BSD code */
int * Strcpy(s1, s2)
int *s1, *s2;
{
	int *os1;

	os1 = s1;
	while ((*s1++ = *s2++))
		;
	return(os1);
}

int *
Strcat(s1, s2)
int *s1, *s2;
{
	int *os1;

	os1 = s1;
	while (*s1++)
		;
	--s1;
	while ((*s1++ = *s2++))
		;
	return(os1);
}

int Strlen(s)
int *s;
{
	int n;

	n = 0;
	while (*s++)
		n++;
	return(n);
}

int Strcmp(s1, s2)
int *s1, *s2;
{

	while (*s1 == *s2++)
		if (*s1++=='\0')
			return(0);
	return(*s1 - *--s2);
}

/* Given an int pointer to an array,
 * a number, and the array length,
 * convert the number into ASCII
 * digits and store in the array.
 * Null terminate the list.
 */
void printn(int *buf, int n, int len)
{
  /* We build the string in a temp buffer
   * and copy it into the real one. */

  int tempbuf[len];
  int *digitptr= &tempbuf[len-1];

  *digitptr-- = 0;      /* Null terminate the string */

  while (n>0) {
    *digitptr = (n%10) + '0';   /* Store a digit */
    digitptr--;
    n=n/10;
  }

  Strcpy(buf, digitptr+1);      /* Copy the tempbuf */
}
