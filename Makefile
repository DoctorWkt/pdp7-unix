# Top level makefile to build the utilities etc,
AS=tools/as7
BINDIR=bin
SYSDIR=$(BINDIR)/sys
CMDDIR=$(BINDIR)/cmd

all: dirs sys cmd others

dirs:
	mkdir -p $(BINDIR)
	mkdir -p $(SYSDIR)
	mkdir -p $(CMDDIR)

sys:
	$(AS) -o $(SYSDIR)/kernel   src/sys/*.s

cmd:
#	$(AS) -o $(CMDDIR)/adm   src/cmd/adm.s
#	$(AS) -o $(CMDDIR)/apr   src/cmd/apr.s
	$(AS) -o $(CMDDIR)/as   src/cmd/as.s
#	$(AS) -o $(CMDDIR)/bc   src/cmd/bc.s
#	$(AS) -o $(CMDDIR)/bi   src/cmd/bi.s
#	$(AS) -o $(CMDDIR)/bl   src/cmd/bl.s
#	$(AS) -o $(CMDDIR)/cas   src/cmd/cas.s
	$(AS) -o $(CMDDIR)/cat   src/cmd/cat.s
#	$(AS) -o $(CMDDIR)/check    src/cmd/check.s
	$(AS) -o $(CMDDIR)/chmod src/cmd/chmod.s
	$(AS) -o $(CMDDIR)/chown src/cmd/chown.s
	$(AS) -o $(CMDDIR)/chrm  src/cmd/chrm.s
	$(AS) -o $(CMDDIR)/cp    src/cmd/cp.s
#	$(AS) -o $(CMDDIR)/db    src/cmd/db.s
#	$(AS) -o $(CMDDIR)/dmabs    src/cmd/dmabs.s
	$(AS) -o $(CMDDIR)/ds    src/cmd/ds.s
#	$(AS) -o $(CMDDIR)/dskio   src/cmd/dskio.s
#	$(AS) -o $(CMDDIR)/dskres    src/cmd/dskres.s
#	$(AS) -o $(CMDDIR)/dsksav    src/cmd/dsksav.s
#	$(AS) -o $(CMDDIR)/dsw    src/cmd/dsw.s
#	$(AS) -o $(CMDDIR)/ed1    src/cmd/ed1.s
#	$(AS) -o $(CMDDIR)/ed2    src/cmd/ed2.s
#	$(AS) -o $(CMDDIR)/init    src/cmd/init.s

others:
	$(AS) -o $(CMDDIR)/ls  src/other/wktls.s	

clean:
	rm -rf $(BINDIR)/*
	rmdir $(BINDIR)
