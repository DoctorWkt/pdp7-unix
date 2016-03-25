
# detect OS
UNAME=$(shell uname)
ifeq ($(UNAME), Linux)
	UNAME=LINUX
else 
ifeq ($(UNAME), Darwin)
	UNAME=DARWIN
else 
ifeq ($(UNAME), FreeBSD)
	UNAME=FREEBSD
endif
endif
endif

# choose tools
ifeq ($(UNAME), LINUX)
# Linux
	CC=gcc
	MAKE=make
else
ifeq ($(UNAME), FREEBSD)
# FreeBSD
	CC=cc
	MAKE=gmake
else
ifeq ($(UNAME), DARWIN)
# Mac OS X
	CC=cc 
	MAKE=make
else
	$(error "Unknown OS: " $(UNAME))
endif
endif
endif
