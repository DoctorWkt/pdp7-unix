# Build the kernel, the utilities, the filesystem and run SimH

include os.mk

# tools
AS=../tools/as7
ASARGS=--format=ptr
MKFS=../tools/mkfs7
A7OUT=../tools/a7out 
FSCK=../tools/fsck7
CCARGS=-Wno-multichar -Wno-implicit
PDP7=pdp7

# source dirs
SYSSRC=../src/sys
CMDSRC=../src/cmd
GAMESRC=../src/games
ALTSRC=../src/alt
OTHERSRC=../src/other
TESTSRC=../src/tests

# targets
BINDIR=bin
TESTDIR=tests
BINARIES=../binaries/

all: cmd others a.out boot.rim image.fs

# Make alternative everything: no dd but . and ..
alt: altcmd altothers boot.rim alt/a.out alt/image.fs

# The run rule has no dependencies so that the system can be booted easily
# and frequently with make run. However, you have to manually make all first!
run:
	$(PDP7) unixv0.simh

# Alternative run, use the alt/image.fs
altrun:
	$(PDP7) alt/unixv0.simh

dist: all alt
	mkdir -p $(BINARIES)
	mkdir -p $(BINARIES)/orig
	mkdir -p $(BINARIES)/alt
	cp image.fs $(BINARIES)/orig
	cp boot.rim $(BINARIES)/orig
	cp a.out $(BINARIES)/orig
	cp unixv0.simh $(BINARIES)/orig
	cp alt/image.fs $(BINARIES)/alt
	cp alt/a.out $(BINARIES)/alt
	cp alt/unixv0.simh $(BINARIES)/alt

# Warm boot Unix kernel: boots into init and a login prompt
SYS=	$(SYSSRC)/sop.s $(SYSSRC)/s1.s $(SYSSRC)/s2.s \
	$(SYSSRC)/s3.s $(SYSSRC)/s4.s $(SYSSRC)/s5.s \
	$(SYSSRC)/s6.s $(SYSSRC)/s7.s $(SYSSRC)/s8.s
a.out:	$(SYS)
	$(AS) -f ptr  -o a.out $(SYSSRC)/sop.s $(SYS)
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYS)

# Alternative kernel: no dd, but . and ..
ALTSYS=	$(SYSSRC)/sop.s $(SYSSRC)/s1.s $(ALTSRC)/s2.s \
	$(SYSSRC)/s3.s $(SYSSRC)/s4.s $(SYSSRC)/s5.s \
	$(SYSSRC)/s6.s $(SYSSRC)/s7.s $(SYSSRC)/s8.s
alt/a.out: $(ALTSYS)
	$(AS) -f ptr -o alt/a.out $(ALTSYS)
	$(AS) -n -f list -o alt/a.lst $(ALTSYS)

# Phil's bootstrap code
boot.rim: $(SYSSRC)/sop.s $(OTHERSRC)/pbboot.s
	$(AS) -f rim -o boot.rim $(SYSSRC)/sop.s $(OTHERSRC)/pbboot.s

# Cold boot Unix kernel: attempts to build a minimal filesystem.
# Don't use this one!
COLDBOOT=$(SYS) $(SYSSRC)/s9.s
coldboot.rim: $(COLDBOOT)
	$(AS) -f rim  -o coldboot.rim $(COLDBOOT)
	$(AS) -n -f list -o a.lst $(COLDBOOT)

# Filesystem image
image.fs: cmd others a.out chars.out
	$(MKFS) -k a.out -c chars.out proto
	$(FSCK) image.fs

# character table: assemble output of cas.s
chars.out: cas.out chars.s
	$(AS) --no-label-warnings -f ptr -o chars.out chars.s cas.out

# XXX TEMP: missing a bit of source?
chars.s:
	echo 'b:' > chars.s

cas.out: bin/cas cas.in
	$(A7OUT) bin/cas cas.out cas.in

cas.in:	$(CMDSRC)/cas.cas $(CMDSRC)/scope.cas
	cat $(CMDSRC)/cas.cas $(CMDSRC)/scope.cas > cas.in

