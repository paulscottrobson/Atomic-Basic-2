; ******************************************************************************
; ******************************************************************************
;
;		Name: 		personality_6502.asm
;		Purpose:	Personality Code for Development Platform.
;		Date: 		26th July 2019
;		Author:		Paul Robson
;
; ******************************************************************************
; ******************************************************************************

	* = 	$C000 							; 16k ROM from $C000-$FFFF

; ******************************************************************************
;
;								Constants
;
; ******************************************************************************

EXTWidth = 40 								; screen width
EXTHeight = 25 								; screen height

; ******************************************************************************
;
;							Memory Allocation
;
; ******************************************************************************

EXTLowMemory = $0800 						; Workspace RAM starts here
EXTHighMemory = $6000 						; Workspace RAM ends here

PScreen = $B000								; 1k screen RAM here
PKeyboard = $B800							; Keyboard port.

; ******************************************************************************
;
;			Macro which resets the 65x02 stack to its default value.
;
; ******************************************************************************

EXTResetStack: .macro
	ldx 	#$FF 							; reset 6502 stack.
	txs
	.endm

; ******************************************************************************
;
;		Set up code. Initialise everything except the video code (done
;		by ExtReset. Puts in Dummy NMI,IRQ and Reset vectors is required
;		Code will start assembly after this point via "jmp Start"
;
; ******************************************************************************

EXTStartPersonalise:	
	#EXTResetStack							; reset stack
	jsr 	EXTReset 						; reset video
	jsr 	EXTClearScreen 					; clear screen
	jmp 	Start 							; start main application

; ******************************************************************************
;
;		Read a key from the keyboard buffer, or whatever. This should return
;		non-zero values once for every key press (e.g. a successful read
;		removes the key from the input Queue)
;
; ******************************************************************************

EXTReadKey:
	lda 	PKeyboard							; read key
	beq 	_EXTExit
	pha 										; key pressed clear queue byte.
	lda 	#0
	sta 	PKeyboard
	pla
_EXTExit:	
	rts

; ******************************************************************************
;
;		Read a byte from the screen (C64 codes, e.g. @ = 0) at XY -> A
;
; ******************************************************************************

EXTReadScreen:
	phy 										; save Y
	stx 	EXTZPWork							; into EXTZPWork
	tya
	ora 	#PScreen>>8 						; move into screen area
	sta 	EXTZPWork+1 						; read character there
	ldy 	#0
	lda 	(EXTZPWork),y
	ply 										; restore Y and exit.
	rts

; ******************************************************************************
;
;	   Write a byte A to the screen (C64 codes, e.g. @ = 0) at XY 
;
; ******************************************************************************

EXTWriteScreen:
	phy
	pha
	jsr		EXTReadScreen 						; set up the address into EXTZPWork
	ldy 	#0
	pla 										; restore and write.
	sta 	(EXTZPWork),y
	ply
	rts

; ******************************************************************************
;
;								Clear the screen
;
; ******************************************************************************

EXTClearScreen:
	pha 										; save registers
	phx
	ldx 	#0
_EXTCSLoop:
	lda 	#32
	sta 	PScreen+0,x
	sta 	PScreen+$100,x
	sta 	PScreen+$200,x
	sta 	PScreen+$300,x
	inx	
	bne 	_EXTCSLoop
	plx 										; restore
	pla
	rts

; ******************************************************************************
;
;					Scroll the whole display up one line.
;
; ******************************************************************************

EXTScrollDisplay:
	pha 										; save registers
	phy
	lda 	#PScreen & $FF 					; set pointer to screen
	sta 	EXTZPWork+0
	lda 	#PScreen >> 8
	sta 	EXTZPWork+1
_EXTScroll:	
	ldy 	#EXTWidth
	lda 	(EXTZPWork),y
	ldy 	#0
	sta 	(EXTZPWork),y
	inc 	EXTZPWork 							; bump address
	bne 	_EXTNoCarry
	inc 	EXTZPWork+1
_EXTNoCarry:
	lda 	EXTZPWork 							; done ?
	cmp	 	#(PScreen+EXTWidth*(EXTHeight-1)) & $FF
	bne 	_EXTScroll
	lda 	EXTZPWork+1
	cmp	 	#(PScreen+EXTWidth*(EXTHeight-1)) >> 8
	bne 	_EXTScroll
	;
	ldy 	#0									; clear bottom line.
_EXTLastLine:
	lda 	#32
	sta 	(EXTZPWork),y
	iny
	cpy 	#EXTWidth
	bne 	_EXTLastLine	
	ply 										; restore and exit.
	pla
	rts	

; ******************************************************************************
;
;						 Reset the Display System
;
; ******************************************************************************

EXTReset:
	rts

