# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		load_basic.py
#		Purpose :	Tokenise text, generate BASIC code.
#		Date :		2nd August 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re,random
from tokens import *
from token_basic import *

if __name__ == '__main__':

	bas = BasicProgram()
	for l in [x.strip() for x in open("basic.bas").readlines() if x.strip() != ""]:
		m = re.match("^(\d+)\s*(.*)$",l)
		assert m is not None
		bas.add(m.group(2).strip(),int(m.group(1)))
	bas.setBehaviour('R')
	#
	targetFile = open("../source/include/basic_generated.inc".replace("/",os.sep),"w")
	bas.render(targetFile)
	targetFile.close()

