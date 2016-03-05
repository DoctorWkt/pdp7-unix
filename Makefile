# Top level makefile to build the utilities etc,
AS=tools/as7
BINDIR=bin
SYSDIR=$(BINDIR)/sys
UTILSDIR=$(BINDIR)/utilities

all: dirs sys utilities others

dirs:
	mkdir -p $(BINDIR)
	mkdir -p $(SYSDIR)
	mkdir -p $(UTILSDIR)

sys:
	$(AS) -o $(SYSDIR)/kernel   src/sys/*.s

utilities:
#	$(AS) -o $(UTILSDIR)/adm   src/cmd/adm.s
#	$(AS) -o $(UTILSDIR)/apr   src/cmd/apr.s
	$(AS) -o $(UTILSDIR)/as   src/cmd/as.s
#	$(AS) -o $(UTILSDIR)/bc   src/cmd/bc.s
#	$(AS) -o $(UTILSDIR)/bi   src/cmd/bi.s
#	$(AS) -o $(UTILSDIR)/bl   src/cmd/bl.s
#	$(AS) -o $(UTILSDIR)/cas   src/cmd/cas.s
	$(AS) -o $(UTILSDIR)/cat   src/cmd/cat.s
#	$(AS) -o $(UTILSDIR)/check    src/cmd/check.s
	$(AS) -o $(UTILSDIR)/chmod src/cmd/chmod.s
	$(AS) -o $(UTILSDIR)/chown src/cmd/chown.s
	$(AS) -o $(UTILSDIR)/chrm  src/cmd/chrm.s
	$(AS) -o $(UTILSDIR)/cp    src/cmd/cp.s
#	$(AS) -o $(UTILSDIR)/db    src/cmd/db.s
#	$(AS) -o $(UTILSDIR)/dmabs    src/cmd/dmabs.s
	$(AS) -o $(UTILSDIR)/ds    src/cmd/ds.s
#	$(AS) -o $(UTILSDIR)/dskio   src/cmd/dskio.s
#	$(AS) -o $(UTILSDIR)/dskres    src/cmd/dskres.s
#	$(AS) -o $(UTILSDIR)/dsksav    src/cmd/dsksav.s
#	$(AS) -o $(UTILSDIR)/dsw    src/cmd/dsw.s
#	$(AS) -o $(UTILSDIR)/ed1    src/cmd/ed1.s
#	$(AS) -o $(UTILSDIR)/ed2    src/cmd/ed2.s
#	$(AS) -o $(UTILSDIR)/init    src/cmd/init.s

others:
	$(AS) -o $(UTILSDIR)/ls  src/other/wktls.s	

clean:
	rm -rf $(BINDIR)/*
	rmdir $(BINDIR)
