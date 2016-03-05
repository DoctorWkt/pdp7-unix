# Top level makefile to build the utilities etc,
AS= tools/as7
BIN=bin

all: utilities

utilities:
	mkdir $(BIN)
	$(AS) -o $(BIN)/cat   src/cmd/cat.s
	$(AS) -o $(BIN)/cp    src/cmd/cp.s
	$(AS) -o $(BIN)/chmod src/cmd/chmod.s
	$(AS) -o $(BIN)/chown src/cmd/chown.s
	$(AS) -o $(BIN)/chrm  src/cmd/chrm.s
	$(AS) -o $(BIN)/ls  src/other/wktls.s

clean:
	rm -f $(BIN)/*
	rmdir $(BIN)