# Alternate filesystem image: . and .. but no dd
alt/image.fs: altcmd altothers
	$(MKFS) -1 -2 -3 -o alt/image.fs -k alt/a.out alt/proto
	$(FSCK) -3 alt/image.fs

clean:
	rm -f boot.rim image.fs a.lst n.out a.out
	rm -f cas cas.in chars.s chars.out
	rm -f alt/image.fs alt/a.out alt/a.lst
	rm -rf $(BINDIR) $(TESTDIR) 
	rm -rf $(BINARIES)

dirs:
	mkdir -p $(BINDIR)

# The commands that came from the original scans
# PLEASE KEEP IN ALPHABETICAL ORDER!
cmd:	dirs \
	$(BINDIR)/adm \
	$(BINDIR)/apr \
	$(BINDIR)/as \
	$(BINDIR)/cas \
	$(BINDIR)/cat \
	$(BINDIR)/check \
	$(BINDIR)/chmod \
	$(BINDIR)/chown \
	$(BINDIR)/chrm \
	$(BINDIR)/cp \
	$(BINDIR)/db \
	$(BINDIR)/ds \
	$(BINDIR)/dskres \
	$(BINDIR)/dsksav \
	$(BINDIR)/dsw \
	$(BINDIR)/ed \
	$(BINDIR)/init \
	$(BINDIR)/ln \
	$(BINDIR)/ls \
	$(BINDIR)/moo \
	$(BINDIR)/nm \
	$(BINDIR)/p \
	$(BINDIR)/rm \
	$(BINDIR)/rn \
	$(BINDIR)/roff \
	$(BINDIR)/salv \
	$(BINDIR)/sh \
	$(BINDIR)/stat \
	$(BINDIR)/tm \
	$(BINDIR)/ttt \
	$(BINDIR)/un

# Alternate commands: no dd, but . and ..
altcmd: dirs cmd \
	$(BINDIR)/altchrm $(BINDIR)/cp $(BINDIR)/altinit $(BINDIR)/altmkdir

$(BINDIR)/adm: $(CMDSRC)/adm.s
	$(AS) $(ASARGS) -o $(BINDIR)/adm $(CMDSRC)/adm.s

$(BINDIR)/apr: $(CMDSRC)/apr.s
	$(AS) $(ASARGS) -o $(BINDIR)/apr $(CMDSRC)/apr.s

$(BINDIR)/as: $(CMDSRC)/as.s
	$(AS) $(ASARGS) -o $(BINDIR)/as $(CMDSRC)/as.s

$(BINDIR)/bc: $(CMDSRC)/bc.s
	$(AS) $(ASARGS) -o $(BINDIR)/bc $(CMDSRC)/bc.s

$(BINDIR)/cat: $(CMDSRC)/cat.s
	$(AS) $(ASARGS) -o $(BINDIR)/cat $(CMDSRC)/cat.s

$(BINDIR)/check: $(CMDSRC)/check.s
	$(AS) $(ASARGS) -o $(BINDIR)/check $(CMDSRC)/check.s

$(BINDIR)/chmod: $(CMDSRC)/chmod.s
	$(AS) $(ASARGS) -o $(BINDIR)/chmod $(CMDSRC)/chmod.s

$(BINDIR)/chown: $(CMDSRC)/chown.s
	$(AS) $(ASARGS) -o $(BINDIR)/chown $(CMDSRC)/chown.s

$(BINDIR)/chrm: $(CMDSRC)/chrm.s
	$(AS) $(ASARGS) -o $(BINDIR)/chrm $(CMDSRC)/chrm.s

$(BINDIR)/altchrm: $(ALTSRC)/chrm.s
	$(AS) $(ASARGS) -o $(BINDIR)/altchrm $(ALTSRC)/chrm.s

$(BINDIR)/cas: $(CMDSRC)/cas.s
	$(AS) $(ASARGS) -o $(BINDIR)/cas $(CMDSRC)/cas.s

$(BINDIR)/cp: $(CMDSRC)/cp.s
	$(AS) $(ASARGS) -o $(BINDIR)/cp $(CMDSRC)/cp.s

$(BINDIR)/db: $(CMDSRC)/db.s
	$(AS) $(ASARGS) -o $(BINDIR)/db $(CMDSRC)/db.s

