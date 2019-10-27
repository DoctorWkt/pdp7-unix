
include build/os.mk

all: buildit

buildit:
	cd build && $(MAKE) all

run: buildit
	cd build && $(MAKE) run

alt:
	cd build && $(MAKE) alt

altrun: alt
	cd build && $(MAKE) altrun

clean:
	cd build && $(MAKE) clean

binaries: buildit
	mkdir -p binaries
	cp build/image.fs binaries/
	cp build/boot.rim binaries/
	cp build/unixv0.simh binaries/

