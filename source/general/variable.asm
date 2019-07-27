; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		variable.asm
;		Purpose :	Variable Handler
;		Date :		27th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;			  Extract a variable/reference. Put the address in zTemp1 (32 bit)
;
; *******************************************************************************************

VARReference:	
		sec 								; check range @-Z there 
		cmp 	#'@'
		bcc 	_VARRError
		cmp 	#'Z'+1 						; there are 27 variables @ and A-Z
		bcc 	_VARROkay
_VARRError:
		jmp		SyntaxError
		;
_VARROkay:
		iny 								; consume the variable.
		cmp 	(zCurrentLine),y 			; is it @@ AA BB CC ?
		beq 	_VARArrayAccess 			; array access AA0 AA1 etc.
		lda 	(zCurrentLine),y 			; get that second character
		dey 								; point back to the first character
		cmp 	#KW_LPAREN 					; if ( then it is A(x) format.
		beq 	_VARArrayAccess
		;
		;		Straightforward variable access.
		;
		lda 	(zCurrentLine),y 			; reget variable.
		iny
		and		#31 						; mask out
		asl 	a 							; x 4
		asl 	a
		sta 	zTemp1+0 					; rely on variables being page aligned.
		lda 	#FixedVariables >> 8 		
		sta 	zTemp1+1
		lda 	#0 							; clear upper bytes
		sta 	zTemp1+2
		sta 	zTemp1+3 					; return with address set.
		rts 
		;
		;		Array access. The variable is at Y, the array is at Y+1
		;
_VARArrayAccess:	
		lda 	(zCurrentLine),y 			; get variable
		iny
		and 	#31 						; mask it off
		pha 								; save on the stack.
		;
		jsr 	EvaluateAtomCurrentLevel 	; calculate the index.
		;
		asl 	evalStack+0,x 				; multiply by four.
		rol 	evalStack+1,x
		rol 	evalStack+2,x
		rol 	evalStack+3,x
		;
		asl 	evalStack+0,x 				
		rol 	evalStack+1,x
		rol 	evalStack+2,x
		rol 	evalStack+3,x
		;
		pla 								; put address in zTemp1
		asl 	a 							; x 4
		asl 	a
		sta 	zTemp1+0 					; rely on variables being page aligned.
		lda 	#FixedVariables >> 8 		
		sta 	zTemp1+1
		;
		phy
		ldy 	#0 							; calculate	evalStack+0,3 + (zTemp)
		lda 	(zTemp1),y
		adc 	evalStack+0,x
		pha 								; save first result as we need the indirection.
		;
		iny 								; 2nd byte
		lda 	(zTemp1),y
		adc 	evalStack+1,x
		sta 	zTemp1+1
		pla 								; save the low byte.
		sta 	zTemp1+0
		;
		lda 	#0
		adc 	evalStack+2,x
		sta 	zTemp1+2
		;
		lda 	#0
		adc 	evalStack+3,x
		sta 	zTemp1+3
		;
		ply 								; restore Y, address setup
		rts

x1:		bra 	x1
