; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		miscellany.asm
;		Purpose :	Miscellaneous Commands
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;										ASSERT <expr> test
;
; *******************************************************************************************

COMMAND_Assert:	;; assert
		jsr 	EvaluateBase 				; evaluate the expression
		lda 	evalStack+0,x 				; check non zero 	
		ora 	evalStack+1,x
		ora 	evalStack+2,x
		ora 	evalStack+3,x
		bne 	_CMDAExit
		#break
		#error 	"ASSERT FAILED"
_CMDAExit:
		rts

; *******************************************************************************************
;
;									REM "single string" comment
;
; *******************************************************************************************

COMMAND_Rem:	;; REM
		lda 	(zCurrentLine),y 			; get next character token.
		beq 	_CREMExit 					; End of line, then exit.
		iny 								; something to skip
		cmp 	#KW_COLON 					; if not a colon
		bne 	COMMAND_Rem 				; keep searching
_CREMExit:		
		rts

; *******************************************************************************************
;
;						NEW erase program, clear non fixed variables
;
; *******************************************************************************************

COMMAND_NewExec:	;; NEW
		jsr 	COMMAND_NewCode
		jmp 	WarmStart

COMMAND_NewCode:		
		lda 	#0 							; erase the actual program.
		sta 	BasicProgram 				; by zeroing the initial offset.
		;
		jsr 	COMMAND_Clear 				; clear non fixed variable, reset stack and low mem pointer
		;
		lda 	#endMemory & $FF 			; reset high memory pointer.
		sta 	HighMemory
		lda 	#endMemory >> 8
		sta 	HighMemory+1	
		;
		rts

; *******************************************************************************************
;
;					CLEAR variables, BASIC stack, Low Memory Pointer
;
; *******************************************************************************************

COMMAND_Clear: 	;; CLEAR

		ldx 	#0	 						; clear variables @A-Z	
_CCClearVar:
		lda 	#$00
		sta 	FixedVariables,x
		inx
		cpx 	#27*4
		bpl 	_CCClearVar
		;
		lda 	#0 							; reset BASIC stack index
		sta 	basicStackIndex
		lda 	#$FF 						; put invalid token on TOS, so when pulled.
		sta 	basicStack 					; causes an error.
		;
		lda 	#BasicProgram & $FF 		; now find where the program ends.
		sta 	zLowMemory
		lda 	#BasicProgram >> 8
		sta 	zLowMemory+1
_CCFindEnd:	
		ldy 	#0 							; look at next offset
		lda 	(zLowMemory),y 				; if zero, reached the end.
		beq 	_CCFoundEnd
		clc 								; go to next line.
		adc 	zLowMemory
		sta 	zLowMemory
		bcc 	_CCFindEnd
		inc 	zLowMemory+1
		bra 	_CCFindEnd
		;
_CCFoundEnd:
		inc 	zLowMemory 					; variables etc. start after end of program.
		bne 	_CCNoCarry 					; skip over zero end offset.
		inc 	zLowMemory+1
_CCNoCarry:
		rts

; *******************************************************************************************
;
;									OLD Recover Newed Program
;
; *******************************************************************************************

COMMAND_OldExec:;; OLD
		jsr 	COMMAND_OldCode
		jmp 	WarmStart

COMMAND_OldCode:
		lda 	#BasicProgram & $FF 		; point zLowMemory to the first line.
		sta 	zLowMemory 
		lda 	#BasicProgram >> 8
		sta 	zLowMemory+1
		ldy 	#3 							; look for the $00 end of line marker.
_COScan:	
		lda 	(zLowMemory),y 				; look at next byte pair
		iny
		beq 	_COFail 					; can't find marker, corrupted maybe ?
		cmp 	#0 							; until $00 found.
		bne 	_COScan
		;
		tya 								; Y is the new offset to the next instruction
		ldy 	#0 							; overwrite the old one
		sta 	(zLowMemory),y
		jsr 	COMMAND_Clear 				; reset variables, stacks and pointers.
		rts

_COFail:
		#error	"CANNOT RECOVER PROGRAM"

COMMAND_RST:	;; rst
		jsr 	EXTReset
		rts

; *******************************************************************************************
;
;									  LINK run program
;
; *******************************************************************************************

COMMAND_LINK: ;; LINK
		jsr 	EvaluateBase 				; evaluate the expression, where to call
		lda 	evalStack+2,x 				; check non zero 	
		ora 	evalStack+3,x
		bne 	_CLKError
		lda 	evalStack+0,x 				; copy link address
		sta 	linkAddress
		lda 	evalStack+1,x
		sta 	linkAddress+1
		;
		phy 								; save Y
		php 								; save PSW.

		lda 	registers+4 				; load P A X Y Z
		pha
		lda 	registers+0
		ldx 	registers+1
		ldy 	registers+2
		.if TARGET=1
		ldz 	registers+3
		.endif
		plp
		;
		jsr 	_CLKGoLink 					; call code.
		;
		php 								; save A X Y Z P
		sta 	registers+0
		stx 	registers+1
		sty 	registers+2
		.if TARGET=1
		stz 	registers+3
		.endif
		pla
		sta 	registers+4
		;
		plp 								; restore PSW and Y, return.
		ply
		rts
_CLKError:
		#error 	"BAD CODE ADDRESS"		
_CLKGoLink:
		jmp 	(linkAddress)		