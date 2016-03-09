# Top level makefile to build the utilities etc
AS=tools/as7
ASARGS=--format=ptr
SYSDIR=sys
CMDDIR=bin

all: sys cmd others

runsh: all
	cd bin && ../tools/a7out sh

dirs:
	mkdir -p $(SYSDIR)
	mkdir -p $(CMDDIR)

sys: dirs
	$(AS) $(ASARGS) -o $(SYSDIR)/unix   src/sys/*.s

cmd: dirs
#	$(AS) $(ASARGS) -o $(CMDDIR)/adm   src/cmd/adm.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/apr   src/cmd/apr.s
	$(AS) $(ASARGS) -o $(CMDDIR)/as   src/cmd/as.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/bc   src/cmd/bc.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/bi   src/cmd/bi.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/bl   src/cmd/bl.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/cas   src/cmd/cas.s
	$(AS) $(ASARGS) -o $(CMDDIR)/cat   src/cmd/cat.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/check    src/cmd/check.s
	$(AS) $(ASARGS) -o $(CMDDIR)/chmod src/cmd/chmod.s
	$(AS) $(ASARGS) -o $(CMDDIR)/chown src/cmd/chown.s
	$(AS) $(ASARGS) -o $(CMDDIR)/chrm  src/cmd/chrm.s
	$(AS) $(ASARGS) -o $(CMDDIR)/cp    src/cmd/cp.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/db    src/cmd/db.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dmabs    src/cmd/dmabs.s
	$(AS) $(ASARGS) -o $(CMDDIR)/ds    src/cmd/ds.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dskio   src/cmd/dskio.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dskres    src/cmd/dskres.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dsksav    src/cmd/dsksav.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dsw    src/cmd/dsw.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/ed1    src/cmd/ed1.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/ed2    src/cmd/ed2.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/init    src/cmd/init.s

others: dirs
	$(AS) $(ASARGS) -o $(CMDDIR)/pbsh    	src/other/pbsh.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/ops    	src/other/ops.s	

# wkt apps
	$(AS) $(ASARGS) -o $(CMDDIR)/wktls    	src/other/wktls.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktcat    	src/other/wktcat.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktcp    	src/other/wktcp.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktdate  	src/other/wktdate.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktln  	src/other/wktln.s
	$(AS) $(ASARGS) -o $(CMDDIR)/wktls  	src/other/wktls.s		
	$(AS) $(ASARGS) -o $(CMDDIR)/wktmv    	src/other/wktmv.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktopr    	src/other/wktopr.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktstat  	src/other/wktstat.s	

clean:
	rm -rf $(SYSDIR)/*
	rm -rf $(CMDDIR)/*
