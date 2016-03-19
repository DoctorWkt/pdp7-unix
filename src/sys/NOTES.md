PROCESSES
=========

uid -1 is superuser

process 1 is "init", runs as superuser

there are ten process slots, pids are 18 bits.

DISK
====

```
RB09: Burroughs fixed head disk (same hardware as RD10!)

64 word sectors; 80 sectors/track; 100 tracks/surface; 2 surfaces
8000 sectors/surface
one surface reserved for backup

512,000 words per surface: 1,024,000 characters!!!

first disk block is copy of "system data"
        contains time, free block information, process (user) list?!!
	first words points to the first block in the free list
```

free block format
-----------------
```
Each block in the free list contains words 1 to 9 which are free block
numbers if positive, or zero for empty positions. Word 0 in the block
points at the next block in the free list, or zero if there is no next
block.
```

inode format
------------
```
12 word inodes (5 per block)
710 sectors of inodes (max 3550 files)

   i.flags
        400000  in use
        200000  large file
        000040  special file
        000020  directory
        000017  can be changed by chmod.
            10  owner read
            04  owner write
            02  world read
            01  world write
   i.dskps      7 block numbers (all indirect blocks if "large file")
   i.uid        owner
   i.nlks       link count (negative i.e. -1, -2, -3 -4 etc.)
   i.size       size (in words)
   i.uniq       unique value assigned at creation
```


directory node (dnode) format
-----------------------------
```
   d.i          i-number of file or zero if an empty entry
   d.name       four words, space padded
   d.uniq       i.uniq value of file
		two unused words, so 8 words/entry, 8 entries/block

directory files can (only) be truncated by superuser
```

i numbers
---------
```
  1     core file?? (written by "sys save" or bad system call)
  3     "system" default process cdir, must contain "init", "sh"
  4     "dd" directory that contains system and user dirs
        All dirs must have a link back to dd

  6     "ttyin" special file
  7     "keyboard" (graphic-2) special file
  8     "pptin"?? (paper tape reader) special file
  10    "ttyout" special file
  11    "display" (graphic-2) special file
  12    "pptout" (paper tape punch) special file
```

swapping
--------

Only one process is in memory at any time (in the high half of the 8KW
memory).  The ten processes are swapped to the last ten tracks of the
disk.
