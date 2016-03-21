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
ALTSRC=../src/alt
OTHERSRC=../src/other
TESTSRC=../src/tests

# targets
BINDIR=bin
TESTDIR=tests
BINARIES=../binaries/


all: cmd others a.rim image.fs copybinaries

# Make alternative everything: no dd but . and ..
alt: altcmd altothers alt/a.rim alt/image.fs

# The run rule has no dependencies so that the system can be booted easily
# and frequently with make run. However, you have to manually make all first!
run:
	$(PDP7) unixv0.simh

# Alternative run, use the alt/image.fs
altrun:
	$(PDP7) alt/unixv0.simh

# Warm boot Unix kernel: boots into init and a login prompt
a.rim:
	$(AS) -f rim  -o a.rim $(SYSSRC)/sop.s $(SYSSRC)/s[1-8].s
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYSSRC)/s[1-8].s

# Alternative kernel: no dd, but . and ..
alt/a.rim:
	$(AS) -f rim -o alt/a.rim $(SYSSRC)/sop.s $(SYSSRC)/s1.s \
		$(ALTSRC)/s2.s $(SYSSRC)/s[3-8].s
	$(AS) -n -f list -o alt/a.lst $(SYSSRC)/sop.s $(SYSSRC)/s1.s \
		$(ALTSRC)/s2.s $(SYSSRC)/s[3-8].s

# Cold boot Unix kernel: attempts to build a minimal filesystem.
# Don't use this one!
coldboot:
	$(AS) -f rim  -o a.rim $(SYSSRC)/sop.s $(SYSSRC)/s[1-9].s
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYSSRC)/s[1-9].s

# Filesystem image
image.fs: cmd others
	$(MKFS) proto
	$(FSCK) image.fs

# Alternate filesystem image: . and .. but no dd
alt/image.fs: altcmd altothers
	$(MKFS) -1 -2 -3 -o alt/image.fs alt/proto
	$(FSCK) -3 alt/image.fs


copybinaries:
	mkdir -p $(BINARIES)
	cp image.fs $(BINARIES)
	cp a.rim $(BINARIES)

clean:
	rm -f a.rim image.fs a.lst n.out alt/image.fs alt/a.rim alt/a.lst
	rm -rf $(BINDIR) $(TESTDIR)
	rm -rf $(BINARIES)

dirs:
	mkdir -p $(BINDIR)

# The commands that came from the original scans
cmd: dirs $(BINDIR)/as $(BINDIR)/cat $(BINDIR)/check $(BINDIR)/chmod \
	$(BINDIR)/chown $(BINDIR)/chrm $(BINDIR)/cp $(BINDIR)/ds \
	$(BINDIR)/dskres $(BINDIR)/dsksav $(BINDIR)/ed $(BINDIR)/init

# Alternate commands: no dd, but . and ..
altcmd: dirs $(BINDIR)/as $(BINDIR)/cat $(BINDIR)/check $(BINDIR)/chmod \
	$(BINDIR)/chown $(BINDIR)/altchrm $(BINDIR)/cp $(BINDIR)/ds \
	$(BINDIR)/ed $(BINDIR)/altinit

$(BINDIR)/as: $(CMDSRC)/as.s
	$(AS) $(ASARGS) -o $(BINDIR)/as $(CMDSRC)/as.s

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

$(BINDIR)/cp: $(CMDSRC)/cp.s
	$(AS) $(ASARGS) -o $(BINDIR)/cp $(CMDSRC)/cp.s

$(BINDIR)/ds: $(CMDSRC)/ds.s
	$(AS) $(ASARGS) -o $(BINDIR)/ds $(CMDSRC)/ds.s

$(BINDIR)/dskres: $(CMDSRC)/dskres.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s
	$(AS) $(ASARGS) -o $(BINDIR)/dskres $(CMDSRC)/dskres.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s

$(BINDIR)/dsksav: $(CMDSRC)/dsksav.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s
	$(AS) $(ASARGS) -o $(BINDIR)/dsksav $(CMDSRC)/dsksav.s $(CMDSRC)/dskio.s $(SYSSRC)/sop.s

$(BINDIR)/ed: $(CMDSRC)/ed1.s $(CMDSRC)/ed2.s
	$(AS) $(ASARGS) -o $(BINDIR)/ed $(CMDSRC)/ed1.s $(CMDSRC)/ed2.s

$(BINDIR)/init: $(CMDSRC)/init.s
	$(AS) $(ASARGS) -o $(BINDIR)/init $(CMDSRC)/init.s

# Alternative init: no dd directory
$(BINDIR)/altinit: $(ALTSRC)/init.s
	$(AS) $(ASARGS) -o $(BINDIR)/altinit $(ALTSRC)/init.s

# The commands that did not come from the scans
others: dirs $(BINDIR)/sh $(BINDIR)/wktcat $(BINDIR)/wktcp $(BINDIR)/date \
	$(BINDIR)/ln $(BINDIR)/ls $(BINDIR)/mv $(BINDIR)/stat

# Alternative other commands: no dd, but . and ..
altothers: dirs $(BINDIR)/sh $(BINDIR)/wktcat $(BINDIR)/wktcp $(BINDIR)/date \
	$(BINDIR)/ln $(BINDIR)/altls $(BINDIR)/mv $(BINDIR)/stat


$(BINDIR)/sh: $(OTHERSRC)/pbsh.s
	$(AS) $(ASARGS) -o $(BINDIR)/sh $(OTHERSRC)/pbsh.s

$(BINDIR)/wktcat: $(OTHERSRC)/wktcat.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktcat $(OTHERSRC)/wktcat.s

$(BINDIR)/wktcp: $(OTHERSRC)/wktcp.s
	$(AS) $(ASARGS) -o $(BINDIR)/wktcp $(OTHERSRC)/wktcp.s

$(BINDIR)/date: $(OTHERSRC)/wktdate.s
	$(AS) $(ASARGS) -o $(BINDIR)/date $(OTHERSRC)/wktdate.s

$(BINDIR)/ln: $(OTHERSRC)/wktln.s
	$(AS) $(ASARGS) -o $(BINDIR)/ln $(OTHERSRC)/wktln.s

$(BINDIR)/ls: $(OTHERSRC)/wktls.s
	$(AS) $(ASARGS) -o $(BINDIR)/ls $(OTHERSRC)/wktls.s

$(BINDIR)/altls: $(ALTSRC)/wktls.s
	$(AS) $(ASARGS) -o $(BINDIR)/altls $(ALTSRC)/wktls.s

$(BINDIR)/mv: $(OTHERSRC)/wktmv.s
	$(AS) $(ASARGS) -o $(BINDIR)/mv $(OTHERSRC)/wktmv.s

$(BINDIR)/stat: $(OTHERSRC)/wktstat.s
	$(AS) $(ASARGS) -o $(BINDIR)/stat $(OTHERSRC)/wktstat.s

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


