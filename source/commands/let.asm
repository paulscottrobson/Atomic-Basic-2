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
		;		Start of assignment
		;
		cmp 	#KW_QUESTION				; check for first being indirect.
		beq 	_CLEIndirect 				; e.g. !x = 42
		cmp 	#KW_PLING
		beq 	_CLEIndirect
		cmp 	#KW_DOLLAR
		beq 	_CLEIndirect
		;
		;		Find a variable reference. Arguably should just be a single variable
		;		but being able to write AA0!4 would be handy.
		;
		ldx 	#0 							; clear evaluation stack.
		jsr 	VARReference 				; get a variable reference.
		;
		lda 	zTemp1 						; copy into target addr
		sta 	zTargetAddr
		lda 	zTemp1+1
		sta 	zTargetAddr+1
		lda 	zTemp1+2
		sta 	zTargetAddr+2
		lda 	zTemp1+3
		sta 	zTargetAddr+3
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
		;		Target address is in zTargetAddr. Code ptr should be pointing at '='
		;
_CLEWriteToAddress:		
		pha 								; save write-type.
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
		;		Restore the store-type and do the action.
		;
		pla
		cmp 	#KW_PLING
		beq 	_CLEWordWrite
		cmp 	#KW_QUESTION
		beq 	_CLEByteWrite
		cmp 	#KW_DOLLAR
_ErrorInternal:		
		bne 	_ErrorInternal
		jmp 	_CLEStringWrite
		;
		;		Come here on error
		;
_CLESyntax:
		jmp 	SyntaxError
		; 
		;		Come here for ?<atom> !<atom> and $<atom>
		;
_CLEIndirect:
		pha 								; save operator on stack
		iny									; advance over cursor
		ldx 	#0 							; evaluate the address to indirect through.
		jsr 	EvaluateAtomCurrentLevel 	
		lda 	evalStack+0,x				; copy that as the address.
		sta 	zTargetAddr+0
		lda 	evalStack+1,x
		sta 	zTargetAddr+1
		lda 	evalStack+2,x
		sta 	zTargetAddr+2
		lda 	evalStack+3,x
		sta 	zTargetAddr+3
		pla 								; restore operator.
		jmp 	_CLEWriteToAddress
		;
		;		Come here for term!$?term LHS. Already have the address of the
		;		left term in zTargetAddr.
		;
_CLEBinaryLHTerm:
		pha 								; save operator on stack
		iny 								; skip over it.
		ldx 	#0 							; evaluate the address to indirect through.
		jsr 	EvaluateAtomCurrentLevel 	
		;
		lda 	zTargetAddr 				; copy zTargetAddr to zTemp1. Technically
		sta 	zTemp1 						; a four byte address.....
		lda 	zTargetAddr+1
		sta 	zTemp1+1 					; we only worry about 4 byte value
		;
		phy 								; save Y
		clc 								; add variable evaluated to (zTargetAddr)
		ldy 	#0
		lda 	(zTemp1),y
		adc 	evalStack+0,x
		sta 	zTargetAddr+0
		iny
		lda 	(zTemp1),y
		adc 	evalStack+1,x
		sta 	zTargetAddr+1
		iny
		lda 	(zTemp1),y
		adc 	evalStack+2,x
		sta 	zTargetAddr+2
		iny
		lda 	(zTemp1),y
		adc 	evalStack+3,x
		sta 	zTargetAddr+3
		;
		ply 								; restore Y
		pla 								; restore the operator.
		jmp 	_CLEWriteToAddress
		;
		;		Byte indirect write
		;		
_CLEByteWrite:
		lda 	evalStack+0,x 				; get the byte to write.
		phy 								; write the byte preserving Y
		ldy 	#0
		sta 	(zTargetAddr),y
		ply
		rts		
		;
		;		Word indirect write (32 bit)
		;
_CLEWordWrite:
		phy
		ldy 	#0
		lda 	evalStack+0,x
		sta 	(zTargetAddr),y
		iny
		lda 	evalStack+1,x
		sta 	(zTargetAddr),y
		iny
		lda 	evalStack+2,x
		sta 	(zTargetAddr),y
		iny
		lda 	evalStack+3,x
		sta 	(zTargetAddr),y
		ply 								; restore Y
		rts
		;
		;		Write string at evalStack+0,1 to storage at zTargetAddr
		;		You cannot write to hardware this way.
		;
_CLEStringWrite:
		lda 	evalStack+0,x 				; source string -> zTemp1
		sta 	zTemp1 
		lda 	evalStack+1,x
		sta 	zTemp1+1
		;
		phy
		ldy 	#0
_CLEStringCopy:
		lda 	(zTemp1),y
		sta 	(zTargetAddr),y
		cmp 	#0
		beq	 	_CLEStringWritten
		iny
		bne 	_CLEStringCopy
		#error 	"BAD STRING COPY"
		;
_CLEStringWritten:
		ply 	
		rts

