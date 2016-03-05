package com.khubla.pdp7parse;

/*
 * Copyright 2016, Tom Everett <tom@khubla.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
public class Opcode {
   public static int dac = 0040000;
   public static int jms = 0100000;
   public static int dzm = 0140000;
   public static int lac = 0200000;
   public static int xor = 0240000;
   public static int add = 0300000;
   public static int tad = 0340000;
   public static int xct = 0400000;
   public static int isz = 0440000;
   public static int and = 0500000;
   public static int sad = 0540000;
   public static int jmp = 0600000;
   public static int nop = 0740000;
   public static int i = 020000;
   public static int law = 0760000;
   public static int cma = 0740001;
   public static int las = 0750004;
   public static int ral = 0740010;
   public static int rar = 0740020;
   public static int hlt = 0740040;
   public static int sma = 0740100;
   public static int sza = 0740200;
   public static int snl = 0740400;
   public static int skp = 0741000;
   public static int sna = 0741200;
   public static int szl = 0741400;
   public static int rtl = 0742010;
   public static int rtr = 0742020;
   public static int cll = 0744000;
   public static int rcl = 0744010;
   public static int rcr = 0744020;
   public static int cla = 0750000;
   public static int lrs = 0640500;
   public static int lrss = 0660500;
   public static int lls = 0640600;
   public static int llss = 0660600;
   public static int als = 0640700;
   public static int alss = 0660700;
   public static int mul = 0653323;
   public static int idiv = 0653323;
   public static int lacq = 0641002;
   public static int clq = 0650000;
   public static int omq = 0650002;
   public static int cmq = 0650004;
   public static int lmq = 0652000;
   public static int dscs = 0707141;
   public static int dslw = 0707124;
   public static int dslm = 0707142;
   public static int dsld = 0707104;
   public static int dsls = 0707144;
   public static int dssf = 0707121;
   public static int dsrs = 0707132;
   public static int iof = 0700002;
   public static int ion = 0700042;
   public static int caf = 0703302;
   public static int clon = 0700044;
   public static int clsf = 0700001;
   public static int clof = 0700004;
   public static int ksf = 0700301;
   public static int krb = 0700312;
   public static int tsf = 0700401;
   public static int tcf = 0700402;
   public static int tls = 0700406;
   public static int sck = 0704301;
   public static int cck = 0704304;
   public static int lck = 0704312;
   public static int rsf = 0700101;
   public static int rsa = 0700104;
   public static int rrb = 0700112;
   public static int psf = 0700201;
   public static int pcf = 0700202;
   public static int psa = 0700204;
   public static int cdf = 0700501;
   public static int lds = 0701052;
   public static int lda = 0701012;
   public static int wcga = 0704206;
   public static int raef = 0700742;
   public static int rlpd = 0700723;
   public static int beg = 0700547;
   public static int spb = 0704401;
   public static int cpb = 0704404;
   public static int lpb = 0704412;
   public static int wbl = 0704424;
   public static int dprs = 0704752;
   public static int dpsf = 0704741;
   public static int dpcf = 0704761;
   public static int dprc = 0704712;
   public static int crsf = 0706701;
   public static int crrb = 0706712;
}
