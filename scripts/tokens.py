# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		tokens.py
#		Purpose :	Token elements
#		Date :		26th July 2019
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

# *******************************************************************************************
#
#								Class that constructs a token list
#
#	Everything is tokenised except 0-9A-Z@
#
# *******************************************************************************************

class TokenList(object):
	def __init__(self):
		src = self.getSource()
		#
		#		Preprocess source
		#
		src = [x.replace("\t"," ").strip().lower() for x in src]
		src = [x for x in src if not x.startswith("#")]
		src = [x for x in " ".join(src).split(" ") if x != ""]
		mode = None
		#
		#		Rip out tokens and grouping.
		#
		self.tokens = []
		for t in src:
			if t.startswith("[") and t.endswith("]"):
				t = t[1:-1]
				if t >= "0" and t <= "6":
					mode = int(t)
				elif t == "commands":
					mode = 8
				elif t == "unary":
					mode = 9
				elif t == "syntax":
					mode = 10
				else:
					assert "Bad mode "+t
			else:
				self.tokens.append([t,mode])
		#
		#		Sort order is alphabetical on first character, but with the
		#		individual subgroups by first character sorted on length backwards
		#		(e.g. then top to)
		#
		self.tokens.sort(key = lambda x:ord(x[0][0])*100+(10-len(x[0])))
		#			
		#		Allocate tokens
		#
		for i in range(0,len(self.tokens)):
			self.tokens[i].append(i+0x80)
	#
	def getTokens(self):
		return self.tokens
	#
	def getTypes(self):
		return [ "PRECBASE",None,None,None,None,None,None,None,
				 "COMMAND","UNARYFN","SYNTAX"]
	#
	def getSource(self):
		return	"""
		#
		#		Binary operators and their precedence levels.
		#
		[0]			& 	| 	^
		[1]			>	<	>=	<=	<> 	=	~
		[2] 		+ 	-	
		[3]			*	/	%
		[4] 		! 	? 	$
		#
		#		Standard commands
		#
		[command]	let 	end 	goto	gosub	for 	next
					print 	input 	list 	stop 	assert 	rem		
					new 	old 	clear	if		then 	do		
					until 	to 		step	link	run 	cls					
					return
		#
		#		Unary operators
		#
		[unary]		len		ch		rnd 	abs 	top		page	
					get 	ioaddr
		#
		#		Syntax operators
		#
		[syntax]	( 		)		# 		:		;		'
					"
					
		""".split("\n")


if __name__ == '__main__':
	t = TokenList()
	print(t.getTypes())
	print(t.getTokens())