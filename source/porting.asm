; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		porting.asm
;		Purpose :	Basic Interpreter (Porting)
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

		* = 	$FFF8
EXTDummyInterrupt:							; interrupt that does nothing.
		rti
		* = 	$FFFA 						; create the vectors.
		.word 	EXTDummyInterrupt
		.word 	Start
		.word 	EXTDummyInterrupt

EXTZPWork = 4								; Zero Page work for Personality (4 bytes)
IOCursorX = 8 								; Cursor position
IOCursorY = 9

; ******************************************************************************
;
;					Load appropriate personality source in.
;
; ******************************************************************************

		zeroPage 	= $20 					; first ZP byte to use
		startMemory = $2000 				; first non ZP byte to use
		endMemory   = $4000 				; last non ZP byte to use
		basicStack  = $200 					; stack for BASIC
		evalStack   = $400 					; stack for evaluation of expressions

		.if TARGET=1
		.include 	"personalities/personality_mega65.asm"
		.endif
		.if TARGET=2
		.include 	"personalities/personality_6502.asm"
		.endif
		.include	"personalities/personality_io.asm"		
