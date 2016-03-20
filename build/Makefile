# Build the kernel, the filesystem and run SimH
# Put any defines for as7 here
#DEFINES=

AS=../tools/as7 $(DEFINES)
A7OUT=../tools/a7out
MKFS=../tools/mkfs7
SDUMP=../tools/sdump
FSCK=../tools/fsck7
PDP7=pdp7

# source directories
SYS_SOURCE_DIR=../src/sys
CMD_SOURCE_DIR=../src/cmd
OTHER_SOURCE_DIR=../src/other
TEST_SOURCE_DIR=../src/tests

# target directories
CMDDIR=bin
TESTDIR=tests

# fs file
FS_FILE=image.fs

all: a.rim $(FS_FILE)

run: all
	$(PDP7) unixv0.simh

a.rim:
	$(AS) -f rim  -o a.rim $(SYS_SOURCE_DIR)/sop.s $(SYS_SOURCE_DIR)/s[1-8].s
	$(AS) -n -f list -o a.lst $(SYS_SOURCE_DIR)/sop.s $(SYS_SOURCE_DIR)/s[1-8].s

coldboot:
	$(AS) -f rim  -o a.rim $(SYS_SOURCE_DIR)/sop.s $(SYS_SOURCE_DIR)/s[1-9].s
	$(AS) -n -f list -o a.lst $(SYS_SOURCE_DIR)/sop.s $(SYS_SOURCE_DIR)/s[1-9].s

image.fs: cmd others
	$(MKFS) --format simh proto
	$(FSCK) $(FS_FILE)

dirs:
	mkdir -p $(CMDDIR)
	mkdir -p $(TESTDIR)

cmd: dirs
#	$(AS) $(ASARGS) -o $(CMDDIR)/adm    	$(CMD_SOURCE_DIR)/adm.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/apr    	$(CMD_SOURCE_DIR)/apr.s
	$(AS) $(ASARGS) -o $(CMDDIR)/as     	$(CMD_SOURCE_DIR)/as.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/bc     	$(CMD_SOURCE_DIR)/bc.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/bi     	$(CMD_SOURCE_DIR)/bi.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/bl     	$(CMD_SOURCE_DIR)/bl.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/cas    	$(CMD_SOURCE_DIR)/cas.s
	$(AS) $(ASARGS) -o $(CMDDIR)/cat    	$(CMD_SOURCE_DIR)/cat.s
	$(AS) $(ASARGS) -o $(CMDDIR)/check  	$(CMD_SOURCE_DIR)/check.s
	$(AS) $(ASARGS) -o $(CMDDIR)/chmod   	$(CMD_SOURCE_DIR)/chmod.s
	$(AS) $(ASARGS) -o $(CMDDIR)/chown   	$(CMD_SOURCE_DIR)/chown.s
	$(AS) $(ASARGS) -o $(CMDDIR)/chrm    	$(CMD_SOURCE_DIR)/chrm.s
	$(AS) $(ASARGS) -o $(CMDDIR)/cp      	$(CMD_SOURCE_DIR)/cp.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/db      	$(CMD_SOURCE_DIR)/db.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dmabs   	$(CMD_SOURCE_DIR)/dmabs.s
	$(AS) $(ASARGS) -o $(CMDDIR)/ds      	$(CMD_SOURCE_DIR)/ds.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dskio   	$(CMD_SOURCE_DIR)/dskio.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dskres  	$(CMD_SOURCE_DIR)/dskres.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dsksav  	$(CMD_SOURCE_DIR)/dsksav.s
#	$(AS) $(ASARGS) -o $(CMDDIR)/dsw     	$(CMD_SOURCE_DIR)/dsw.s
	$(AS) $(ASARGS) -o $(CMDDIR)/ed      	$(CMD_SOURCE_DIR)/ed1.s $(CMD_SOURCE_DIR)/ed2.s
	$(AS) $(ASARGS) -o $(CMDDIR)/init    	$(CMD_SOURCE_DIR)/init.s

others: dirs
	$(AS) $(ASARGS) -o $(CMDDIR)/sh    		$(OTHER_SOURCE_DIR)/pbsh.s	

# wkt apps
	$(AS) $(ASARGS) -o $(CMDDIR)/ls    		$(OTHER_SOURCE_DIR)/wktls.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktcat    	$(OTHER_SOURCE_DIR)/wktcat.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/wktcp    	$(OTHER_SOURCE_DIR)/wktcp.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/date  		$(OTHER_SOURCE_DIR)/wktdate.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/ln  		$(OTHER_SOURCE_DIR)/wktln.s
	$(AS) $(ASARGS) -o $(CMDDIR)/ls  		$(OTHER_SOURCE_DIR)/wktls.s		
	$(AS) $(ASARGS) -o $(CMDDIR)/mv    		$(OTHER_SOURCE_DIR)/wktmv.s	
	$(AS) $(ASARGS) -o $(CMDDIR)/stat  		$(OTHER_SOURCE_DIR)/wktstat.s	

tests: dirs
	$(AS) $(ASARGS) -o $(TESTDIR)/decimal_out    	$(TEST_SOURCE_DIR)/decimal_out.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/fork_test    		$(TEST_SOURCE_DIR)/fork_test.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/octal_test    	$(TEST_SOURCE_DIR)/octal_test.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/testmul    		$(TEST_SOURCE_DIR)/testmul.s
	$(AS) $(ASARGS) -o $(TESTDIR)/write_test    	$(TEST_SOURCE_DIR)/write_test.s

runtests: tests
	$(A7OUT) $(TESTDIR)/decimal_out
	$(A7OUT) $(TESTDIR)/fork_test
	$(A7OUT) $(TESTDIR)/octal_test
#	$(A7OUT) $(TESTDIR)/testmul
#	$(A7OUT) $(TESTDIR)/write_test

sdump: $(FS_FILE)
	$(SDUMP) $(FS_FILE)

fsck: $(FS_FILE)
	$(FSCK) $(FS_FILE)

clean:
	rm -f a.rim $(FS_FILE) a.lst n.out
	rm -rf $(CMDDIR)
	rm -rf $(TESTDIR)

