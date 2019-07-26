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
		#error 	"Assert failed"
_CMDAExit:
		rts

; *******************************************************************************************
;
;									REM "single string" comment
;
; *******************************************************************************************

COMMAND_Rem:	;; REM
		iny
		lda 	(zCurrentLine),y 			; check string follows
		bne 	_CRMSyntax
		dey
		lda 	(zCurrentLine),y
		beq 	_CRMSyntax
		tya 								; skip over it.
		clc
		adc 	(zCurrentLine),y
		tay
		rts
_CRMSyntax:
		jmp 	SyntaxError	

; *******************************************************************************************
;
;						NEW erase program, clear non fixed variables
;
; *******************************************************************************************

COMMAND_New:	 ;; NEW
		lda 	#0 							; erase the actual program.
		sta 	BasicProgram
		sta 	BasicProgram+1
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
;				CLEAR non fixed variables, BASIC stack, Low Memory Pointer
;
; *******************************************************************************************

COMMAND_Clear: 	;; CLEAR

		ldx 	#hashTableSize*2-1 			; clear the hash table to all zeros.
_CCClearHash:
		lda 	#$AA
		sta 	HashTable,x
		dex
		bpl 	_CCClearHash 				
		;
		lda 	#basicStack & $FF 			; reset BASIC stack
		sta 	zBasicStack
		lda 	#basicStack >> 8
		sta 	zBasicStack+1
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
		lda 	zLowMemory 					; variables etc. start after end of program.
		clc
		adc 	#2
		sta 	zLowMemory
		bcc 	_CCNoCarry
		inc 	zLowMemory+1
_CCNoCarry:
		rts

; *******************************************************************************************
;
;									OLD Recover Newed Program
;
; *******************************************************************************************

COMMAND_Old:	;; OLD
		lda 	#BasicProgram & $FF 		; point zLowMemory to the first line.
		sta 	zLowMemory 						
		lda 	#BasicProgram >> 8
		sta 	zLowMemory+1
		ldy 	#4 							; look for the $0000 marker.
_COScan:	
		lda 	(zLowMemory),y 				; look at next byte pair
		iny
		ora 	(zLowMemory),y
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
		#error	"Cannot recover program"