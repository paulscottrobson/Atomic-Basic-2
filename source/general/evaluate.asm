; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		evaluate.asm
;		Purpose :	Evaluator (Precedence Climber)
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

EvaluateSNError:
		jmp 	SyntaxError
EvaluateMissingQuote:	
		#error 	"MISSING QUOTE"
EvaluateStringFull:
		#error 	"STRING BUFFER FULL"
EvaluateBadHex:
		#error 	"BAD HEX"

; *******************************************************************************************
;
;					Evaluate expression from reset stack/current level.
;
; *******************************************************************************************

EvaluateAtomCurrentLevel:
		lda 	#7 						
		bra 	EvaluateAtPrecedenceLevel

EvaluateBase:
		ldx 	#0 							; reset the stack

EvaluateBaseCurrentLevel:
		lda 	#0 							; current precedence is zero

EvaluateAtPrecedenceLevel:
		pha 								; save precedence level
		lda 	#0 							; zero the result.
		sta 	evalStack+0,x
		sta 	evalStack+1,x
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		;
_EVALSkipSpace1:		
		lda 	(zCurrentLine),y 			; get next token, skipping over spaces.
		beq 	EvaluateSNError 			; end of line, without token.
		iny
		cmp 	#32
		beq 	_EVALSkipSpace1
		dey 								; points at the token.
		;
		cmp 	#KW_DQUOTE					; is it opening quote ?
		beq 	_EVALString  				; if so load in a constant string
		cmp 	#KW_HASH 					; is it a hash, e.g. hexadecimal.
		beq 	_EVALHexadecimal 			
		cmp 	#'0'						; is it in range 0-9
		bcc		_EVALGoKeywordVariable 		; yes, it's a keyword or variable.
		cmp 	#'9'+1
		bcc 	_EVALDecimal
_EVALGoKeywordVariable:
		jmp 	_EVALKeywordVariable		
		;
		;		Decimal constant
		;
_EVALDecimal:
		jsr 	EVALGetDecConstant 			; get decimal constant
		bra 	_EVALGotAtom 				; got atom.		
		;
		;		String : copy into string buffer.
		;
_EVALString:		
		phx 								; save X on stack
		lda 	#StringBuffer >> 8 			; set the address in the eval stack
		sta 	evalStack+1,x
		lda 	StringBufferPos 			; X = Buffer Position.
		sta 	evalStack+0,x 				; that's the address of the new string
		tax 								; put in X to build the string.
		iny 								; skip over opening quote character
_EVALStringCopy:
		lda 	(zCurrentLine),y 			; get next character.
		iny
		beq		EvaluateMissingQuote 		; if zero, then there was no closing quote.
		sta 	StringBuffer,x 				; copy into the buffer
		inx 								; and bump that pointer.
		beq 	EvaluateStringFull 			; buffer is full.
		eor 	#KW_DQUOTE					; keep going if not closing quote.
		bne 	_EVALStringCopy
		stx 	StringBufferPos 			; this is the new next free slot.
		sta 	StringBuffer-1,x 			; write the zero (EOS) hence EOR to end string.		
		plx 								; restore X
		bra 	_EVALGotAtom 				; got the atom.
		;
		;		Hexadecimal.
		;
_EVALHexaDecimal
		iny 								; skip over the '#'
		phy 								; save Y
		jsr 	EVALGetHexConstant 			; load in hexadecimal constant
		sty 	Temp1 						; has Y changed ?
		pla
		cmp 	Temp1
		beq 	EvaluateBadHex 				; if not, error.
		;
		;		Got here, there is an atom in our stack level.
		;
_EVALGotAtom:
;		
_EVALGetOperator:		
		lda 	(zCurrentLine),y 			; get next token skip spaces.
		iny 								; this should be binary operator
		cmp 	#$20
		beq 	_EVALGetOperator
		dey
		ora 	#0 							; to be a binary token must be -ve
		bpl 	_EVALExitPullA 				; if +ve then exit now.


		phx 								; save X
		tax 								; token in X
		lda 	TokenTypeInformation-128,x 	; get the type info for it
		sta 	Temp1 						; save precedence in Temp1
		plx 								; restore X

		cmp 	#8 							; if type >= 8, e.g. not binary, then exit.
		bcs 	_EVALExitPullA 				

		pla 								; get and save precedence level.
		pha
		cmp 	Temp1 						; compare operator precedence - keyword precedence level.
		beq 	_EVALDoCalc					; equal, do it.		
		bcs 	_EVALExitPullA				; too high, then exit.
		;
		;		Work out the RHS
		;
_EVALDoCalc:		
		lda 	(zCurrentLine),y 			; get the token, save on stack and skip it.
		iny
		pha

		phx
		inx 								; work out right hand side.
		inx
		inx
		inx

		lda 	Temp1 						; get current operator precedence level.
		inc 	a 							; so work it out at the next level.
		jsr 	EvaluateAtPrecedenceLevel 	; work out the RHS.

		plx 								; fix X back.
		;
		;		Work out the index x 2, then the address of the jump vector.
		;
		pla 								; get keyword