$(BINDIR)/dmabs: $(CMDSRC)/dmabs.s
	$(AS) $(ASARGS) -o $(BINDIR)/dmabs $(CMDSRC)/dmabs.s

$(BINDIR)/ds: $(CMDSRC)/ds.s
	$(AS) $(ASARGS) -o $(BINDIR)/ds $(CMDSRC)/ds.s

DSKRES=$(CMDSRC)/dskres.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s
$(BINDIR)/dskres: $(DSKRES)
	$(AS) $(ASARGS) -o $(BINDIR)/dskres $(DSKRES)

DSKSAV=$(CMDSRC)/dsksav.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s
$(BINDIR)/dsksav: $(DSKSAV)
	$(AS) $(ASARGS) -o $(BINDIR)/dsksav $(DSKSAV)

$(BINDIR)/dsw: $(CMDSRC)/dsw.s
	$(AS) $(ASARGS) -o $(BINDIR)/dsw $(CMDSRC)/dsw.s

ED=$(CMDSRC)/ed1.s $(CMDSRC)/ed2.s
$(BINDIR)/ed: $(ED)
	$(AS) $(ASARGS) -o $(BINDIR)/ed $(ED)

$(BINDIR)/init: $(CMDSRC)/init.s
	$(AS) $(ASARGS) -o $(BINDIR)/init $(CMDSRC)/init.s

$(BINDIR)/ln: $(CMDSRC)/ln.s
	$(AS) $(ASARGS) -o $(BINDIR)/ln $(CMDSRC)/ln.s

$(BINDIR)/ls: $(CMDSRC)/ls.s
	$(AS) $(ASARGS) -o $(BINDIR)/ls $(CMDSRC)/ls.s

$(BINDIR)/moo: $(CMDSRC)/moo.s
	$(AS) $(ASARGS) -o $(BINDIR)/moo $(CMDSRC)/moo.s

$(BINDIR)/nm: $(CMDSRC)/nm.s
	$(AS) $(ASARGS) -o $(BINDIR)/nm $(CMDSRC)/nm.s

P=$(CMDSRC)/p1.s $(CMDSRC)/p2.s $(CMDSRC)/p3.s $(CMDSRC)/p4.s $(CMDSRC)/p5.s
$(BINDIR)/p: $(P)
	$(AS) $(ASARGS) -o $(BINDIR)/p $(P)

$(BINDIR)/rm: $(CMDSRC)/rm.s
	$(AS) $(ASARGS) -o $(BINDIR)/rm $(CMDSRC)/rm.s

$(BINDIR)/rn: $(CMDSRC)/rn.s
	$(AS) $(ASARGS) -o $(BINDIR)/rn $(CMDSRC)/rn.s

$(BINDIR)/pd: $(CMDSRC)/pd.s
	$(AS) $(ASARGS) -o $(BINDIR)/pd $(CMDSRC)/pd.s

$(BINDIR)/roff: $(CMDSRC)/roff.s
	$(AS) $(ASARGS) -o $(BINDIR)/roff $(CMDSRC)/roff.s

$(BINDIR)/salv: $(CMDSRC)/salv.s
	$(AS) $(ASARGS) -o $(BINDIR)/salv $(CMDSRC)/salv.s

$(BINDIR)/sh: $(CMDSRC)/sh.s
	$(AS) $(ASARGS) -o $(BINDIR)/sh $(CMDSRC)/sh.s

$(BINDIR)/stat: $(CMDSRC)/stat.s
	$(AS) $(ASARGS) -o $(BINDIR)/stat $(CMDSRC)/stat.s

$(BINDIR)/tm: $(CMDSRC)/tm.s
	$(AS) $(ASARGS) -o $(BINDIR)/tm $(CMDSRC)/tm.s

TTT=$(CMDSRC)/ttt1.s $(CMDSRC)/ttt2.s
$(BINDIR)/ttt: $(TTT)
	$(AS) $(ASARGS) -o $(BINDIR)/ttt $(TTT)

$(BINDIR)/un: $(CMDSRC)/un.s
	$(AS) $(ASARGS) -o $(BINDIR)/un $(CMDSRC)/un.s

