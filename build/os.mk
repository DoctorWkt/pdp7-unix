
# detect OS
UNAME=$(shell uname)
ifeq ($(UNAME), Linux)
	UNAME=LINUX
	MAKE=make
else 
ifeq ($(UNAME), Darwin)
	UNAME=DARWIN
	MAKE=make
else 
ifeq ($(UNAME), FreeBSD)
	UNAME=FREEBSD
	MAKE=gmake
endif
endif
endif

# choose C compiler
ifeq ($(UNAME), LINUX)
# Linux
	CC=gcc
else
ifeq ($(UNAME), FREEBSD)
# FreeBSD
	CC=cc
else
ifeq ($(UNAME), DARWIN)
# Mac OS X
	CC=cc 
else
	$(error "Unknown OS: " $(UNAME))
endif
endif
endif

