# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		token_code.py
#		Purpose :	Generate token code.
#		Date :		26th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re
from tokens import *

# *******************************************************************************************
#
#									Token Code Generator
#
# *******************************************************************************************

class TokenCodeGenerator(object):
	def __init__(self):
		self.token = TokenList();
		self.tokens = self.token.getTokens()
		self.types = self.token.getTypes()
		self.routineLabels = {}		
	#
	#		Table for tokens. 
	#
	def generateTokenText(self,h):
		h.write("TokenText:\n")
		size = 1
		for t in self.tokens:
			codes = [ord(x) for x in t[0].upper()]
			codes[-1] = codes[-1] | 0x80
			size = size + len(codes)
			codes = ",".join(["${0:02x}".format(x) for x in codes])
			h.write('\t.byte {0:32}; ${2:04x} {1}\n'.format(codes,t[0],t[2]))
		h.write("\t.byte $00\n\n")
		h.write("TokenTypeInformation:\n")
		for t in self.tokens:
			h.write('\t.byte ${0:02x} {3:28}; ${2:04x} {1}\n'.format(t[1],t[0],t[2],""))
		h.write("\n\n")
		print("Token text table {0} bytes.\n".format(size))
	#
	#		Table for constants. These are the type constants, and the keyword constants.
	#
	def generateConstants(self,h):
		for i in range(0,len(self.types)):
			if self.types[i] is not None:
				h.write("KTYPE_{0} = ${1:02x}\n".format(self.types[i],i))
		h.write("\n")
		for t in self.tokens:
			label = "KW_"+t[0].upper()
			label = label.replace("&","AMPERSAND").replace("(","LPAREN").replace(")","RPAREN")
			label = label.replace("+","PLUS").replace("-","MINUS").replace("*","STAR").replace("/","FSLASH")
			label = label.replace("%","PERCENT").replace("=","EQUAL").replace("<","LESS").replace(">","GREATER")
			label = label.replace(",","COMMA").replace("|","BAR").replace("^","HAT").replace("~","TILDE")
			label = label.replace("!","PLING").replace("?","QUESTION").replace("$","DOLLAR").replace(":","COLON")
			label = label.replace(";","SEMICOLON").replace("'","SQUOTE").replace("#","HASH").replace('"',"DQUOTE")
			assert re.match("^KW\\_[0-9A-Z]+$",label) is not None,label+" bad constant."
			h.write("{0} = ${1:04x}\n".format(label,t[2]))
		h.write("\n")
	#
	#		Output vector table.
	#
	def generateVectorTable(self,h):
		h.write("KeywordVectorTable:\n")
		for t in self.tokens:
			lbl = "SyntaxError"
			if t[0] in self.routineLabels:
				lbl = self.routineLabels[t[0]]
			h.write("\t.word\t{0:30}; {1:10} (${2:04x})\n".format(lbl,'"'+t[0]+'"',t[2]))
		h.write("\n\n")
	#
	#		Scan source for code markers.
	#
	def scanSourceForMarkers(self,rootDirectory):
		for root,dirs,files in os.walk(rootDirectory):							# scan for files.
			for f in [x for x in files if x.endswith(".asm")]:
				srcFile = root+os.sep+f 										# file to process.
				for l in open(srcFile).readlines():
					if l.find(";;") > 0:										# quick check
						m = re.match("^([0-9A-Za-z\_]+)\:\s*\;\;\s*(.*?)\s*$",l)# check for marker
						if m is not None:
							keyword = m.group(2).strip().lower()
							assert keyword not in self.routineLabels,"Duplicate "+keyword
							self.routineLabels[keyword] = m.group(1)

if __name__ == '__main__':
	tcg = TokenCodeGenerator()
	#
	tcg.scanSourceForMarkers("../source")
	#
	targetFile = "../source/include/tokens.inc".replace("/",os.sep)
	h = open(targetFile,"w")
	tcg.generateVectorTable(h)
	tcg.generateTokenText(h)
	tcg.generateConstants(h)
	h.close()
	#tcg.generateVectorTable(sys.stdout)