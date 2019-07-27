; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		let.asm
;		Purpose :	Assignment Statement
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;								LET <lexpr> = <expression>
;
; *******************************************************************************************

COMMAND_Let: 	;; let
		lda 	(zCurrentLine),y 			; get first token not space
		beq 	_CLESyntax
		iny
		cmp 	#32
		beq 	COMMAND_Let
		dey
		;
		cmp 	#KW_QUESTION				; check for first being indirect.
		beq 	_CLEIndirect
		cmp 	#KW_PLING
		beq 	_CLEIndirect
		cmp 	#KW_DOLLAR
		beq 	_CLEIndirect
		;
		ldx 	#0 							; clear evaluation stack.
		jsr 	VARReference 				; get a variable reference.
		;
		;		Check Binary LHS operator, e.g. x?1 n!1 q$1
		;
_CLEGetBinLHSOp:		
		lda 	(zCurrentLine),y
		beq 	_CLESyntax
		iny
		cmp 	#' '
		beq 	_CLEGetBinLHSOp
		dey
		;
		cmp 	#KW_QUESTION 				; got some sort of reference, check
		beq 	_CLEBinaryLHTerm  			; if that's a basis for indirection ?
		cmp 	#KW_PLING
		beq 	_CLEBinaryLHTerm 
		cmp 	#KW_DOLLAR
		beq 	_CLEBinaryLHTerm 
		;
		lda 	#KW_PLING 					; we want to do a 32 bit write.
		;		
		;		Target address is in zTemp1. Should be pointing at '='
		;
_CLEWriteToAddress:		
		pha 								; save what we want to do on the stack.
		lda 	zTemp1 						; push zTemp on the stack
		pha
		lda 	zTemp1+1
		pha
		lda 	zTemp1+2
		pha
		lda 	zTemp1+3
		pha
		;
		;		Check if the '=' is present.
		;
		lda 	#KW_EQUAL 					; check for '=' sign.
		jsr 	CheckNextCharacter 
		;
		;		Get the RHS
		;
		jsr 	EvaluateBase 				; evaluate the RHS.
		;
		;		Restore the address back.
		;
		pla 
		sta 	zTemp1+3
		pla 	
		sta 	zTemp1+2
		pla 	
		sta 	zTemp1+1
		pla 	
		sta 	zTemp1+0
		;
		;		Restore the store-type and do the action.
		;
		pla
		cmp 	#KW_PLING
		beq 	_CLEWordWrite
		cmp 	#KW_DOLLAR
		beq 	_CLEStringWrite
		cmp 	#KW_QUESTION
		beq 	_CLEByteWrite
		#error 	"?IN"		
		;
		;		Come here on error
		;
_CLESyntax:
		jmp 	SyntaxError

		;
		;		Come here for term!$?term LHS. Already have the address of the
		;		left term in ZTemp1.
		;
_CLEBinaryLHTerm:
		#break

		; 
		;		Come here for ?<atom> !<atom> and $<atom>
		;
_CLEIndirect:
		pha 								; save operator on stack
		iny									; advance over cursor
		ldx 	#0 							; evaluate the address to indirect through.
		jsr 	EvaluateAtomCurrentLevel 	
		lda 	evalStack+0,x				; copy that as the address.
		sta 	zTemp1+0
		lda 	evalStack+1,x
		sta 	zTemp1+1
		lda 	evalStack+2,x
		sta 	zTemp1+2
		lda 	evalStack+3,x
		sta 	zTemp1+3
		pla 								; restore operator.
		jmp 	_CLEWriteToAddress

		;
		;		Byte indirect write
		;		
_CLEByteWrite:
		lda 	evalStack+0,x 				; get the byte to write.
		phy 								; write the byte preserving Y
		ldy 	#0
		sta 	(zTemp1),y
		ply
		rts		
		;
		;		Word indirect write (32 bit)
		;
_CLEWordWrite:
		phy
		ldy 	#0
		lda 	evalStack+0,x
		sta 	(zTemp1),y
		iny
		lda 	evalStack+1,x
		sta 	(zTemp1),y
		iny
		lda 	evalStack+2,x
		sta 	(zTemp1),y
		iny
		lda 	evalStack+3,x
		sta 	(zTemp1),y
		ply 								; restore Y
		rts
		;
		;		Write string at evalStack+0,1 to storage at zTemp1,zTemp1+1
		;
_CLEStringWrite:
		#break

