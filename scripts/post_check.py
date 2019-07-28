# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		post_check.py
#		Purpose :	If block.check and memory.dump exist compare them.
#		Date :		28th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os
#
#		If both files exist
#
if os.path.exists("memory.dump") and os.path.exists("../scripts/block.check"):
	#
	#		Read them both in.
	#
	dump = [x for x in open("memory.dump","rb").read(-1)]
	check = [x for x in open("../scripts/block.check","rb").read(-1)]
	#
	#		Compare files, from $1C00-$206C, e.g. variables and work area.
	#
	print(" *** Comparing files ***")
	errors = 0
	for n in range(0,len(check)):
		addr = 0x1C00
		if dump[addr] != check[n]:
			errors += 1
			print("\tError at ${0:04x} is ${1:02x} should be ${2:02x}".format(addr,check[n],dump[addr]))
	if errors == 0:
		print("\t*** Matches ***")
