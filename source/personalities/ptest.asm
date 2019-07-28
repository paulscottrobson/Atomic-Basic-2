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

EXTZPWork = 4								; Zero Page work for EXT (4 bytes)
IOCursorX = 8 								; Cursor position
IOCursorY = 9

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

; ******************************************************************************
;
;								  Test code
;
; ******************************************************************************

StartLoop:
	inc 	10
	lda 	10
	ldx 	#4
	ldy 	#0
	jsr 	EXTWriteScreen
	jsr 	EXTCheckBreak
	inx
	inx
	jsr 	EXTWriteScreen
	jsr 	EXTReadKeyPort
	beq 	StartLoop
Start:
	pha
	ldx 	#0
	ldy 	#0
	lsr 	a
	lsr 	a
	lsr 	a
	lsr 	a
	jsr 	WriteNibble
	pla
	inx
	jsr 	WriteNibble
	jsr	 	EXTRemoveKeyPressed
	bra 	StartLoop

WriteNibble:
	and 	#15
	cmp 	#10
	bcc 	_WN0
	sbc 	#48+9
_WN0:	
	adc 	#48	
	jmp 	EXTWriteScreen