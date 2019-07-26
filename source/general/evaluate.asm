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

; *******************************************************************************************
;
;					Evaluate expression from reset stack/current level.
;
; *******************************************************************************************

EvaluateBase:
		ldx 	#0 							; reset the stack

EvaluateBaseCurrentLevel:
		lda 	#0 							; current precedence is zero

EvaluateAtPrecedenceLevel:
		pha 								; save precedence level
		lda 	#0 							; zero the top two bytes of the result
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		;
		iny 								; get high byte of next token
		lda 	(zCurrentLine),y 
		dey
		cmp 	#0 							; is it $00 (end or string)
		beq 	_EVALString
		bpl 	_EVALNotString 				; if +ve it is a keyword or a constant
		jmp 	_EVALVariable 				; if -ve it is a variable.
		;
		;		String item 	(00xx)
		;
_EVALString:		
		lda 	(zCurrentLine),y 			; get the length.
		beq 	EvaluateSNError 			; if zero, that's an error.
		;
		clc 								; copy currentline + Y + 2
		tya 								; as the low bytes of the result
		adc 	#2
		adc 	zCurrentLine
		sta 	evalStack+0,x
		lda 	zCurrentLine+1
		adc 	#0
		sta 	evalStack+1,x
		;
		tya 								; work out offset for next.
		clc
		adc 	(zCurrentLine),y
		tay

		bra 	_EVALGotAtom 				; got the atom.
		;
_EVALNotString:		
		cmp 	#$40 	 					; if $4000-$7FFF this is a constant.
		bcs 	_EVALConstant
		jmp	 	_EVALKeyword				; keyword, which means unary function or operator.	
		;
		;		Constant 	(4000-7FFF)
		;
_EVALConstant:
		and 	#$3F 						; only interested in upper 6 bits (14 of word)
		sta 	evalStack+1,x 				; the msb
		lda 	(zCurrentLine),y 			; get the lsb and copy it
		sta 	evalStack+0,x
		iny									; advance to next
		iny
_EVALIntegerNext:		
		iny 								; get the MSB of the next token.
		lda 	(zCurrentLine),y
		dey 								
		and 	#$C0 						; $4000-$7FFF is 01xx xxxx
		cmp 	#$40
		bne		_EVALGotAtom
		;
		;		Constant followed by another one, so shift up to make room :)
		;
		lda 	evalStack+2,x 				; effectively, shift left 16.
		sta 	evalStack+4,x 			
		lda 	evalStack+1,x
		sta 	evalStack+3,x
		lda 	evalStack+0,x
		sta 	evalStack+2,x
		lda 	#0 							
		sta 	evalStack+1,x 				; don't worry about +0, it is overwritten.
		;
		phy 								; rotate it right twice.
		ldy 	#2
_EVALRotate:
		lsr 	evalStack+4,x
		ror 	evalStack+3,x
		ror 	evalStack+2,x
		ror 	evalStack+1,x
		dey
		bne 	_EVALRotate
		ply		
		; 						
		lda 	(zCurrentLine),y 			; put the new word in.
		sta 	evalStack+0,x
		iny
		lda 	(zCurrentLine),y
		and 	#$3F 						; 14 bits of word.
		ora 	evalStack+1,x
		sta 	evalStack+1,x
		iny
		bra 	_EVALIntegerNext 			; and check yet again.
		;
		;		Got here, there is an atom in our stack level.
		;
_EVALGotAtom:
		iny 								; get the MSB of the token
		lda 	(zCurrentLine),y 			; 001t tttk - we want 0010 xxxx 
		and 	#$F0 						; for it to be a binary operator.
		cmp 	#$20
		bne 	_EVALExitDecY 				; not a binary operator, so exit, unpicking the INY.
		lda 	(zCurrentLine),y 			; get the token again
		and 	#$0E 						; mask out the precedence bits
		lsr 	a 							; now in bits 0,1,2
		sta 	Temp1 						; save it.
		pla 								; get current precedence level
		pha 								; push it back again.
		cmp 	Temp1 						; compare operator precedence - keyword precedence level.
		beq 	_EVALDoCalc					; equal, do it.		
		bcs 	_EVALExitDecY				; too high, then exit.
		;
		;		Work out the RHS
		;
_EVALDoCalc:		
		dey
		lda 	(ZCurrentLine),y 			; low byte of operator.
		pha
		iny 							
		lda 	(ZCurrentLine),y 			; high byte of operator
		pha
		iny 								; now points to next.

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
		pla 								; get keyword MSB ack
		and 	#1 							; ID bit
		sta 	Temp1+2 					; save in Temp1.2
		pla 	 							; get LSB	
		asl 	a 							; double it
		rol 	Temp1+2 					; shift carry out from ASL into upper byte.
		;
		adc 	#(KeywordVectorTable-2) & $FF
		sta 	Temp1+1
		lda 	Temp1+2
		adc 	#(KeywordVectorTable-2) >> 8
		sta 	Temp1+2						; save in Temp1.1, which now has the indirect address
											; of the routine.
		lda 	#$6C 						; make JMP (xxxx)
		sta 	Temp1+0 												
		jsr 	Temp1 						; call that routine.
		bra 	_EVALGotAtom 				; and loop back again.										
		;
		;		Exit code.
		;
_EVALExitDecY:
		dey
		pla 								; restore precedence.
_EVALExit:		
		rts

_EVALKeyword:
		bra 	_EVALKeyword

_EVALVariable:
		bra 	_EVALVariable

