; ******************************************************************************
; ******************************************************************************
;
;		Name: 		personality_io.asm
;		Purpose:	Personality Common I/O Routines
;		Date: 		22nd July 2019
;		Author:		Paul Robson
;
; ******************************************************************************
; ******************************************************************************

IOCursorX = 8 								; cursor position
IOCursorY = 9
IOLineLo = 10 								; line position.
IOLineHi = 11

; ******************************************************************************
;
;						Initialise the I/O System
;
; ******************************************************************************

IOInitialise:
		jsr 	EXTClearScreen 				; clear screen.
		pha
		lda 	#00 						; home cursor
		sta 	IOCursorX
		sta 	IOCursorY
		pla
		rts

; ******************************************************************************
;
;								Print Character
;
;	Handles 	13 (CR) 8 (Backspace) Ctrl-WASD move Ctrl-Z Clear.
; ******************************************************************************

IOPrintChar:		
		pha 								; save registers
		phx
		phy
		and 	#$7F 						; 7 bits only.
		cmp 	#13 						; handle CR
		beq 	_IOPCCarriageReturn
		cmp 	#$20 						; control character
		bcc 	_IOPControl
		jsr	 	IOGetCursorXY 				; get cursor address in XY.
		and 	#$3F 						; 6 bit PETSCII
		jsr 	EXTWriteScreen 				; write character at that position.
		inc 	IOCursorX 					; increment cursor X
		lda 	IOCursorX
		cmp 	#EXTWidth 					; zero if at RHS
		bne 	_IOPCExit
		;
_IOPCCarriageReturn:
		lda 	#0							; LHS
		sta 	IOCursorX
		inc 	IOCursorY 					; one down
		lda 	IOCursorY 					; off the bottom ?
		cmp 	#EXTHeight
		bne 	_IOPCExit
		dec 	IOCursorY 					; back up and scroll
		jsr 	EXTScrollDisplay
		bra 	_IOPCExit
		;
_IOPCClear:
		jsr 	EXTClearScreen
		lda 	#0
		sta 	IOCursorX
		sta 	IOCursorY		
		;
_IOPCExit:									; reload registers and exit
		ply
		plx
		pla
		rts
		;
_IOPControl:
		cmp 	#"Z"-64						; Ctrl-Z clear
		beq 	_IOPCClear
		cmp 	#"A"-64 					; Cursor movement.
		beq 	_IOPLeft
		cmp 	#"D"-64
		beq 	_IOPRight
		cmp 	#"W"-64
		beq 	_IOPUp
		cmp 	#"S"-64
		beq 	_IOPDown
		cmp 	#8							; Backspace
		bne 	_IOPCExit
		;
		jsr	 	IOGetCursorXY 				; get cursor address in XY.
		lda 	#" "
		jsr 	EXTWriteScreen 				; write space at that position.
		;
_IOPLeft:									; cursor movement.
		dec 	IOCursorX
		bpl 	_IOPCExit
		lda 	#EXTWidth-1
		sta 	IOCursorX
		bra 	_IOPCExit

_IOPRight:
		inc 	IOCursorX
		lda 	IOCursorX
		eor 	#EXTWidth
		bne 	_IOPCExit
		sta 	IOCursorX
		bra 	_IOPCExit

_IOPUp:
		dec 	IOCursorY
		bpl 	_IOPCExit
		lda 	#EXTHeight-1
		sta 	IOCursorY
		bra 	_IOPCExit

_IOPDown:
		inc 	IOCursorY
		lda 	IOCursorY
		eor 	#EXTHeight
		bne 	_IOPCExit
		sta 	IOCursorY
		bra 	_IOPCExit

; ******************************************************************************
;
;						Convert character to upper case
;
; ******************************************************************************

IOUpperCase:
		cmp 	#"a"
		bcc 	_IOUCExit
		cmp 	#"z"+1
		bcs 	_IOUCExit
		sec
		sbc 	#32
_IOUCExit:
		rts

; ******************************************************************************
;
;					Calculate position on screen X + Y * 40
;
;					Note, if Width is not 40 this won't work.
; ******************************************************************************

IOGetCursorXY:	
		pha

		lda 	IOCursorY 					; multiply IOCursorY x 5
		asl		a
		asl		a 							; x 4, carry clear
		adc 	IOCursorY 					; so this will be 0..199 now
		tax

		txa 								; x 10
		asl 	a
		tax
		lda 	#0
		rol 	a
		tay

		txa 								; x 20
		asl 	a
		tax
		tya 
		rol 	a
		tay

		txa 								; x 40
		asl 	a
		tax
		tya 
		rol 	a
		tay

		txa 								; add X to that.
		clc
		adc 	IOCursorX
		tax
		bcc 	_IOGCXYExit
		iny
_IOGCXYExit:		
		pla
		rts	

; ******************************************************************************
;
;					Read line to XY from current position
;
; ******************************************************************************

IOReadLine:
		pha
		stx		IOLineLo
		sty 	IOLineHi
_IROLLoop:
		jsr	 	IOGetCursorXY 				; get cursor address in XY.
		jsr 	EXTReadScreen 				; get character there.
		pha
		lda 	#102 						; write cursor character there
		jsr		EXTWriteScreen
_IROLWaitKey:								; get a keystroke
		jsr 	EXTReadKey
		ora 	#0
		beq 	_IROLWaitKey
		jsr 	IOUpperCase 				; capitalise
		tax 								; save in X
		pla 								; restore old
		phx 								; save new character.		
		jsr	 	IOGetCursorXY 				; get cursor address in XY.
		jsr 	EXTWriteScreen 				; write out.
		pla 								; restore old
		cmp 	#13
		beq 	_IROLExit 					; exit if CR
		jsr 	IOPrintChar 				; print it.
		bra 	_IROLLoop
		;
_IROLExit:
		lda 	#0 							; go to start of line.
		sta 	IOCursorX 	
		ldy 	#0 							; position
_IROLCopy:
		phy 								; save position
		jsr 	IOGetCursorXY 				; get cursor position.			
		jsr 	EXTReadScreen 				; read screen
		ply 								; get position back
		eor 	#$20
		clc
		adc 	#$20
		sta 	(IOLineLo),y 				; save in buffer.
		inc 	IOCursorX 					; cursor right
		iny 								; bump pointer
		cpy 	#EXTWidth 					; not done full line.
		bne 	_IROLCopy
		lda 	#13 						; carriage return
		jsr 	IOPrintChar		
		ldy 	#EXTWidth 					; trim trailing spaces
_IROLTrim:
		dey
		bmi 	_IROLFound
		lda 	(IOLineLo),y
		cmp 	#32
		beq 	_IROLTrim
_IROLFound:
		iny
		lda 	#0 							; make it ASCIIZ
		sta 	(IOLineLo),y				
		ldx 	IOLineLo
		ldy 	IOLineHi
		pla
		rts

; ******************************************************************************
;
;								Print String at XY
;	
; ******************************************************************************

IOPrintString:
		pha
		stx 	IOLineLo
		sty 	IOLineHi
		ldy 	#0
_IOPSLoop:
		lda 	(IOLineLo),y
		beq 	_IOPSExit
		jsr 	IOPrintChar
		iny 
		bra 	_IOPSLoop
_IOPSExit		
		ldx 	IOLineLo
		ldy 	IOLineHi
		pla
		rts
