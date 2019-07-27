; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		execute.asm
;		Purpose :	Run/Stop/End commands.
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;	
;								RUN program
;
; *******************************************************************************************

COMMAND_Run: 	;; run
		jsr 	COMMAND_Clear 				; clear everything for a new run.
		ldx 	#BasicProgram & 255 		; start from here
		ldy 	#BasicProgram >> 8
		stx 	zCurrentLine 				; set current line.
		sty 	zCurrentLine+1		
		;
		;		Execute a new line at address in zCurrentLine
		;
CRUNNewLine:
		ldy 	#0 							; look at the offset, end of program
		lda 	(zCurrentLine),y 
		beq 	COMMAND_End 				; if zero, off end of program so stop.
		ldy 	#3 							; offset to first token.
		;
		;		Run another instruction from (zCurrentLine),y
		;
CRUNNextInstruction:
		lda 	(zCurrentLine),y 			; get next token
		beq 	CRUNNextLine 				; if zero, then end of line.
		;
		;		Something there, check for a colon.
		;
CRUNNotEndOfLine:
		cmp 	#KW_Colon 					; check for a colon first.
		bne 	CRUNExecuteOne 				; if not that, execute the token.
		iny		 							; if colon, skip it and loop round.
		bra 	CRUNNextInstruction
		;
		;		At the $00 token, go to the next line.
		;
CRUNNextLine:		
		ldy 	#0 							; add offset from line to line pointer
		lda 	(zCurrentLine),y
		clc 				
		adc 	zCurrentLine
		sta 	zCurrentLine
		bcc 	CRUNNewLine
		inc 	zCurrentLine+1
		bra 	CRUNNewLine
		;
		;
		;
CRUNExecuteOne:
		ora 	#0 							; if it is a character might be a variable.
		bpl		_CRUNX1TryLet
		cmp 	#KW_DOLLAR 					; likewise if ! something ? something $ something
		beq 	_CRUNX1TryLet
		cmp 	#KW_PLING
		beq 	_CRUNX1TryLet
		cmp 	#KW_QUESTION
		beq 	_CRUNX1TryLet
		;
		iny 								; skip over loaded token
		asl 	a 							; double lower keyword byte, clears bit 7.
		sta 	Temp1+1 					; this is the low byte into the KVT
		txa
		lda 	#KeywordVectorTable >> 8 	; set high byte of KVT
		sta 	Temp1+2
		lda 	#$6C 						; make it jump indirect
		sta 	Temp1+0
		lda 	#0 							; reset the string buffer position
		sta 	StringBufferPos
		jsr 	Temp1 						; call instruction
		bra 	CRUNNextInstruction 		; do next instruction.
		;
_CRUNX1TryLet:
		jsr 	COMMAND_Let 				; try doing a LET if not a keyword.
		bra 	CRUNNextInstruction

; *******************************************************************************************
;
;									STOP
;
; *******************************************************************************************

COMMAND_Stop:	;; stop
		#error "Stop"

; *******************************************************************************************
;
;									END
;
; *******************************************************************************************

COMMAND_End:	;; end
		#exit
		jmp 	WarmStart

