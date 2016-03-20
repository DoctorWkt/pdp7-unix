# Build the kernel, the utilities, the filesystem and run SimH

# tools
AS=../tools/as7
ASARGS=--format=ptr
MKFS=../tools/mkfs7
A7OUT=../tools/a7out 
FSCK=../tools/fsck7
PDP7=pdp7

# source dirs
SYSSRC=../src/sys
CMDSRC=../src/cmd
OTHERSRC=../src/other
TESTSRC=../src/tests

# targets
BINDIR=../bin
TESTDIR=../tests
IMAGEFILE=image.fs

all: cmd others a.rim image

# Manually make all before make run
run: clean all
	$(PDP7) unixv0.simh

a.rim:
	$(AS) -f rim  -o a.rim $(SYSSRC)/sop.s $(SYSSRC)/s[1-8].s
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYSSRC)/s[1-8].s

coldboot:
	$(AS) -f rim  -o a.rim $(SYSSRC)/sop.s $(SYSSRC)/s[1-9].s
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYSSRC)/s[1-9].s

image:
	$(MKFS) --format simh proto
	$(FSCK) $(IMAGEFILE)

clean:
	rm -f a.rim $(IMAGEFILE) a.lst n.out
	rm -rf $(BINDIR)
	rm -rf $(TESTDIR)

dirs:
	mkdir -p $(BINDIR)

cmd: dirs
#	$(AS) $(ASARGS) -o $(BINDIR)/adm    $(CMDSRC)/adm.s
#	$(AS) $(ASARGS) -o $(BINDIR)/apr    $(CMDSRC)/apr.s
	$(AS) $(ASARGS) -o $(BINDIR)/as     $(CMDSRC)/as.s
#	$(AS) $(ASARGS) -o $(BINDIR)/bc     $(CMDSRC)/bc.s
#	$(AS) $(ASARGS) -o $(BINDIR)/bi     $(CMDSRC)/bi.s
#	$(AS) $(ASARGS) -o $(BINDIR)/bl     $(CMDSRC)/bl.s
#	$(AS) $(ASARGS) -o $(BINDIR)/cas    $(CMDSRC)/cas.s
	$(AS) $(ASARGS) -o $(BINDIR)/cat    $(CMDSRC)/cat.s
	$(AS) $(ASARGS) -o $(BINDIR)/check  $(CMDSRC)/check.s
	$(AS) $(ASARGS) -o $(BINDIR)/chmod  $(CMDSRC)/chmod.s
	$(AS) $(ASARGS) -o $(BINDIR)/chown  $(CMDSRC)/chown.s
	$(AS) $(ASARGS) -o $(BINDIR)/chrm   $(CMDSRC)/chrm.s
	$(AS) $(ASARGS) -o $(BINDIR)/cp     $(CMDSRC)/cp.s
#	$(AS) $(ASARGS) -o $(BINDIR)/db     $(CMDSRC)/db.s
#	$(AS) $(ASARGS) -o $(BINDIR)/dmabs  $(CMDSRC)/dmabs.s
	$(AS) $(ASARGS) -o $(BINDIR)/ds     $(CMDSRC)/ds.s
#	$(AS) $(ASARGS) -o $(BINDIR)/dskio  $(CMDSRC)/dskio.s
#	$(AS) $(ASARGS) -o $(BINDIR)/dskres $(CMDSRC)/dskres.s
#	$(AS) $(ASARGS) -o $(BINDIR)/dsksav $(CMDSRC)/dsksav.s
#	$(AS) $(ASARGS) -o $(BINDIR)/dsw    $(CMDSRC)/dsw.s
	$(AS) $(ASARGS) -o $(BINDIR)/ed     $(CMDSRC)/ed1.s $(CMDSRC)/ed2.s
	$(AS) $(ASARGS) -o $(BINDIR)/init   $(CMDSRC)/init.s
	$(AS) $(ASARGS) -o $(BINDIR)/maksys $(CMDSRC)/maksys.s
	$(AS) $(ASARGS) -o $(BINDIR)/trysys $(CMDSRC)/trysys.s

others: dirs
	$(AS) $(ASARGS) -o $(BINDIR)/sh    	$(OTHERSRC)/pbsh.s	
	$(AS) $(ASARGS) -o $(BINDIR)/ls    	$(OTHERSRC)/wktls.s	
	$(AS) $(ASARGS) -o $(BINDIR)/wktcat	$(OTHERSRC)/wktcat.s	
	$(AS) $(ASARGS) -o $(BINDIR)/wktcp	$(OTHERSRC)/wktcp.s	
	$(AS) $(ASARGS) -o $(BINDIR)/date  	$(OTHERSRC)/wktdate.s	
	$(AS) $(ASARGS) -o $(BINDIR)/ln  	$(OTHERSRC)/wktln.s
	$(AS) $(ASARGS) -o $(BINDIR)/mv    	$(OTHERSRC)/wktmv.s	
	$(AS) $(ASARGS) -o $(BINDIR)/stat  	$(OTHERSRC)/wktstat.s	

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


