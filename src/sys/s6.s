"** 01-s1.pdf page 34
" s6

itrunc: 0
   -7					" loop 7 times
   dac 9f+t				" in t0
   lac idskpp				" pointer to inode block numbers
   dac 9f+t+1				" save in t1
1:			" top of loop for inode blocks
   lac 9f+t+1 i				" fetch next block number
   sna					" allocated?
   jmp 4f				"  no
   lac i.flags				" check flags
   and o200000				
   sna					" large file?
   jmp 3f				"  no
   -64					" loop 64 times
   dac 9f+t+2				" save count in t2
   lac dskbufp				" get pointer to dskbuf
   dac 9f+t+3				" in t3
2:			" inner loop for indirect blocks
   lac 9f+t+1 i				" get indirect block number
   jms dskrd				" read it
   lac 9f+t+3 i				" read block number from indirect
   sza					" free?
   jms free				"  no: free it
   isz 9f+t+3				" increment pointer into indirect block
   isz 9f+t+2				" increment loop counter, skip if done
   jmp 2b				"  not done: loop
3:			" here with small file
   lac 9f+t+1 i				" load block number
   jms free				" free it
   dzm 9f+t+1 i				" clear block number
4:			" bottom of loop for inode block ptrs
   isz 9f+t+1				" increment block pointer
   isz 9f+t				" increment count, skip if done
   jmp 1b				"  not done
   lac i.flags
   and o577777				" clear large file flag
   dac i.flags
   jmp itrunc i
t = t+4
			" Given a pointer to a 4-word filename after
			" the jms to namei, and with AC holding the
			" i-num of the directory it is in, return the
			" i-number of the filename (and skip)
			" return zero in AC if not found (no skip)
namei: 0
   jms iget		" Get the inode from the i-num in the AC
   -1
   tad namei i		" get argptr-1
   dac 9f+t+1		" save in t1
   isz namei		" skip over argument
   lac i.flags
   and o20		" get directory bit
   sna			" Is this a directory?
   jmp namei i		"  no: return without skip
   -8
   tad i.size		" Subtract 8 from the file's size
   cma
   lrss 3
   dac 9f+t		" negative count of directory entries in t0
   sna			" any?
   jmp namei i		"  no: return without skip
   dzm di		" Store zero in di
1:
   lac di

"** 01-s1.pdf page 35

   jms dget		" Get a directory entry from the dirblock
   lac d.i		" get i-num
   sna			" in use?
   jmp 2f		"  no
   lac 9f+t+1		" get argptr-1
   dac 8
   lac d.name		" Compare the four words of the filename in the
   sad 8 i		" directory entry with the argument to namei
   skp
   jmp 2f		" No match
   lac d.name+1
   sad 8 i
   skp
   jmp 2f		" No match
   lac d.name+2
   sad 8 i
   skp
   jmp 2f		" No match
   lac d.name+3
   sad 8 i
   skp
   jmp 2f		" No match
   lac d.i		" A match. Get the i-number into AC
   isz namei		" give skip return
   jmp namei i
2:
   isz di		" No match, move up to the next direntry
   isz 9f+t		" any left?
   jmp 1b		"  yes: keep going
   jmp namei i		" Didn't find it, return zero in AC (without skip)
t = t+2
                        " Given an i-number in AC, fetch that i-node
                        " from disk and store it in the inode buffer
iget: 0
   dac ii		" Store the i-number in ii
   cll; idiv; 5		" Divide by 5: 5 inodes in a block
   dac 9f+t		" Store the remainder in 9f+t: the i-node
   lacq			" number within the block
   tad d2		" Add 2 to the quotient to get the block number
   dac 9f+t+1		" and store in 9f+t+1
   jms dskrd		" Get the block
   lac 9f+t
   cll; mul; 12		" Multiply the i-num within the block by 12
   lacq			" to get the offset into the block
   tad dskbufp		" Add on the base of the disk buffer
   dac 9f+t
   dac .+2
   jms copy; ..; inode; 12	" Copy 12 words from buffer to inode
   jmp iget i		" and return

iput: 0
   lac 9f+t+1
   jms dskrd
   law inode-1
   dac 8
   -1
   tad 9f+t
   dac 9
   -12
   dac 9f+t+2
1:
   lac 8 i

"** 01-s1.pdf page 36

   sad 9 i
   skp
   jmp 2f
   isz 9f+t+2
   jmp 1b
   jmp iput i
2:
   -1
   tad 8
   dac 8
   -1
   tad 9
   dac 9
1:
   lac 8 i
   dac 9 i
   isz 9f+t+2
   jmp 1b
   lac 9f+t+1
   jms dskwr
   jmp iput i
t = t+3

	" allocate directory entry
	" AC/ entry number
dget: 0
   dac di			" save entry number
   alss 3			" get word number
   dac 9f+t			" save in t0
   jms pget			" get free disk block
   dac 9f+t+1			" save in t1
   jms dskrd
   lac 9f+t
   and o77
   tad dskbufp
   dac 9f+t+2
   dac .+2
   jms copy; ..; dnode; 8
   lac 9f+t
   tad d8
   jms betwen; d0; i.size
      skp
   jmp dget i
   jms dacisize
   dzm d.i
   jmp dget i

