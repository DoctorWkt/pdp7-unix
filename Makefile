# Top level makefile to build the utilities etc,
AS= tools/as7

all: utilities

utilities:
	$(AS) src/cmd/cat.s > bin/cat
	rm -f n.out

clean:
	rm -f bin/*
