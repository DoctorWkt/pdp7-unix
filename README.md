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
shell with some functionality missing. We have a working filesystem and
we can now boot the kernel, launch init, login, get to a shell prompt and
run the utilities.

Things to do: finish the shell, write the missing utilities, bring the
system fully up on a PDP-7 system, fix any bugs and document everything.
We have a [real PDP-7](http://physics.uoregon.edu/outreach/movies/pdplives/)
and [SimH](http://simh.trailing-edge.com/) as target platforms.

## Running pdp7-unix

You will need [simh](http://simh.trailing-edge.com/) 4.0 to run pdp7-unix.  You can get the source code [here](https://github.com/simh/simh).  

pdp7-unix requires [Perl5](https://www.perl.org/) to build.

To compile it:

`make pdp7`

On 64-bit systems, you may need to set the C compiler's optimisation
level to -O1. To run pdp-unix from the pdp7-unix source tree, do:

`make run`

Press `ctl-e` to break out the simulator into simh

A typical pdp7-unix session on simh looks like:

<pre>
pdp7 unixv0.simh

PDP-7 simulator V4.0-0 Beta        git commit id: e153b7f2
CPU	idle disabled
	8192W, EAE
RB: buffering file in memory
PDP-7 simulator configuration

CPU	idle disabled
CLK	60Hz, devno=00
PTR	devno=01
PTP	devno=02
TTI	devno=03
TTO	devno=04
LPT	devno=65-66
DRM	disabled
RB	devno=71
DT	devno=75-76, 8 units

login: ken
password: ken
@ ln dd ken .
@ ls
dd      
system  
hello   
.       
@ ls system
dd      
ttyin   
keyboard
pptin   
ttyout  
display 
pptout  
as      
cat     
chmod   
chown   
chrm    
cp      
date    
ds      
ed      
init    
ln      
ls      
mv      
password
sh      
stat    
@ cat hello
Hello, world
@ 
</pre>


## Source Tree

The code in the original scans are (c) Novell who own the rights to the Unix
source code. Everything that didn't come from the scanned files is GPLv3.

* /build     is an area to build the kernel & filesystem and run them
* /man		 holds man pages
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

## Travis Status

<a href="https://travis-ci.org/DoctorWkt/pdp7-unix">
<img src="https://api.travis-ci.org/DoctorWkt/pdp7-unix.png"></a>