dput: 0
   lac 9f+t+1
   jms dskrd
   lac 9f+t+2
   dac .+3
   jms copy; dnode; ..; 8
   lac 9f+t+1
   jms dskwr
   jmp dput i

t = t+3

	" get a block number for a file, returns disk block number
	" allocates block if not allocated
	" AC/ file offset
	"   jms pget
	" AC/ disk block number
pget: 0
   lrss 6				" convert offset to block
   dac 9f+t				" save as t0
   lac i.flags

"** 01-s1.pdf page 37

   and o200000
   sza					" large file bit set?
   jmp 2f				"  yes
   lac 9f+t				" no: small file
   jms betwen; d0; d6			" block 0..6?
      jmp 1f				"  no
   tad idskpp				" make into block number pointer
   dac 9f+t				" save in t0
   lac 9f+t i				" get disk block number
   sna					" allocated?
   jms alloc				"  no: allocate now
   dac 9f+t i				" save (new) disk block number
   jmp pget i				" return disk block number
1:					" here when file block>=7, not "large"
   jms alloc				" allocate indirect block
   dac 9f+t+1				" save as t1
   jms copy; i.dskps; dskbuf; 7		" copy all the disk block numbers
   jms copyz; dskbuf+7; 64-7		" zero rest of indirect block
   lac 9f+t+1				" get indirect block number back
   jms dskwr				" write indirect block to disk
   lac 9f+t+1
   dac i.dskps				" save indirect as new first block
   jms copyz; i.dskps+1; 6		" zero rest of block pointers
   lac i.flags
   xor o200000				" set "large file"
   dac i.flags
2:					" here with "large file"
   lac 9f+t				" get file block number
   lrss 6				" divide by 64 (indirects/block)
   jms betwen; d0; d6			" ok now?
      jms halt " file too big		"  no, you lose!
   tad idskpp				" yes: get indirect block pointer
   dac 9f+t+1				" save in t1
   lac 9f+t+1 i				" get indirect block number
   sna					" allocated?
   jms alloc				"  no, get it now
   dac 9f+t+1 i				" save (new) indirect block
   dac 9f+t+2				" save as t2
   jms dskrd				" read indirect block
   lac 9f+t				" get original block number
   and o77				" mod by 64
   tad dskbufp				" get pointer to disk block number
   dac 9f+t+1				" save as t1
   lac 9f+t+1 i				" fetch disk block number
   sza					" allocated?
   jmp pget i				"  yes: return
   jms alloc				" no: allocate data block
   dac 9f+t				" save as t0
   lac 9f+t+2				" get indirect block number
   jms dskrd				" read it in
   lac 9f+t				" get data block number
   dac 9f+t+1 i				" save data block number
   lac 9f+t+2
   jms dskwr				" write indirect block back
   lac 9f+t				" get data block back
   jmp pget i				" return it
t = t+3

iwrite: 0
   dac 9f+t				" save arg in t0
   lac iwrite				" load return address

"** 01-s1.pdf page 38

   dac iread				" save as iread return addr
   lac cskp				" load skip instruction
   dac iwrite				" save as iwrite instruction
   jmp 1f

	" iread from file referenced by loaded inode
	" AC/ file offset
	"    jms iread; addr; count
iread: 0
   dac 9f+t				" save offset in t0
   lac cnop				" get nop
   dac iwrite				" save as iwrite instruction
1:
   -1
   tad iread i				" get word before return addr
   dac 10				" store in index 10 & 11
   dac 11
   isz iread				" increment return addr
   lac iread i				" load addr
   dac 9f+t+1				" save in t1
   isz iread				" increment return addr
   lac o70000
   xct iwrite				" skip if write
   lac i.size				"  read: get file size
   cma
   tad 9f+t				" add offset
   cma
   jms betwen; d0; 9f+t+1
      lac 9f+t+1
   dac 9f+t+2
   cma
   tad d1
   sna
   jmp iread i
   dac 9f+t+1
1:
   lac 9f+t
   jms pget
   dac 9f+t+3
   jms dskrd
   lac 9f+t
   and o77
   tad dskbufp
   tad dm1
   xct iwrite
   jmp .+3
   dac 10
cskp:
   skp
   dac 11
2:
   lac 11 i
   dac 10 i
   isz 9f+t
   isz 9f+t+1
   jmp 3f
      xct iwrite
      jmp 4f
      lac 9f+t
      jms betwen; d0; i.size
         dac i.size
      lac 9f+t+3
      jms dskwr
   4:
"** 01-s1.pdf page 38
      lac 9f+t+2
      jmp iread i
3:
   lac 9f+t
   and o77
   sza
   jmp 2b
   xct iwrite
   jmp 1b
   lac 9f+t+3
   jms dskwr
   jmp 1b
t = t+4

	" system call helper
	" AC/ fd
	"   jms finac
	" return with: fnode and inode loaded
	"	or makes error return to user
finac: 0
   lac u.ac
   jms fget
      jms error
   lac f.flags
   sma
   jms error
   lac f.i
   jms iget
   jmp finac i

	" update inode file size with value in AC
dacisize: 0
   dac i.size
   jms iput
   lac i.size
   jmp dacisize i
