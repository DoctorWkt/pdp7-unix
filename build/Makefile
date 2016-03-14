# Build the kernel, the filesystem and run SimH
# Put any defines for as7 here
#DEFINES=

AS=../tools/as7 $(DEFINES)
MKFS=../tools/mkfs7
SYS=../src/sys

all: a.rim image.fs

run: a.rim image.fs
	pdp7 unixv0.simh

a.rim:
	$(AS) -f rim  -o a.rim $(SYS)/sop.s $(SYS)/s[1-8].s
	$(AS) -n -f list -o a.lst $(SYS)/sop.s $(SYS)/s[1-8].s

coldboot:
	$(AS) -f rim  -o a.rim $(SYS)/sop.s $(SYS)/s[1-9].s
	$(AS) -n -f list -o a.lst $(SYS)/sop.s $(SYS)/s[1-9].s

image.fs:
	$(MKFS) --format simh proto

clean:
	rm -f a.rim image.fs a.lst n.out
