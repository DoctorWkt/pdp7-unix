# Bringing up the Kernel

Add notes on what you've tried w.r.t bringing up the kernel

## wkt Sun Mar 13 12:26:06 AEST 2016

We can make at the top level to assemble the kernel, some utilities
and build the filesystem with the utilities, dd and system directories.

In the build directory, make run starts Simh running, loads the
kernel into memory and sets the PC to 0100.

I'm sure that Phil has got further than this, but by setting a
breakpoint at 01000 (set br 1000) and doiing a c(ontinue), we see:

```
simh> show cpu history
...
003351  1 000072  000000  JMP 3361
003361  1 000072  000000  LAC 4257
003362  1 000454  000000  JMP I 3272
004544  1 000454  000000  JMP 10000
```

which is the end of coldboot in s8.s. The first few instructions
are definitely from init.s. By breaking at 001115 (fork from a.lst),
we can see two forks, which correspond to the two in init.s.

We do get to the 010052: 020005     sys write; m1; m1s
code in init to write "\nlogin:" on the terminal, but this
isn't being displayed.

We make it to 01363, the first instruction in wttyo, so the
write syscall is hitting the right device. We do get into
dsprestart at 03516, and we do make it to the dpcf instruction
at 03527, but we don't get past here. We don't make it down
to the sma instruction at 03531 or the ksf instruction at
03537,

## wkt Sun Mar 13 14:41:30 AEST 2016

I've commented out some of the Graphics-2 code around dsprestart and
pibreak in s7.s. With this code removed, I now see the login: prompt
being written by the init child. It's not responding to keyboard
characters, but I haven't traced the code yet.

## wkt Sun Mar 13 15:06:53 AEST 2016

Using the modified kernel and the normal init.s, I've set breakpoints
at 0352, the dac after krb in dsprestart, and at 10253 the lac char
straight after the sys read in init.s.

I'm seeing breaks at 0352 for the four characters "ken\r", but I'm not
seeing any breaks after the sys read in init.s. The read only reads one
word, so I was expecting to see it react after one or perhaps two characters
typed at the keyboard, or even the \r character.

## Sun Mar 13 21:11:26 AEST 2016

Phil made essentially the same change. He noted in an e-mail: entering
dmr<CTRL/J> at the login: prompt got me a password: prompt. Entering
dmr<CTRL/J> there gave me a question mark. Which may be either: I was wrong
in my guess about "password" file format, or where home directories should
be located...

So the next step is to dissect init.s in more detail. I've changed the as7
assembler so that we can #ifdef the code around dsprestart in s7.s but keep
the Graphics-2 code still in the file.

## wkt Mon Mar 14 19:51:08 AEST 2016

Phil realised that it was the link syscall which was failing. It seems to
need a directory at i-num 4. I fiddled a bit and added some more kernel
comments. It seems that "dd" has to be a i-num 4 and "system" at i-num 3.
I've modified mkfs7 and the proto file to allow this to occur. I've also
make link counts negative. This now gets init past the link syscall, but
it then dies on the open("sh") immediately after that.

## wkt Mon Mar 14 20:20:44 AEST 2016

A transcription error in s2.s link caused the new link's d.inum to be zero
and not the correct value. Fixed. I've eyeballed the fs differences and
they look OK to me. init is still erroring. Not sure why yet.

It's the open call directly after the link that's failing. Why, if the open
is for the link we just created.

When I dike out the chdir syscalls and put a sh in system, we can open this
one, bounce up to high mem, read the shell into 10000 and then exec this
code. So the rest of init is OK, but there's still a bug opening the link
we just created.

## wkt Mon Mar 14 21:23:30 AEST 2016
I had wrong permission bit values in mkfs7 which was stopping the shell
open once we had changed user-id to the real user. Now fixed, and we
can now get to a shell prompt.

## wkt Wed Mar 16 06:20:24 AEST 2016
The shell is working, but we have to move the binaries into the user's directory
to get them to work. ls wasn't working because there was no way to open the current
directory. I've taken the decision to add a "." entry to each directory in the filesystem,
so now we can run things like ls, cat, date. We have a minimally working kernel!

## wkt Wed Mar 16 09:50:13 AEST 2016
I uncommented the code in Phil's shell to link binaries from the
system directory so that we can run them in the current directory.
I fixed a few home-grown utilities, and I added world-read permissions
to dd and system. cp works, so does stat. A few things not working yet
like chrm, mv, ln.

## wkt Sat Mar 19 06:31:52 AEST 2016
The shell now has code to link binaries in from the system directory, and mkfs7 has
been modified to optionally create . and .., so things are mostly working now including
chdir.

## wkt Wed Mar 23 14:16:15 AEST 2016
To keep things sensible, we have set the main build rules to build from
the untouched historical sources. Phil has managed to get SimH to
simulate enough of the Graphics-2 device to use it as a second console.
We have removed all the #ifdefs from the code.

Warren has been working on an alternative version which sees the
system advance by about a year to when it has . and .. directory
entries, no dd entry, plus things like mkdir. To build this, do make alt,
make altrun. The src/alt area is used to hold the "alternative" code.

Essentially, it all works now except a few minor glitches. We now need
to get as up and running fully, get ed rescanned and working. Eventually
it would be good to have a working roff; but someone is going to have
to write it from scratch.

## wkt Thu Mar 24 17:53:55 AEST 2016
The B compiler works and can compile itself, thanks to the hard work
done by Robert Swierczek, so it's now on the filesystem image; there's
an example B program in dmr's home directory.

Phil has written a proper RIM bootstrap for the system with the kernel
loaded onto physical track 180 (logical 80). The mkfs7 tools has been
altered to place the kernel there, so now we can boot from a paper tape that
is only 237 bytes (23.7 inches) long instead of 14133 bytes (1413 inches)
long :-) That will help when we get to the LCM machine.

We have a new scan from Norman Wilson, and some transcription errors in
ed have been fixed. ed now assembles and runs, but it isn't working
perfectly yet.

## plb Fri Mar 25 00:45:57 EDT 2016

boot.rim is now "Hardware Read In", and only 120 bytes (12 inches),
and in the format an actual PDP-7 wants at cold start!