_EVALExecuteA:		
		asl 	a 							; shift left, drop bit 7
		sta 	Temp1+1						; save in Temp1.1
		lda 	#KeywordVectorTable >> 8 	; set high byte of KVT
		sta 	Temp1+2 					; set at Temp1.2
		lda 	#$6C 						; make JMP (xxxx)
		sta 	Temp1+0 												
		jsr 	Temp1 						; call that routine.
		bra 	_EVALGotAtom 				; and loop back again.										
		;
		;		Exit code.
		;
_EVALExitPullA:
		pla 								; restore precedence.		
		rts
		;
		;		Check to see if it's a Unary function - keyword and type
		;
_EVALKeywordVariable:
		ora 	#0 							; check bit 7
		bpl 	_EVALNotUnaryFunction 		; must be set for unary function
		phx
		tax 	
		lda 	TokenTypeInformation-128,x 	; get the type info for it
		plx
		cmp 	#KTYPE_UNARYFN 				; is it a unary function
		bne 	_EVALNotUnaryFunction 	
		;
		;		Unary function.	
		;
		lda 	(zCurrentLine),y 			; get the token back
		iny 								; consume it
		bra 	_EVALExecuteA 				; execute TOS.	

_EVALNotUnaryFunction:			
		lda 	(zCurrentLine),y
		bpl 	_EVALCheckVariable 			; if ASCII check variable
		;
		cmp 	#KW_MINUS 					; check negation
		beq 	_EVALUnaryNegation
		cmp 	#KW_LPAREN 					; check left bracket.
		bne		_EVALCheckUnaryOperator 	
		;
		;		(expression)
		;
		iny 								; skip left bracket.
		jsr 	EvaluateBaseCurrentLevel 	; calculate what's in the bracket.
		lda 	#KW_RPAREN 					; check right bracket.
		jsr 	CheckNextCharacter 			; check next character, after spaces.
		bra 	_EVALGotAtom
		;
		;		-(atom)
		;
_EVALUnaryNegation:
		iny 								; skip over the - sign.
		jsr 	EvaluateAtomCurrentLevel 	; calculate what's being negatived (...)
		jsr 	BFUNC_NegateAlways 			; negate it.
		bra 	_EVALGotAtom
		;
		;		Choices left are $, ? or ! <atom>
		;
_EVALCheckUnaryOperator:		
		pha 								; save indirection operator.
		iny 								; skip over the operator
		jsr 	EvaluateAtomCurrentLevel 	; calculate the address.
		pla 								; restore the operator
		cmp 	#KW_DOLLAR					; $ is for visual typing, it does nothing
		beq 	_EVALGoGotAtom
		cmp 	#KW_QUESTION				; byte indirection
		beq 	_EVALByteRead
		cmp 	#KW_PLING					; word indirection
		beq 	_EVALWordRead
		jmp 	SyntaxError 				; give up.
		;
_EVALByteRead:
		jsr 	EVALReadByteIndirect
_EVALGoGotAtom:		
		jmp 	_EVALGotAtom
_EVALWordRead:
		jsr 	EVALReadWordIndirect
		jmp 	_EVALGotAtom
		;
		;		Check variable X, array element X(4), array element XX0
		;
_EVALCheckVariable:
		jsr 	VARReference 				; get variable reference to ZTemp1
		jsr 	EVALReadWordIndirectZTemp	; read that address into current stack level.
		jmp 	_EVALGotAtom 				; and go round.

; *******************************************************************************************
;
;						 Load in a decimal constant from the input. 
;
; *******************************************************************************************

EVALGetDecConstant:
		lda 	(zCurrentLine),y 			; get next
		cmp 	#'0'						; check in range 0-9.
		bcc 	_EVGDExit
		cmp 	#'9'+1
		bcc 	_EVGDValue 					; if so has legal value
_EVGDExit:
		rts

_EVGDValue:									; value. first multiply by 10.				
		pha 								; save value, Y on stack
		phy
		ldy 	#3 							; 3 shifts.

		lda 	evalStack+3,x 				; push x1 value on stack.
		pha
		lda 	evalStack+2,x
		pha
		lda 	evalStack+1,x
		pha
		lda 	evalStack+0,x
		pha
_EVGDLoop:
		asl 	evalStack+0,x 				; rotate left once.
		rol 	evalStack+1,x		
		rol 	evalStack+2,x		
		rol 	evalStack+3,x		

		cpy 	#2 							; if done it twice now
		bne 	_EVGDNoAdd

		clc 								; then it will be x 4, adding +1 => x 5
		pla
		adc 	evalStack+0,x 				
		sta 	evalStack+0,x
		pla
		adc 	evalStack+1,x 				
		sta 	evalStack+1,x
		pla
		adc 	evalStack+2,x 				
		sta 	evalStack+2,x
		pla
		adc 	evalStack+3,x 				
		sta 	evalStack+3,x

