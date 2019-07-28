# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		test_math.py
#		Purpose :	Core Test routines and Simple Maths test
#		Date :		26th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re,random
from tokens import *
from token_basic import *

# *******************************************************************************************
#
#									Basic Unit Test
#
# *******************************************************************************************

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
		s = random.randint(0,10)
		n = 0
		if s >= 1:
			n = random.randint(0,10)
		if s >= 3:
			n = random.randint(0,1000)
		if s >= 5:
			n = random.randint(0,0x3FFFFFFF)
		return n if random.randint(0,1) == 0 else -n
	#
	def add(self,text):
		#print(text)
		self.basic.add(text,self.lineNumber)
		self.basicCode.write("{0:5} {1}\n".format(self.lineNumber,text))
		self.lineNumber += 1
	#
	def getString(self,sizeMin = 1,sizeMax = 3):
		return "".join([chr(random.randint(38,125)) for x in range(sizeMin,sizeMax+1)])

# *******************************************************************************************
#
#				Simple Unit test checking math/comparison funcs work.
#	
# *******************************************************************************************

class SimpleMathUnitTest(UnitTest):

	def getCount(self):
		return 40

	def generate(self):
		n1 = self.getInteger()
		n2 = self.getInteger()
		if random.randint(0,20) == 0:
			n2 = n1

		false = "-1"

		self.add("assert {0}+{1}={2}".format(n1,n2,n1+n2))
		if n1 > n2:
			self.add("assert {0}-{1}={2}".format(n1,n2,n1-n2))
		if n1*n2 < 0x3FFFFFFF:
			self.add("assert {0}*{1}={2}".format(n1,n2,n1*n2))
		if n2 != 0:
			self.add("assert {0}/{1}={2}".format(n1,n2,int(n1/n2)))
			self.add("assert {0}%{1}={2}".format(abs(n1),abs(n2),int(abs(n1)%abs(n2))))

		self.add("assert ({0}&{1})={2}".format(n1,n2,n1&n2))
		self.add("assert ({0}^{1})={2}".format(n1,n2,n1^n2))
		self.add("assert ({0}|{1})={2}".format(n1,n2,n1|n2))

		self.add("assert ({0}={1})={2}".format(n1,n2,false if (n1==n2) else 0))
		self.add("assert ({0}<>{1})={2}".format(n1,n2,false if (n1!=n2) else 0))
		self.add("assert ({0}<{1})={2}".format(n1,n2,false if (n1<n2) else 0))
		self.add("assert ({0}<={1})={2}".format(n1,n2,false if (n1<=n2) else 0))
		self.add("assert ({0}>{1})={2}".format(n1,n2,false if (n1>n2) else 0))
		self.add("assert ({0}>={1})={2}".format(n1,n2,false if (n1>=n2) else 0))

		s1 = self.getString()
		s2 = self.getString()
		result = 0
		if s1 != s2:
			result = 1 if s1 > s2 else -1
		self.add('assert ("{0}"~"{1}") = {2}'.format(s1,s2,result))

if __name__ == '__main__':
	bas = SimpleMathUnitTest()
