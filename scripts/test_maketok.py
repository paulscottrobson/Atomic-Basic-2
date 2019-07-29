# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		test_maketok.py
#		Purpose :	Create at tokenisable string
#		Date :		29th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import re,sys,random
from token_basic import *

tokens = TokenList().getTokens()

def getString(mem,offset):
	s = ""
	while mem[offset] != 0:
		s = s + chr(mem[offset])
		offset += 1
	return s

def getItem():
	n = random.randint(0,3)
	if n == 0:
		return str(random.randint(0,9999))
	if n == 1 or n == 2:
		s = "".join([chr(random.randint(64,90)) for x in range(0,random.randint(1,3))])+" "
		return s if n == 1 else '"'+s+'"'
	i = random.randint(0,len(tokens))
	t = tokens[i][0].upper()
	return getItem() if t == '"' else t

def fmt(x):
	return " ".join(["{0:02x}".format(c) for c in x])

assert len(sys.argv) == 2

if sys.argv[1] == "create":
	random.seed()
	seed = random.randint(0,999999)
	print("Seed is ",seed)
	h = open("../source/include/basic_generated.inc","w")
	src = ''
	count = random.randint(4,8)
	for i in range(0,count):
		src += getItem()
		if random.randint(0,2) == 0:
			src += " "
		if random.randint(0,2) == 0:
			src += " "
	src = src.strip().upper()
	print("Source [{0}]".format(src))
	src = ",".join([str(ord(x)) for x in src])
	h.write('\t.text {0},0\n\n'.format(src))
	h.write('StartBehaviour:\n\t.text "T"\n\n')
	h.close()

elif sys.argv[1] == "check":
	dump = [x for x in open("memory.dump","rb").read(-1)]
	source = getString(dump,0x2300)
	tokenised = [ord(x) for x in getString(dump,0x2100)]
	print("Source [{0}]".format(source))
	print("6502 ",fmt(tokenised))
	result = Tokeniser().tokenise(source)
	print("Python ",fmt(result))
	if tokenised != result:
		while True:
			pass
	print("Ok !")
