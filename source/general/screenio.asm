; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		screenio.asm
;		Purpose :	Screen I/O functions, that use the personality code.
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Initialise, Clear Home, and Home routines
;
; *******************************************************************************************

SIOInitialise:
		jsr 	EXTReset 					; reset video
SIOClearScreen:		
		jsr 	EXTClearScreen 				; clear screen
SIOHomeCursor:
		pha 								; home cursor
		lda 	#0
		sta 	xCursor
		sta 	yCursor
		pla
		rts

; *******************************************************************************************
;
;								 Print ASCIIZ string at XY
;
; *******************************************************************************************

SIOPrintString:
		pha 								; save registers
		phx
		phy
		stx 	zTemp1 						; set up indirect pointer
		sty 	zTemp1+1
		ldy 	#0 
_SIOPSLoop:
		lda 	(zTemp1),y 					; read next, exit if 0
		beq 	_SIOPSExit
		jsr 	SIOPrintCharacter 			; print and bump
		iny
		bra 	_SIOPSLoop
_SIOPSExit:
		ply 								; restore and exit.
		plx
		pla
		rts


; *******************************************************************************************
;
;						  Print a single character out (characters and CR)
;
; *******************************************************************************************

SIOPrintCharacter:
		pha 								; save AXY
		phx
		phy
		cmp 	#13 						; CR ?
		beq 	_SIOPReturn
		jsr 	SIOLoadCursor 				; load cursor position in.
		and 	#$3F 						; PETSCII conversion
		jsr 	EXTWriteScreen 				; write character out.
		inc 	xCursor 					; move right
		lda 	xCursor 					; reached the RHS
		cmp 	#EXTWidth
		bcc 	_SIOPExit
_SIOPReturn:
		lda 	#0 							; zero x
		sta 	xCursor
		inc 	yCursor 					; go down
		lda 	yCursor
		cmp 	#EXTHeight 					; off the bottom ?
		bcc 	_SIOPExit
		jsr 	EXTScrollDisplay 			; scroll display up
		dec 	yCursor 					; cursor on bottom line.
_SIOPExit:		
		ply 								; restore and exit.
		plx
		pla
		rts

; *******************************************************************************************
;
;										Get a single key
;
; *******************************************************************************************

SIOGetKey:
		jsr 	EXTReadKeyPort 				; wait for a key
		beq 	SIOGetKey
		jsr 	EVALToUpper 				; capitalise it.
		jmp 	EXTRemoveKeyPressed 		; remove from the queue.

; *******************************************************************************************
;
;										Read line.
;
; *******************************************************************************************

SIOReadLine:
		pha 								; save registers
		phx
		phy
_SIORLoop:		
		jsr 	SIOLoadCursor 				; cursor in XY
		jsr 	EXTReadScreen 				; read the display.
		pha 								; save on stack.
		lda 	#102 						; write cursor out
		jsr 	EXTWriteScreen
		jsr 	SIOGetKey
		tax 								; save in X
		pla 								; old character
		phx 								; save key pressed
		jsr 	SIOLoadCursor 				; cursor in XY
		jsr 	EXTWriteScreen
		;
		pla
		cmp 	#"A"-64 					; control characters
		beq 	_SIOCursorLeft
		cmp 	#"S"-64 					
		beq 	_SIOCursorDown
		cmp 	#"D"-64 					
		beq 	_SIOCursorRight
		cmp 	#"W"-64 					
		beq 	_SIOCursorUp
		cmp 	#"Z"-64						 					
		beq 	_SIOClearScreen
		cmp 	#"H"-64
		beq 	_SIOBackspace
		cmp 	#13 						; CR
		beq 	_SIOGoReturn
		cmp 	#32 						; any control
		bcc 	_SIORLoop		
		pha
		jsr 	_SIOInsert 					; insert a space for new character
		pla
		jsr 	SIOPrintCharacter 			; print character in A
		bra 	_SIORLoop
_SIOGoReturn:
		jmp 	_SIOReturn		
		;
_SIOCursorLeft:								; cursor movement
		dec 	xCursor
		bpl 	_SIORLoop
		lda 	#EXTWidth-1
_SIOWXLoop:		
		sta 	xCursor
		bra 	_SIORLoop
