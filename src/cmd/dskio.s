" dskio

	" Reads 10 blocks from side 0 at block address AC into buffer dskbuf
dskrd0: 0
   dzm side		" set side to 0
   jms dskio; 02000	" read 10 blocks starting at block AC on side 0
   jmp i dskrd0		" return to caller

	" Writes 10 blocks from buffer dskbuf onto side 0 at block address AC
dskwr0: 0
   dzm side		" set side to 0
   jms dskio; 03000	" write 10 blocks tarting at block AC on side 0
   jmp i dskwr0		" return to caller

	" Reads 10 blocks from side 1 at block address AC into buffer dskbuf
dskrd1: 0
   lmq			" set side to 1
   lac o200000
   dac side
   lacq
   jms dskio; 02000	" read 10 blocks starting at block AC on side 1
   jmp i dskrd1		" return to caller

	" Writes 10 blocks from buffer dskbuf onto side 1 at block address AC
dskwr1: 0
   lmq			" Set side to 1
   lac o200000
   dac side
   lacq
   jms dskio; 03000	" write 10 blocks starting at block AC on side 1
   jmp i dskwr1		" return to caller

	" dskio depends on the DSLS_BITS after jump to subroutine:
	"    jms dskio; DSLS_BITS
	" DSLS_BITS 02000 causes a read, 03000 causes a write.
	"
	" In both cases 10 blocks worth of data is either transferred from
	" disk into dskbuf (read), or transferred from dskbuf onto the disk
	" (write). A block is the same as a segment, each comprising 64 words.
	"
	" The location on disk is controlled by the variable "side" and the
	" value in AC, representing the number of blocks from the start
	" of the side.
	"
	" dskio takes the block address passed in AC, divides it by 80
	" to get the track address, and as a remainder the segment address.
	" Both are then re-encoded as BCD, shifted to the correct bit
	" positions (explained below) and ORed together with the value of
	" the "side" variable (representing the hundreds flag in the disk
	" address). This disk address is then passed on to the disk just
	" before starting the transfer in chunks of 10 segments each.
	"
	" The disk address for RB09 disks is formatted like this:
	"
	" * Bit 0 not used
	" * Bit 1 hundreds flag for track address
	" * Bits 2-5 Tens digit for track address as BCD
	" * Bits 6-9 Units digit for track address as BCD
	" * Bits 10-13 Tens digit for segment address as BCD
	" * Bits 14-17 Units digit for segment address as BCD
	"
	" If the disk indicates an error the transfer is attempted 10 times
	" before dskio gives up and halts the program.
dskio: 0
   cll; idiv; 80	" compute binary track and segment addresses
   dac 2f		" store binary segment address
   lacq			" get binary track address back into AC
   idiv; 10		" compute BCD track address from binary track address
   dac 3f
   lls 22
   xor 3f		" OR together Tens and Units digits of BCD track address
   als 8		" shift BCD track address to bit position in disk address
   dac 3f		" store BCD track address
   lac 2f		" load binary segment address
   idiv; 10		" compute BCD segment address from binary segment address
   dac 2f
   lls 22
   xor 2f		" OR together Tens and Units digits of BCD segment address
   xor 3f		" OR together track and segment addresses
   xor side		" OR together side, track and segment addresses
			" to make the complete disk address
   dac 2f		" store disk address
   -10			" do at most 10 transfer attempts
   dac 3f
1:
   dscs			" clear disk status
   -640			" prepare transfer of 10 segments (10 blocks)
   dslw
   lac dskbufp		" load pointer to dskbuf into MAC
   dslm
   lac 2f		" load previously computed disk address
   dsld
   lac dskio i		" load disk status register (one bit is the read/write flag)
   dsls
   dssf			" wait for ERROR/DONE
   jmp .-1
   dsrs			" read disk status into AC, bit 0 indicates errors
   sma			" if bit 0 of AC is set, AC is negative.
			" if AC is negative, continue below and do another
			" transfer attempt...
   jmp 1f		" ...otherwise jump to the subroutine exit code below
   isz 3f		" increment transfer attempts, and...
   jmp 1b		" ...retry if more attempts remain
   hlt			" when no more attempts remain, stop program due to
			" persistent disk error
1:
   isz dskio		" skip over argument passed to dskio
   jmp i dskio		" return to caller

2: 0			" local variable storing first binary segment address,
			" then disk address
3: 0			" local variable storing first BCD track address,
			" then loop counter

o200000: 0200000	" bit corresponding to set Hundreds flag in disk address
dskbufp: dskbuf		" pointer to transfer buffer

side: .=.+1		" which side to access
dskbuf: .=.+640		" transfer buffer for 10 blocks
