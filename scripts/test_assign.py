# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		test_assign.py
#		Purpose :	Check assignment and indirection does actually work.
#		Date :		26th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re,random
from tokens import *
from token_basic import *
from test_math import *

class AssignmentUnitTest(UnitTest):

	def __init__(self,randomSeed = None):
		self.memory = [ 0 ] * (4096 + 27*4)
		UnitTest.__init__(self,randomSeed)

	def getCount(self):
		return 2

	def generate(self):
		pass
	
	def create(self):
		UnitTest.create(self)
		open("block.check","wb").write(bytes(self.memory))

if __name__ == '__main__':
	bas = AssignmentUnitTest()