_SIOCursorRight:
		inc 	xCursor
		lda 	xCursor
		eor 	#EXTWidth
		bne 	_SIORLoop
		bra 	_SIOWXLoop				
		;
_SIOCursorUp:
		dec 	yCursor
		bpl 	_SIORLoop
		lda 	#EXTHeight-1
_SIOWYLoop:		
		sta 	yCursor
		bra 	_SIORLoop
_SIOCursorDown:
		inc 	yCursor
		lda 	yCursor
		eor 	#EXTHeight
		bne 	_SIORLoop
		bra 	_SIOWYLoop				
		;
_SIOClearScreen: 							; handle clear screen
		jsr 	SIOClearScreen
		bra 	_SIORLoop		
		;
_SIOBackspace:
		lda 	xCursor 					; backspace possible ?
		beq 	_SIORLoop 					; start of line, no.
		pha 								; save position.
		cmp 	#EXTWidth-1 				; not required
		beq 	_SIONoShift
_SIOShift2:
		inc 	xCursor 					; copy character backward
		jsr 	SIOLoadCursor
		jsr 	EXTReadScreen
		dec 	xCursor
		jsr 	SIOLoadCursor
		jsr 	EXTWriteScreen
		inc 	xCursor
		lda 	xCursor
		cmp 	#EXTWidth-1
		bne 	_SIOShift2
_SIONoShift:
		lda 	#EXTWidth-1 				; space on far end.
		jsr 	SIOLoadCursor
		lda 	#32
		jsr 	EXTWriteScreen
		pla 								; restore cursor, back one.
		dec 	a
		sta 	xCursor
		jsr 	SIOLoadCursor 				; overwrite
		lda 	#32
		jsr 	EXTWriteScreen
		jmp	 	_SIORLoop		
		;
		;		Inserts a space on current line.
		;
_SIOInsert:
		lda 	xCursor 					; at far right, nothing to do.
		cmp 	#EXTWidth-1
		beq 	_SIOIExit
		sta 	zTemp2 						; save in temporary workspace.
		lda 	#EXTWidth-1 				; cursor at far right.
		sta 	xCursor
_SIOShift:
		dec 	xCursor 					; copy character forward
		jsr 	SIOLoadCursor
		jsr 	EXTReadScreen
		inc 	xCursor
		jsr 	SIOLoadCursor
		jsr 	EXTWriteScreen
		dec 	xCursor
		lda 	xCursor						; until shifted line to this point.
		cmp 	zTemp2
		bne 	_SIOShift
_SIOIExit:
		rts
		;
		;		Handle Return.
		;
_SIOReturn:
		lda 	#0 							; copy line in from screen.
		sta 	xCursor
_SIOCopy:
		jsr 	SIOLoadCursor		
		jsr 	EXTReadScreen
		eor 	#$20
		clc 
		adc 	#$20
		ldx 	xCursor
		sta 	InputLine,x
		inc 	xCursor
		lda 	xCursor
		cmp 	#EXTWidth
		bne 	_SIOCopy
		tax 								; X contains width
_SIOStrip:
		dex									; back one
		bmi		_SIOFound 					; if -ve gone too far
		lda 	InputLine,x 				; is there a space here
		cmp 	#' '
		beq 	_SIOStrip
_SIOFound:
		inx
		lda 	#0 							; make ASCIIZ
		sta 	InputLine,x		
		lda 	#13 						; print a CR and exit
		jsr 	SIOPrintCharacter
		ply
		plx
		pla
		rts

; *******************************************************************************************
;
;								Load Cursor position into XY
;
; *******************************************************************************************

SIOLoadCursor:
		pha 			
		lda 	yCursor  					; Y Position
		asl 	a 							; x 2 	(80)
		asl 	a 							; x 2 	(160)
		adc 	yCursor 					; x 5 	(200) (CC)
		sta 	zTemp1 						
		lda 	#0
		sta 	zTemp1+1
		asl 	zTemp1						; x 10
		rol 	zTemp1+1
		asl 	zTemp1						; x 20
		rol 	zTemp1+1
		asl 	zTemp1						; x 40
		rol 	zTemp1+1 					; (CC)
		lda 	zTemp1 						; add X
		adc 	xCursor
		tax
		lda 	zTemp1+1
		adc 	#0
		tay
		pla 								; restore and exit
		rts
