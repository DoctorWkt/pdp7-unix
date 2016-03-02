# Top level makefile to build the utilities etc,
AS= tools/as7

all: utilities

utilities:
	$(AS) -o bin/cat   src/cmd/cat.s
	$(AS) -o bin/cp    src/cmd/cp.s
	$(AS) -o bin/chmod src/cmd/chmod.s
	$(AS) -o bin/chown src/cmd/chown.s
	$(AS) -o bin/chrm  src/cmd/chrm.s

clean:
	rm -f bin/*
