# pdp7-unix


## About

pdp7-unix is a project to resurrect Unix on the PDP-7 from scans of the original
assembly code done by
[Norman Wilson](http://www.cs.toronto.edu/~norman/pers/index.html).
The scans of PDP-7 Unix are in the [Unix Archive](http://www.tuhs.org/) at
[http://www.tuhs.org/Archive/PDP-11/Distributions/research/McIlroy_v0/]
(http://www.tuhs.org/Archive/PDP-11/Distributions/research/McIlroy_v0/)
as the files 0*.pdf.

## Current Status

Update mid-March 2016: We've written an assembler, a user-mode simulator and
commented several source files. We now have these utilities running:
as, cat, chmod, chown, chrm, cp, date, ln, ls, mv, stat. We have a working
shell with some functionality missing. We have begun work on building a
filesystem.

Things to do: finish the filesystem creation tool, finish the shell, write the
missing utilities, try to bring the system up on a PDP-7 system. We have
a [real PDP-7](http://physics.uoregon.edu/outreach/movies/pdplives/)
and [SimH](http://simh.trailing-edge.com/) as target platforms.

## Source Tree

The code in the original scans are (c) Novell who own the rights to the Unix
source code. Everything that didn't come from the scanned files is GPLv3.

* /scans     holds the unmodified OCR versions of the scanned files
* /src/cmd   holds the modified source code of the user-mode programs
* /src/sys   holds the modified source code of the kernel
* /src/other holds PDP-7 source code which did not come from the scanned files
* /tools     holds the source for the tools written to assist the project
* /misc	     holds miscellaneous notes and information
* /pdp7parse holds a Java parser for pdp7 source code

## Travis Status

<a href="https://travis-ci.org/DoctorWkt/pdp7-unix">
<img src="https://api.travis-ci.org/DoctorWkt/pdp7-unix.png"></a>
