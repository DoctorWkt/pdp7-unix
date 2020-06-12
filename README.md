![CI](https://github.com/DoctorWkt/pdp7-unix/workflows/CI/badge.svg)

# pdp7-unix


## About

pdp7-unix is a project to resurrect Unix on the PDP-7 from scans of the original
assembly code done by
[Norman Wilson](http://www.cs.toronto.edu/~norman/pers/index.html).
The scans of PDP-7 Unix are in the [Unix Archive](http://www.tuhs.org/)
[as the files 0*.pdf](http://www.tuhs.org/Archive/Distributions/Research/McIlroy_v0/).

## Current Status

### January 2020

Unixv0 is running on a real PDP-7 at the Living Computer Museum. [Youtube](https://www.youtube.com/watch?v=pvaPaWyiuLA).

### October 2019

A second notebook with missing sources has been
discovered and scanned.  New files are being added to the scans
directory as they are typed in!

### March 2016 

We've written an assembler, a user-mode simulator and
commented several source files. We now have these utilities running:
as, cat, chmod, chown, chrm, cp, date, ln, ls, mv, stat. We have a working
shell with some functionality missing. We have a working filesystem and
we can now boot the kernel, launch init, login, get to a shell prompt and
run the utilities.

Things to do: bring the
system fully up on a PDP-7 system, fix any bugs and document everything.
We have a [real PDP-7](http://physics.uoregon.edu/outreach/movies/pdplives/)
and [SimH](http://simh.trailing-edge.com/) as target platforms.


## Building pdp7-unix

pdp7-unix requires [Perl5](https://www.perl.org/) to build.

To compile it:

`make`

## Running pdp7-unix

You will need [simh](http://simh.trailing-edge.com/) 4.0 to run pdp7-unix.  You can get the source code [here](https://github.com/simh/simh). On 64-bit systems, you may need to set the C compiler's optimisation level to -O1.

### Running from source

To run pdp-unix from the pdp7-unix source tree, do:

`make run`

Press `ctl-e` to break out the simulator into simh

### Typical Output

A typical pdp7-unix session on simh looks like:

<pre>
pdp7 unixv0.simh
k
PDP-7 simulator V4.0-0 Current        git commit id: b848cb12
CPU	idle disabled
	8KW, EAE
/Users/tom/projects/pdp7-unix/build/unixv0.simh-13> att rb image.fs
RB: buffering file in memory
/Users/tom/projects/pdp7-unix/build/unixv0.simh-17> att -U g2in 12345
Listening on port 12345
PDP-7 simulator configuration

CPU	idle disabled
CLK	60Hz, devno=00
PTR	devno=01
PTP	devno=02
TTI	devno=03
TTO	devno=04
LPT	disabled
DRM	disabled
RB	devno=71
DT	disabled
G2OUT	devno=05
G2IN	devno=43-44

login: ken
password: ken
@ ls
..
dd
maksys.s
s1.s
s2.s
s3.s
s4.s
s5.s
s6.s
s7.s
s8.s
sop.s
system
sys.rc
trysys.s
@ ls system
..
adm
apr
as
b
cas
cat
check
chmod
chown
chrm
cp
date
db
dd
display
ds
dskres
dsksav
dsw
dttt
ed
init
keyboard
link
list
ln
ls
moo
mv
nm
od
p
password
pptin
pptout
rm
rn
roff
salv
sh
stat
tm
ttyin
ttyout
ttt
un
@ 
</pre>


## Source Tree

The code in the original scans are (c) Micro Focus who own the rights to the Unix
source code. Everything that didn't come from the scanned files is GPLv3.

* /build     is an area to build the kernel & filesystem and run them
* /man       holds man pages
* /misc	     holds miscellaneous notes and information
* /scans     holds the unmodified OCR versions of the scanned files
* /src/cmd   holds the modified source code of the user-mode programs
* /src/sys   holds the modified source code of the kernel
* /src/other holds PDP-7 source code which did not come from the scanned files
* /tools     holds the source for the tools written to assist the project

## License

pdp7-unix is under the [GPLv3](LICENSE)


## Mailing List

We have a
[mailing list](http://minnie.tuhs.org/cgi-bin/mailman/listinfo/pdp7-unix)
for those people actively involved in the restoration effort. Send e-mail
to Warren Toomey (DoctorWkt) if you are keen to help out.

