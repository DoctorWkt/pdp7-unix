# Build the kernel, the filesystem and run SimH

AS=../tools/as7
MKFS=../tools/mkfs7
SYS=../src/sys

all: a.rim image.fs

run: a.rim image.fs
	pdp7 unixv0.simh

a.rim:
	$(AS) -f rim  -o a.rim $(SYS)/sop.s $(SYS)/s[1-8].s
	$(AS) -f list -o a.lst $(SYS)/sop.s $(SYS)/s[1-8].s

image.fs:
	$(MKFS) --debug --format simh proto

clean:
	rm -f a.rim image.fs a.lst
