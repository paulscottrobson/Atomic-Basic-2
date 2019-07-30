# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		token_basic.py
#		Purpose :	Tokenise text, generate BASIC code.
#		Date :		26th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re,random
from tokens import *

# *******************************************************************************************
#
#								Tokenise a text string
#
# *******************************************************************************************

class Tokeniser(object):
	def __init__(self):
		self.tokenList = TokenList().getTokens()								# get tokens
		self.tokenHash = {}														# convert to hash
		for t in self.tokenList:
			self.tokenHash[t[0].lower()] = t
	#
	#								Tokenise a single string
	#
	def tokenise(self,text):
		text = re.split('(\".*?\")',text)										# split quoted strings out
		for i in range(0,len(text)):											# set outside to L/C
			if not(text[i].startswith('"') and text[i].endswith('"')):
				text[i] = text[i].lower()
		text = "".join(text).strip()											# back together.
		self.tokens = []														# ends up as 16 bit tokens.
		while text != "":
			text = self.tokeniseOne(text)										# tokenise till donw
		return self.tokens 														# return tokens list.
	#
	#							Tokenise a single item.
	#
	def tokeniseOne(self,text):
		if text.startswith('"'):												# quoted strings aren't tokenised.
			text = text[1:]
			p = text.find('"')
			assert p >= 0,"Missing closing quote"
			self.tokens.append(self.tokenHash['"'][2])
			for c in text[:p]:
				self.tokens.append(ord(c))
			self.tokens.append(self.tokenHash['"'][2])
			return text[p+1:]				

		
		ch = 9
		while ch > 0:
			if text[:ch] in self.tokenHash:
				keyword = text[:ch].lower()
				self.tokens.append(self.tokenHash[keyword][2])
				return text[ch:]
			ch -= 1
		self.tokens.append(ord(text[0].upper()))
		return text[1:]
	#
	#								Simple tester
	#
	def tokeniseTest(self,text):
		print("==== {0} ====".format(text))
		tokens = ["${0:02x}".format(c) for c in self.tokenise(text)]
		print(" ".join(tokens))

# *******************************************************************************************
#
#								Create a BASIC program 
#
# *******************************************************************************************

class BasicProgram(object):
	def __init__(self):
		self.tokens = []														# token code
		self.lastLine = 0 														# auto number
		self.tokeniser = Tokeniser()
		self.action = "C"														# default behaviour
	#
	#		Set behaviour (R)un (C)ommand Line (T)okenise
	#		
	def setBehaviour(self,behaviour):
		self.action = behaviour.upper()
	#
	#		Add a line of BASIC
	#	
	def add(self,text,lineNumber = None):
		lineNumber = lineNumber if lineNumber is not None else self.lastLine+1 	# line number if req
		self.lastLine = lineNumber
		#print(lineNumber,text)
		tokens = self.tokeniser.tokenise(text.upper())							# tokenise/validate
		assert len(tokens)*2 < 254,"Line is too long" 											
		assert lineNumber < 65536,"Bad line number"
		self.tokens.append(len(tokens)+4)										# add offset, max 255
		self.tokens.append(lineNumber & 0xFF)									# add line#
		self.tokens.append(lineNumber >> 8)
		self.tokens = self.tokens + tokens 										# add tokens generated
		self.tokens.append(0)													# add end of line.
	#
	#		Render BASIC code.
	#
	def render(self,handle):
		out = self.tokens+ [0]
		print("Size of program = ${0:04x}".format(len(out)))
		out = ",".join(["${0:02x}".format(x) for x in out])
		handle.write("\t.byte {0}\n".format(out))
		handle.write("StartBehaviour:\n\t.text \"{0}\"\n".format(self.action))

if __name__ == '__main__':
	#tok = Tokeniser()
	#tok.tokeniseTest('42 65537 #a3 #ffff')
	#tok.tokeniseTest('1 "Hello world" 2')
	#tok.tokeniseTest(' "" "x" "yz" ')
	#tok.tokeniseTest(' printlen("Hello world")')
	#tok.tokeniseTest(' printcatdog("Hello world")a')

	bas = BasicProgram()
	bas.add('A = 0',12)
	bas.add('DO A = A + 1')
	bas.add('PRINT A;" ";A % 3')
	bas.add('until A=10',30)
	bas.add("M=#FFD3000",40)
	bas.add("stop",100)
	bas.add('print "*";:return',1000)

	bas.setBehaviour('R')
	#
	targetFile = open("../source/include/basic_generated.inc".replace("/",os.sep),"w")
	bas.render(targetFile)
	targetFile.close()

