# Build the kernel, the utilities, the filesystem and run SimH

include os.mk

# tools
AS=../tools/as7
ASARGS=--format=ptr
MKFS=../tools/mkfs7
A7OUT=../tools/a7out 
FSCK=../tools/fsck7
BFLAGS=-Wno-multichar -Wno-implicit
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

# The run rule has no dependencies so that the system can be booted easily
# and frequently with make run. However, you have to manually make all first!
run:
	$(PDP7) unixv0.simh

dist:	all
	mkdir -p $(BINARIES)
	mkdir -p $(BINARIES)/orig
	mkdir -p $(BINARIES)/alt
	cp image.fs $(BINARIES)/orig
	cp boot.rim $(BINARIES)/orig
	cp a.out $(BINARIES)/orig
	cp unixv0.simh $(BINARIES)/orig

# Phil's bootstrap code
boot.rim: $(SYSSRC)/sop.s $(OTHERSRC)/pbboot.s
	$(AS) -f rim -o boot.rim $(SYSSRC)/sop.s $(OTHERSRC)/pbboot.s

# Warm boot Unix kernel: boots into init and a login prompt
SYS_FILES=$(SYSSRC)/sop.s $(sort $(wildcard $(SYSSRC)/s[1-8].s))
a.out:	$(SYS_FILES)
	$(AS) -f ptr  -o a.out $(SYS_FILES)
	$(AS) -n -f list -o a.lst $(SYS_FILES)

# Cold boot Unix kernel: attempts to build a minimal filesystem.
# Don't use this one!
COLD_FILES=$(SYS_FILES) $(SYSSRC)/s9.s
coldboot.rim: $(COLD_FILES)
	$(AS) -f rim  -o coldboot.rim $(COLD_FILES)
	$(AS) -n -f list -o coldboot.lst $(COLD_FILES)

# Filesystem image
image.fs: cmd others
	$(MKFS) -k a.out proto
	$(FSCK) image.fs

clean:
	rm -f boot.rim image.fs a.lst n.out a.out
	rm -rf $(BINDIR) $(TESTDIR) 
	rm -rf $(BINARIES)

dirs:
	mkdir -p $(BINDIR)

# The commands that came from the original scans
cmd: dirs \
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

# -- compile errors
$(BINDIR)/adm: $(CMDSRC)/adm.s
	$(AS) $(ASARGS) -o $(BINDIR)/adm $(CMDSRC)/adm.s

$(BINDIR)/apr: $(CMDSRC)/apr.s
	$(AS) $(ASARGS) -o $(BINDIR)/apr $(CMDSRC)/apr.s

$(BINDIR)/as: $(CMDSRC)/as.s
	$(AS) $(ASARGS) -o $(BINDIR)/as $(CMDSRC)/as.s

# NOT the B compiler!
$(BINDIR)/bc: $(CMDSRC)/bc.s
	$(AS) $(ASARGS) -o $(BINDIR)/bcx $(CMDSRC)/bc.s

$(BINDIR)/cas: $(CMDSRC)/cas.s
	$(AS) $(ASARGS) -o $(BINDIR)/cas $(CMDSRC)/cas.s

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

$(BINDIR)/cp: $(CMDSRC)/cp.s
	$(AS) $(ASARGS) -o $(BINDIR)/cp $(CMDSRC)/cp.s

$(BINDIR)/db: $(CMDSRC)/db.s
	$(AS) $(ASARGS) -o $(BINDIR)/db $(CMDSRC)/db.s

# -- compile errors
$(BINDIR)/dmabs: $(CMDSRC)/dmabs.s
	$(AS) $(ASARGS) -o $(BINDIR)/dmabs $(CMDSRC)/dmabs.s

$(BINDIR)/ds: $(CMDSRC)/ds.s
	$(AS) $(ASARGS) -o $(BINDIR)/ds $(CMDSRC)/ds.s

$(BINDIR)/dsw: $(CMDSRC)/dsw.s
	$(AS) $(ASARGS) -o $(BINDIR)/dsw $(CMDSRC)/dsw.s

DSKRES=$(CMDSRC)/dskres.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s
$(BINDIR)/dskres: $(DSKRES)
	$(AS) $(ASARGS) -o $(BINDIR)/dskres $(DSKRES)

DSKSAV=$(CMDSRC)/dsksav.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s
$(BINDIR)/dsksav: $(DSKSAV)
	$(AS) $(ASARGS) -o $(BINDIR)/dsksav $(DSKSAV)

$(BINDIR)/ed: $(CMDSRC)/ed1.s $(CMDSRC)/ed2.s
	$(AS) $(ASARGS) -o $(BINDIR)/ed $(CMDSRC)/ed1.s $(CMDSRC)/ed2.s

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

P=$(sort $(wildcard  $(CMDSRC)/p[1-5].s))
$(BINDIR)/p: $(P)
	$(AS) $(ASARGS) -o $(BINDIR)/p $(P)

# contains halt!
$(BINDIR)/pd: $(CMDSRC)/pd.s
	$(AS) $(ASARGS) -o $(BINDIR)/pd $(CMDSRC)/pd.s

$(BINDIR)/rm: $(CMDSRC)/rm.s
	$(AS) $(ASARGS) -o $(BINDIR)/rm $(CMDSRC)/rm.s

$(BINDIR)/rn: $(CMDSRC)/rn.s
	$(AS) $(ASARGS) -o $(BINDIR)/rn $(CMDSRC)/rn.s

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

others: dirs $(BINDIR)/b $(BINDIR)/date $(BINDIR)/mv $(BINDIR)/od

# PLB: B compiler -- renamed from bc to b
# there is a bc.s in the second set of scans!
$(BINDIR)/b: $(CMDSRC)/bl.s $(CMDSRC)/bi.s ../tools/b.c $(OTHERSRC)/b.b
	$(CC) $(BFLAGS) -o b ../tools/b.c
	./b $(OTHERSRC)/b.b b.s
	$(AS) $(ASARGS) -o $(BINDIR)/b $(CMDSRC)/bl.s b.s $(CMDSRC)/bi.s
	rm b b.s

$(BINDIR)/date: $(OTHERSRC)/wktdate.s
	$(AS) $(ASARGS) -o $(BINDIR)/date $(OTHERSRC)/wktdate.s

$(BINDIR)/mv: $(OTHERSRC)/wktmv.s
	$(AS) $(ASARGS) -o $(BINDIR)/mv $(OTHERSRC)/wktmv.s

$(BINDIR)/od: $(OTHERSRC)/wktod.s
	$(AS) $(ASARGS) -o $(BINDIR)/od $(OTHERSRC)/wktod.s

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
