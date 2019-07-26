# *****************************************************************************
#
#		Scan memcontent.c to find out where the ROM Load Call is.
#
# *****************************************************************************

def find(rom,pattern):
	count = 0
	for i in range(0,len(rom)-len(pattern)):
		if pattern[0] == rom[i]:
			if pattern == rom[i:i+len(pattern)]:
				count += 1
				offset = i
				print("{0:x}".format(offset))
	assert count > 0,"Not found"
	assert count == 1,"Found duplicate"
	return offset
#
#		Load file and find where the binary starts
#
src = [x.strip() for x in open("memcontent.c").readlines()]
p = 0
while not src[p].startswith("Uint8"):
	p+=1
src = src[p+1:]
#
#		Find where it ends and chop out the code.
#
p = 0
while src[p].startswith("0x"):
	p += 1
src = src[:p]
#
#		Convert to binary.
#
src = "".join(src).replace("\t","").replace(" ","").replace("0x","").split(",")
src = [int(x,16) for x in src]
assert len(src) == 16384
#
#		Find MEGA65.ROM
#
searchPattern = [ord(x) for x in "MEGA65.ROM"+chr(0)]
position = find(src,searchPattern)
stringAddress = position + 0x8000
print("ROM Name string at {0:x}".format(stringAddress))
#
#		Find LDX low LDY high (A2/A0)
#
searchPattern = [0xA2,stringAddress & 0xFF,0xA0,stringAddress >> 8]
position = find(src,searchPattern)
print("".join(["{0:04x} {1:02x}\n".format(x+0x8000,src[x]) for x in range(position,position+24)]))
loaderRoutine = position + 0x8000
print("Mega65.ROM Loader Routine at {0:x}".format(loaderRoutine))
#
#		From this visual identify where the call is.
#


#
#	In xemu-target.h in targets/mega65 directory comment out #define CPU_STEP_MULTI_OPS
#

#
#	In mega65.c, just before the call to cpu65_step (currently at line 606) insert code that
#	triggers on the address here (in this case the carry check *after* the ROM image
#	has been loaded).
#


		# /**
		# 	Just executed the LOAD ROM code.
		# */
		# if (cpu65.pc == 0xa564) {
		# 	for (int i = 0x20000;i < 0x40000;i+= 8) {
		# 		memory_debug_write_phys_addr(i,0x4C);
		# 		memory_debug_write_phys_addr(i+1,i & 0xFF);
		# 		memory_debug_write_phys_addr(i+2,(i >> 8) & 0xFF);
		# 		memory_debug_write_phys_addr(i+4,(i >> 0) & 0xFF);
		# 		memory_debug_write_phys_addr(i+5,(i >> 8) & 0xFF);
		# 		memory_debug_write_phys_addr(i+6,(i >> 16) & 0xFF);
		# 		memory_debug_write_phys_addr(i+7,(i >> 24) & 0xFF);
		# 	}
		# 	DEBUGPRINT("*** Found it ***\n");
		# 	for (int i = 0x20000;i < 0x20020;i++)
		# 		DEBUGPRINT("%x %x\n",i,memory_debug_read_phys_addr(i));	
		# }



		# if (cpu65.pc == 0xa564) {
		# 	printf("Loading ROM image\n");
		# 	FILE *f = fopen("rom.bin","rb");
		# 	if (f != NULL) {
		# 		int pos = 0x20000;
		# 		while (!feof(f)) {
		# 			int ch = fgetc(f);
		# 			memory_debug_write_phys_addr(pos++,ch);					
		# 		}
		# 		fclose(f);
		# 		printf("Loaded to address %x.\n",pos);
		# 	}
		# }
		