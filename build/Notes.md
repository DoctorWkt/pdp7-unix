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