################
# The commands that did not come from the scans

others: dirs \
	$(BINDIR)/b \
	$(BINDIR)/date \
	$(BINDIR)/mv \
	$(BINDIR)/od

# B compiler
$(BINDIR)/b: $(CMDSRC)/bl.s $(CMDSRC)/bi.s ../tools/b.c $(OTHERSRC)/b.b
	$(CC) $(CCARGS) -o b ../tools/b.c
	./b $(OTHERSRC)/b.b b.s
	$(AS) $(ASARGS) -o $(BINDIR)/b $(CMDSRC)/bl.s b.s $(CMDSRC)/bi.s
	rm b b.s

$(BINDIR)/date: $(OTHERSRC)/wktdate.s
	$(AS) $(ASARGS) -o $(BINDIR)/date $(OTHERSRC)/wktdate.s

$(BINDIR)/mv: $(OTHERSRC)/wktmv.s
	$(AS) $(ASARGS) -o $(BINDIR)/mv $(OTHERSRC)/wktmv.s

$(BINDIR)/od: $(OTHERSRC)/wktod.s
	$(AS) $(ASARGS) -o $(BINDIR)/od $(OTHERSRC)/wktod.s

################
# replacement programs (no longer in build)

$(BINDIR)/pbsh: $(OTHERSRC)/pbsh.s
	$(AS) $(ASARGS) -o $(BINDIR)/pbsh $(OTHERSRC)/pbsh.s

$(BINDIR)/wktcat: $(OTHERSRC)/wktcat.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktcat $(OTHERSRC)/wktcat.s

$(BINDIR)/wktcp: $(OTHERSRC)/wktcp.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktcp $(OTHERSRC)/wktcp.s

$(BINDIR)/wktln: $(OTHERSRC)/wktln.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktln $(OTHERSRC)/wktln.s

$(BINDIR)/wktls: $(OTHERSRC)/wktls.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktls $(OTHERSRC)/wktls.s

$(BINDIR)/lsd: $(OTHERSRC)/pblsd.s
	$(AS) $(ASARGS) -o $(BINDIR)/lsd $(OTHERSRC)/pblsd.s

$(BINDIR)/lsl: $(OTHERSRC)/pblsd.s
	$(AS) $(ASARGS) -o $(BINDIR)/lsl $(OTHERSRC)/pblsd.s

$(BINDIR)/wktstat: $(OTHERSRC)/wktstat.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktstat $(OTHERSRC)/wktstat.s

################
# Alternative init: no dd directory
$(BINDIR)/altinit: $(ALTSRC)/init.s
	$(AS) $(ASARGS) -o $(BINDIR)/altinit $(ALTSRC)/init.s

$(BINDIR)/altmkdir: $(ALTSRC)/wktmkdir.s
	$(AS) $(ASARGS) -o $(BINDIR)/altmkdir $(ALTSRC)/wktmkdir.s

# Alternative other commands: no dd, but . and ..
altothers: dirs cmd $(BINDIR)/wktcat $(BINDIR)/wktcp $(BINDIR)/date \
	$(BINDIR)/altls $(BINDIR)/mv $(BINDIR)/od

$(BINDIR)/altls: $(ALTSRC)/wktls.s
	$(AS) $(ASARGS) -o $(BINDIR)/altls $(ALTSRC)/wktls.s

################################################################

tests:
	mkdir -p $(TESTDIR)
	$(AS) $(ASARGS) -o $(TESTDIR)/decimal_out  $(TESTSRC)/decimal_out.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/fork_test    $(TESTSRC)/fork_test.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/octal_test   $(TESTSRC)/octal_test.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/testmul      $(TESTSRC)/testmul.s
	$(AS) $(ASARGS) -o $(TESTDIR)/write_test   $(TESTSRC)/write_test.s

runtests: tests
	$(A7OUT) $(TESTDIR)/decimal_out
	$(A7OUT) $(TESTDIR)/fork_test
	$(A7OUT) $(TESTDIR)/octal_test
#	$(A7OUT) $(TESTDIR)/testmul
#	$(A7OUT) $(TESTDIR)/write_test


