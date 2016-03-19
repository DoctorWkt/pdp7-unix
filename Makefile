# Top level makefile to build the tests and everything else
AS=tools/as7
ASARGS=--format=ptr
TESTDIR=tests

all: buildit testit

buildit:
	cd build && make

runsh: all
	cd bin && ../tools/a7out sh

testit:
	mkdir -p $(TESTDIR)
	$(AS) $(ASARGS) -o $(TESTDIR)/decimal_out  src/tests/decimal_out.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/fork_test    src/tests/fork_test.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/octal_test   src/tests/octal_test.s	
	$(AS) $(ASARGS) -o $(TESTDIR)/testmul      src/tests/testmul.s
	$(AS) $(ASARGS) -o $(TESTDIR)/write_test   src/tests/write_test.s

runtests: tests
	cd tests && ../tools/a7out decimal_out
	cd tests && ../tools/a7out fork_test
	cd tests && ../tools/a7out octal_test
#	cd tests && ../tools/a7out testmul
#	cd tests && ../tools/a7out write_test

clean:
	rm -rf $(TESTDIR)/*
	cd build && make clean
