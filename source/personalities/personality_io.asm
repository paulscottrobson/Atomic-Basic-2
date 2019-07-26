; ******************************************************************************
; ******************************************************************************
;
;		Name: 		personality_io.asm
;		Purpose:	Personality Common I/O Routines
;		Date: 		26th July 2019
;		Author:		Paul Robson
;
; ******************************************************************************
; ******************************************************************************


; ******************************************************************************
;
;						Initialise the I/O System
;
; ******************************************************************************

IOInitialise:
		jsr 	EXTReset 					; reset display.
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

		and 	#$7F 						; bits 0-6 only
		jsr 	IOUpperCase 				; convert to upper case.
		cmp 	#13 						; new line ?
		beq 	_IOPCNewLine
		cmp 	#32 						; not printable.
		bcc 	_IOPCExit
		pha 								; print at cursor
		jsr 	IOGetCursorXY		
		pla
		and 	#$3F 						; 6 Bit ASCII
		jsr 	EXTWriteScreen
		inc 	IOCursorX 					; move left.
		lda 	IOCursorX
		cmp		#EXTWidth 					; will be zero if at RHS
		bne 	_IOPCExit 					; exit otherwise
_IOPCNewLine:
		lda 	#0 							; go down and to lhs
		sta 	IOCursorX
		inc 	IOCursorY
		lda 	IOCursorY 					; off bottom
		cmp 	#EXTHeight
		bcc 	_IOPCExit
		jsr 	EXTScrollDisplay 			; scroll
		dec 	IOCursorY 					; fix up.
_IOPCExit:
		ply
		plx
		pla
		rts

; ******************************************************************************
;
;							Read key with cursor
;
; ******************************************************************************

IOReadKey:
		phx 								; save XY
		phy
		jsr 	IOGetCursorXY 				; show prompt
		lda 	#$1D
		jsr  	EXTWriteScreen
_IORKWait:									; wait for key press
		jsr 	EXTReadKey
		beq 	_IORKWait
		pha 								; clear prompt
		jsr 	IOGetCursorXY
		lda 	#" "
		jsr  	EXTWriteScreen
		pla
		ply 								; restore and exit.
		plx
		rts

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


