# Top level makefile to build the utilities etc,
AS= tools/as7

all: utilities

utilities:
	$(AS) src/cmd/cat.s > bin/cat
	$(AS) src/cmd/cp.s > bin/cp
	$(AS) src/cmd/chmod.s > bin/chmod
	$(AS) src/cmd/chown.s > bin/chown
	$(AS) src/cmd/chrm.s > bin/chrm
	rm -f n.out

clean:
	rm -f bin/*
