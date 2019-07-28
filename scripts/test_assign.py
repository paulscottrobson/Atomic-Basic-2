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
		self.memory = [ 0 ] * (1024 + 27*4)
		self.base = 0x1C00
		self.show = False
		UnitTest.__init__(self,randomSeed)

	def create(self):
		UnitTest.create(self)
		open("block.check","wb").write(bytes(self.memory))

	def writeLong(self,addr,n):
		n &= 0xFFFFFFFF
		for i in range(0,4):
			self.writeByte(addr+i,n & 0xFF)
			n = n >> 8

	def writeByte(self,addr,n):
		self.memory[addr-0x1C00] = n

	def getCount(self):
		return 200

	def getVariable(self):
		return chr(random.randint(64,90))

	def setVariable(self,var,value):
		self.add("{0} = {1}".format(var,value),self.show)
		self.writeLong((ord(var)-64)*4+0x2000,value)

	def generate(self,c):
		#
		var = self.getVariable()							# assign value to an integer.
		n = self.getInteger()
		self.setVariable(var,n)
		
		addr = random.randint(0x1C00,0x1FE0)				# 32 bit indirect write.
		n = self.getInteger()
		self.add("!#{0:x} = {1}".format(addr,n),self.show)
		self.writeLong(addr,n)
		#
		addr = random.randint(0x1C00,0x1FE0)				# 8 bit indirect write.
		n = self.getInteger() & 0xFF
		self.add("?{0} = {1}".format(addr,n),self.show)
		self.writeByte(addr,n)
		#
		addr = random.randint(0x1C00,0x1FE0)				# string indirect write.
		s = self.getString(0,8)
		self.add('${0} = "{1}"'.format(addr,s),self.show)
		s = s + chr(0)
		for i in range(0,len(s)):
			self.writeByte(addr+i,ord(s[i]))
		# 													# 32 bit indirect binary write
		self.setVariable("Z",0x1C00)
		addr = random.randint(0x0000,0x0380)
		n = self.getInteger()
		self.add("Z!{0} = {1}".format(addr,n),self.show)
		self.writeLong(addr+0x1C00,n)

if __name__ == '__main__':
	bas = AssignmentUnitTest()
