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
		#error 	"Missing string closing quote"
EvaluateStringFull:
		#error 	"String Buffer full"

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
		lda 	#0 							; zero the result upper word.
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
		beq 	_EVALString  				; if so 
		#break
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
		;
		;		Got here, there is an atom in our stack level.
		;
_EVALGotAtom:
		bra 	_EVALGotAtom
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

