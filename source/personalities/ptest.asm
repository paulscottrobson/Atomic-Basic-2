; ******************************************************************************
; ******************************************************************************
;
;		Name: 		ptest.asm
;		Purpose:	Personality Code test routines.
;		Date: 		26th July 2019
;		Author:		Paul Robson
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								6502 Vectors
;
; ******************************************************************************

	* = 	$FFF8
EXTDummyInterrupt:							; interrupt that does nothing.
	rti
	* = 	$FFFA 							; create the vectors.
	.word 	EXTDummyInterrupt
	.word 	EXTStartPersonalise
	.word 	EXTDummyInterrupt

EXTZPWork = 4								; Zero Page work for EXT

; ******************************************************************************
;
;					Load appropriate personality source in.
;
; ******************************************************************************

	.if TARGET=1
	.include 	"personality_mega65.asm"
	.endif
	.if TARGET=2
	.include 	"personality_6502.asm"
	.endif
	.include	"personality_io.asm"

; ******************************************************************************
;
;								  Test code
;
; ******************************************************************************

Start:
	jsr 	IOInitialise
	ldx 	#St1 & 255
	ldy 	#St1 >> 8
	jsr 	IOPrintString
Loop:
	ldx 	#$80
	ldy 	#$00
	jsr		IOReadLine	
	.byte 	3
	bra 	Loop

St1:.text 	"7167 BYTES FREE",0

