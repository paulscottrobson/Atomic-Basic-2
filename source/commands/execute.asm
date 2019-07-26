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
		ldy 	#4 							; offset to first token.
		;
		;		Run another instruction from (zCurrentLine),y
		;
CRUNNextInstruction:
		iny 								; check end of line.
		lda 	(zCurrentLine),y
		tax 								; XA = Token.
		dey
		lda 	(zCurrentLine),y 			; if XA = 0 then next line.
		bne 	CRUNNotEndOfLine
		cpx 	#0
		beq 	CRUNNextLine
		;
		;		Something there, check for a colon.
		;
CRUNNotEndOfLine:
		cmp 	#KW_Colon & $FF 			; check for a colon first.
		bne 	CRUNExecuteOne
		cpx 	#KW_Colon >> 8
		bne 	CRUNExecuteOne
		iny 								; if found, try next instruction
		iny		
		bra 	CRUNNextInstruction
		;
		;		At the $0000 token, go to the next line.
		;
CRUNNextLine:		
		iny 								; step over it.
		iny
		tya
		clc 								; add Y+2 to pointer
		adc 	zCurrentLine
		sta 	zCurrentLine
		bcc 	CRUNNewLine
		inc 	zCurrentLine+1
		bra 	CRUNNewLine
		;
		;		Execute instruction in XA
		;
CRUNExecuteOne:
		iny 								; skip over loaded token
		iny
		asl 	a 							; double lower keyword byte.
		pha 								; save on stack.
		txa 								; roll carry out into upper byte.
		rol 	a
		and 	#3 							; now an index 
		tax 								; back in X
		pla
		clc 
		adc 	#(KeywordVectorTable-2)&$FF
		sta 	Temp1+1
		txa
		adc 	#(KeywordVectorTable-2)>>8
		sta 	Temp1+2
		lda 	#$6C 						; make it jump indirect
		sta 	Temp1+0
		jsr 	Temp1 						; call instruction
		bra 	CRUNNextInstruction 		; do next instruction.

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

