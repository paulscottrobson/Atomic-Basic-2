# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		test_basic.py
#		Purpose :	Test routines.
#		Date :		26th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re,random
from tokens import *
from token_basic import *

class UnitTest(object):
	def __init__(self,randomSeed = None):
		if randomSeed is None:
			random.seed()
			randomSeed = random.randint(0,999999)
		random.seed(randomSeed)
		print("Using seed {0}".format(randomSeed))
		self.lineNumber = 1
		self.basicCode = open("basic.txt","w")
		self.create()
		self.basicCode.close()
	#
	def create(self):
		self.basic = BasicProgram()
		for i in range(0,self.getCount()):
			self.generate()
		name = "../source/include/basic_generated.inc".replace("/",os.sep)
		targetFile = open(name,"w")
		self.basic.render(targetFile)
		targetFile.close()
	#
	def getInteger(self):
		s = random.randint(0,3)
		n = 0
		if s == 1:
			n = random.randint(0,10)
		if s == 2:
			n = random.randint(0,1000)
		if s == 3:
			n = random.randint(0,0x3FFFFFFF)
		return n
	#
	def add(self,text):
		self.basic.add(text,self.lineNumber)
		self.basicCode.write("{0:5} {1}\n".format(self.lineNumber,text))
		self.lineNumber += 1

class SimpleMathUnitTest(UnitTest):

	def getCount(self):
		return 300

	def generate(self):
		n1 = self.getInteger()
		n2 = self.getInteger()

		self.add("assert {0}+{1}={2}".format(n1,n2,n1+n2))
		if n1 > n2:
			self.add("assert {0}-{1}={2}".format(n1,n2,n1-n2))
		if n1*n2 < 0x3FFFFFFF:
			self.add("assert {0}*{1}={2}".format(n1,n2,n1*n2))
		if n2 != 0:
			self.add("assert {0}/{1}={2}".format(n1,n2,int(n1/n2)))
			self.add("assert {0}%{1}={2}".format(n1,n2,int(n1%n2)))

		#self.add("assert {0}&{1}={2}".format(n1,n2,n1&n2))
		#self.add("assert {0}|{1}={2}".format(n1,n2,n1|n2))
		#self.add("assert {0}^{1}={2}".format(n1,n2,n1^n2))


if __name__ == '__main__':
	bas = SimpleMathUnitTest()
