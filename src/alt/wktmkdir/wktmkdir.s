" Warren's alternative mkdir command: mkdir newdir

main:
   lac 017777 i         " Do we have any arguments?
   sad d4
     jmp noarg

   lac 017777           " Move five words past the argument word count
   tad d5               " so that AC points at the first argument
   dac 017777
   dac 6f		" Save this as the argument name in
   dac 7f		" several system calls
   dac 8f
   dac 9f

   " Get the status of the argument so that we can
   " see if it exists. Apparently creat (below) works
   " on an existing file
   lac statbufptr
   sys status; 6:0
   sna
     jmp badfile

   " Try to create a new file but with the isdir bit set
   lac o34
   sys creat; 7:0
   spa
     jmp badfile
   dac fd

   " Get the status of the current directory so that we can
   " get its i-num
   lac statbufptr
   sys status; dot

   " Write a dummy entry into the new directory that is
   " equivalent to .., just so we can refer to the parent
   lac fd
   sys write; s.inum; 8

   " Move into the new directory
   sys chdir; 8:0

   " Create a . link to us
   sys link; up; 9:0; dot

   " Create a .. link to the parent
   sys link; up; dot; dotdot

   " Try to make a system link; this may fail
   sys link; up; system; system

   " Now zero the i-num of the dummy entry
   lac fd
   sys seek; 0; 0
   lac fd
   sys write; zero; 1
   
   " Close the file and exit
   lac fd
   sys close
   sys exit

noarg:
   " Print a "no arg" error and exit
   lac d1
   sys write; noargstr; 4
   sys exit
noargstr: <no>; < a>; <rg>; 012

badfile:
   lac lac 017777 	" Get the pointer to the new dirname
   dac 1f               " Store it in 1f below
   lac d1
   sys write; 1:0; 4    " Write the name, max 4 words
   lac d1               " Then write " ?\n"
   sys write; 1f; 2
   sys exit             " and exit
1: 040; 077012          " String literal: " ?\n"

fd: 0		" File descriptor of the new directory
zero: 0
d1: 1
d4: 4
d5: 5
o34: 034	" drw-- permission bits

statbufptr: statbuf             " Pointer to the statbuf
statbuf:                        " Status buffer fields below
s.perm: 0
s.blk1: 0
s.blk2: 0
s.blk3: 0
s.blk4: 0
s.blk5: 0
s.blk6: 0
s.blk7: 0
s.uid: 0
s.nlinks: 0
s.size: 0
s.uniq: 0
s.inum: 0
up: <up>; 040040; 040040; 040040
pad: 0; 0; 0
dotdot: <..>; 040040; 040040; 040040
dot: 056040; 040040; 040040; 040040
system: <sy>; <st>; <em>; 040040