_EVGDNoAdd: 								; do 3 times in total.
		dey
		bne 	_EVGDLoop		
		ply 								; restore YA
		pla
		iny 								; next character
		and 	#15 						; force into range and put in.
		clc
		adc 	evalStack+0,x 				; add digit in
		sta 	evalStack+0,x
		bcc 	EVALGetDecConstant 			; propogate constant through
		inc 	evalStack+1,x
		bne 	EVALGetDecConstant 			
		inc 	evalStack+2,x
		bne 	EVALGetDecConstant 			
		inc 	evalStack+3,x
		bra 	EVALGetDecConstant 			; go back and try again.


; *******************************************************************************************
;
;							Load in a hex constant from the input. 
;
; *******************************************************************************************

EVALGetHexConstant:
		lda 	(zCurrentLine),y 			; get next
		jsr 	EVALToUpper 				; make upper case
		sec
		sbc 	#"0" 						; range 0-9
		bcc 	_EVGHExit 					; exit if CC
		cmp 	#9+1 						; if < 9 have a legal value.
		bcc 	_EVGHValue
		sbc 	#7 							; now in range 10-15 if okay.
		cmp 	#15+1
		bcc 	_EVGHValue		
_EVGHExit:
		rts		
		;
_EVGHValue:
		phy 								; save Y and new digit. 
		pha		
		ldy 	#4 							; rotate left 4
_EVGHRotate:
		asl 	evalStack+0,x
		rol 	evalStack+1,x		
		rol 	evalStack+2,x		
		rol 	evalStack+3,x		
		dey
		bne 	_EVGHRotate
		pla 								; restore digit and X
		ply
		iny 								; next character
		clc
		ora 	evalStack+0,x 				; add digit in
		sta 	evalStack+0,x
		bra 	EVALGetHexConstant 			; go back and try again.

; *******************************************************************************************
;
;									Convert A to upper case
;
; *******************************************************************************************

EVALToUpper:
		cmp 	#'a'
		bcc 	_EVTUExit
		cmp 	#'z'+1
		bcs 	_EVTUExit
		eor 	#32		
_EVTUExit:
		rts		

; *******************************************************************************************
;
;			Indirect byte read. If high bytes non zero do a long read on Mega65
;
; *******************************************************************************************

EVALReadByteIndirect:
		lda 	evalStack+0,x 	 			; copy address over.
		sta 	zTemp1
		lda 	evalStack+1,x 	
		sta 	zTemp1+1
		lda 	evalStack+2,x 	
		sta 	zTemp1+2
		lda 	evalStack+3,x 	
		sta 	zTemp1+3
		;
		.if 	TARGET=1 					; only for M65.	
		lda 	zTemp1+2 					; address $0000xxxx
		ora 	zTemp1+3 	
		beq 	_ERBBase
		ldz 	#0 							; read from far memory.
		nop
		lda 	(zTemp1),z
		bra 	_ERBExit
		.endif
_ERBBase:		
		phy
		ldy 	#0 							; read byte
		lda 	(zTemp1),y
		ply
_ERBExit:		
		sta 	evalStack+0,x
		;
		lda 	#0 							; zero upper three bytes
		sta 	evalStack+1,x
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		rts

; *******************************************************************************************
;
;			Indirect word read. If high bytes non zero do a long read on Mega65
;
; *******************************************************************************************

EVALReadWordIndirect:
		lda 	evalStack+0,x 	 			; copy address over.
		sta 	zTemp1
		lda 	evalStack+1,x 	
		sta 	zTemp1+1
		lda 	evalStack+2,x 	
		sta 	zTemp1+2
		lda 	evalStack+3,x 	
		sta 	zTemp1+3

EVALReadWordIndirectZTemp:		
		.if 	TARGET=1 					; only for M65.	
		lda 	zTemp1+2 					; address $0000xxxx
		ora 	zTemp1+3 	
		beq 	_ERWBase

		ldz 	#0 							; read from far memory.
		nop
		lda 	(zTemp1),z
		sta 	evalStack+0,x
		inz
		nop
		lda 	(zTemp1),z
		sta 	evalStack+1,x
		inz
		nop
		lda 	(zTemp1),z
		sta 	evalStack+2,x
		inz
		nop
		lda 	(zTemp1),z
		sta 	evalStack+3,x

		bra 	_ERWExit
		.endif		;
		;
_ERWBase		
		phy
		ldy 	#0 							; read word
		lda 	(zTemp1),y
		sta 	evalStack+0,x
		iny
		lda 	(zTemp1),y
		sta 	evalStack+1,x
		iny
		lda 	(zTemp1),y
		sta 	evalStack+2,x
		iny
		lda 	(zTemp1),y
		sta 	evalStack+3,x
		;
		ply
_ERWExit:		
		rts
