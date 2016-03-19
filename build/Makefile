# Build the kernel, the utilities, the filesystem and run SimH

AS=../tools/as7
ASARGS=--format=ptr
MKFS=../tools/mkfs7

SYSSRC=../src/sys
CMDSRC=../src/cmd
OTHERSRC=../src/other
BINDIR=../bin

all: cmd others a.rim image.fs

# Manually make all before make run
run:
	pdp7 unixv0.simh

a.rim:
	$(AS) -f rim  -o a.rim $(SYSSRC)/sop.s $(SYSSRC)/s[1-8].s
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYSSRC)/s[1-8].s

coldboot:
	$(AS) -f rim  -o a.rim $(SYSSRC)/sop.s $(SYSSRC)/s[1-9].s
	$(AS) -n -f list -o a.lst $(SYSSRC)/sop.s $(SYSSRC)/s[1-9].s

image.fs:
	$(MKFS) --format simh proto

clean:
	rm -f a.rim image.fs a.lst n.out $(BINDIR)/*

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

others: dirs
	$(AS) $(ASARGS) -o $(BINDIR)/sh    	$(OTHERSRC)/pbsh.s	
	$(AS) $(ASARGS) -o $(BINDIR)/ls    	$(OTHERSRC)/wktls.s	
	$(AS) $(ASARGS) -o $(BINDIR)/wktcat	$(OTHERSRC)/wktcat.s	
	$(AS) $(ASARGS) -o $(BINDIR)/wktcp	$(OTHERSRC)/wktcp.s	
	$(AS) $(ASARGS) -o $(BINDIR)/date  	$(OTHERSRC)/wktdate.s	
	$(AS) $(ASARGS) -o $(BINDIR)/ln  	$(OTHERSRC)/wktln.s
	$(AS) $(ASARGS) -o $(BINDIR)/ls  	$(OTHERSRC)/wktls.s		
	$(AS) $(ASARGS) -o $(BINDIR)/mv    	$(OTHERSRC)/wktmv.s	
	$(AS) $(ASARGS) -o $(BINDIR)/stat  	$(OTHERSRC)/wktstat.s	
