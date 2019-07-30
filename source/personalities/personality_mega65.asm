; ******************************************************************************
; ******************************************************************************
;
;		Name: 		personality_mega65.asm
;		Purpose:	Mega65 Personality Code
;		Date: 		26th July 2019
;		Author:		Paul Robson
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								Constants
;
; ******************************************************************************

EXTWidth = 80 								; screen width
EXTHeight = 25 								; screen height

; ******************************************************************************
;
;							Memory Allocation
;
; ******************************************************************************

EXTLowMemory = $2000 						; Workspace RAM starts here
EXTHighMemory = $8000 						; Workspace RAM ends here

EXTScreen = $1000							; 2k screen RAM here
EXTCharSet = $800							; 2k character set (0-7F) here

; ******************************************************************************
;
;				Initialisation, Vector Tables, Character Set
;
; ******************************************************************************

	* = 0
	.word 	0 								; forces it to be a 64k ROM (at least)

	* = 	$A000							; put the font at $A000
EXTCBMFont:
	.binary "c64-chargen.rom"

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
;				Read the key in the queue, remove the key pressed.
;
; ******************************************************************************

KeyMap:	.macro
	cmp 	#\1
	bne 	_KMNo
	lda 	#\2
_KMNo:
	.endm
		
EXTReadKeyPort:
	phz
	jsr 	EXTSetupKeyAddress
	nop 									; read keyboard
	lda 	(EXTZPWork),z 
	plz
	keymap 	20,"H"-64
	keymap 	145,"W"-64
	keymap 	17,"S"-64
	keymap	157,"A"-64
	keymap	29,"D"-64
	cmp 	#0 								; set Z
	rts

EXTRemoveKeyPressed:
	pha
	phz
	jsr 	EXTSetupKeyAddress
	lda 	#0
	nop 									; read keyboard
	sta 	(EXTZPWork),z 
	plz
	pla
	rts

EXTSetupKeyAddress:
	lda 	#$0F 							; set up to write to read keyboard.
	sta 	EXTZPWork+3
	lda 	#$FD
	sta 	EXTZPWork+2
	lda 	#$36
	sta 	EXTZPWork+1
	lda 	#$10
	sta 	EXTZPWork+0	
	ldz 	#0 			
	rts

; ******************************************************************************
;
;								Break Test
;
; ******************************************************************************
		
EXTCheckBreak:
	phz
	jsr 	EXTSetupKeyAddress 				; point to keyboard
	inc 	EXTZPWork 						; point to modifiers.
	nop 									; read modifiers.
	lda 	(EXTZPWork),z
	plz 									; restore Z
	and 	#5								; break is LeftShift+Ctrl
	cmp 	#5 		
	beq 	_EXTCBYes
	lda 	#0
	rts
_EXTCBYes:
	lda 	#1
	rts	

; ******************************************************************************
;
;		Read a byte from the screen (C64 codes, e.g. @ = 0) at XY -> A
;
; ******************************************************************************

EXTReadScreen:
	phy 										; save Y
	txa 										; multiply XY by 2
	sta 	EXTZPWork							; into EXTZPWork
	tya
	ora 	#EXTScreen>>8 						; move into screen area
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
	phy
	lda 	#EXTScreen & $FF 					; set up pointer
	sta 	EXTZPWork
	lda 	#EXTScreen >> 8
	sta 	EXTZPWork+1
	ldy 	#0
_EXTCSLoop:
	lda 	#32	
	sta 	(EXTZPWork),y
	iny
	bne 	_EXTCSLoop
	inc 	EXTZPWork+1 						; next screen page	
	lda 	EXTZPWork+1
	cmp 	#(EXTScreen>>8)+8 					; done 2k ?
	bne 	_EXTCSLoop
	ply 										; restore
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
	lda 	#EXTScreen & $FF 					; set pointer to screen
	sta 	EXTZPWork+0
	lda 	#EXTScreen >> 8
	sta 	EXTZPWork+1
_EXTScroll:	
	ldy 	#EXTWidth 							; x 2 because of two byte format.
	lda 	(EXTZPWork),y
	ldy 	#0
	sta 	(EXTZPWork),y
	inc 	EXTZPWork 							; bump address
	bne 	_EXTNoCarry
	inc 	EXTZPWork+1
_EXTNoCarry:
	lda 	EXTZPWork 							; done ?
	cmp	 	#(EXTScreen+EXTWidth*(EXTHeight-1)) & $FF
	bne 	_EXTScroll
	lda 	EXTZPWork+1
	cmp	 	#(EXTScreen+EXTWidth*(EXTHeight-1)) >> 8
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

EXTWrite 	.macro 							; write to register using
	ldz 	#\1 							; address already set up
	lda 	#\2
	nop
	sta 	(EXTZPWork),z
.endm

EXTReset:
	pha 									; save registers
	phx
	phy
	lda 	#$0F 							; set up to write to video system.
	sta 	EXTZPWork+3
	lda 	#$FD
	sta 	EXTZPWork+2
	lda 	#$30
	sta 	EXTZPWork+1
	lda 	#$00
	sta 	EXTZPWork+0

	#EXTWrite 	$2F,$A5 					; switch to VIC-III mode
	#EXTWrite 	$2F,$96	

	#EXTWrite 	$30,$40						; C65 Charset 					
	#EXTWrite 	$31,$80 					; 80 column mode

	#EXTWrite $20,0 						; black border
	#EXTWrite $21,0 						; black background

	; point VIC-IV to bottom 16KB of display memory

	#EXTWrite $01,$FF
	#EXTWrite $00,$FF

	#EXTWrite $16,$C8 					; 40 column mode

	#EXTWrite $18,$42	 				; screen address $0800 video address $1000
	#EXTWrite $11,$18 					; check up what this means

ClearColourRAM:
	lda 	#$00							; colour RAM at $1F800-1FFFF (2kb)
	sta 	EXTZPWork+3 
	lda 	#$01
	sta 	EXTZPWork+2
	lda 	#$F8
	sta 	EXTZPWork+1
	lda 	#$00
	sta 	EXTZPWork+0
	ldz 	#0
_EXTClearColorRam:	
	lda 	#3 								; fill that with this colour.
	nop
	sta 	(EXTZPWork),z
	dez
	bne 	_EXTClearColorRam
	inc 	EXTZPWork+1
	bne 	_EXTClearColorRam

	ldx 	#0 								; copy PET Font into memory.
_EXTCopyCBMFont:
	lda 	EXTCBMFont+$800,x 				; +$800 uses the lower case c/set
	sta 	EXTCharSet,x
	lda 	EXTCBMFont+$100,x
	sta 	EXTCharSet+$100,x
	lda 	EXTCBMFont+$200,x
	sta 	EXTCharSet+$200,x
	lda 	EXTCBMFont+$300,x
	sta 	EXTCharSet+$300,x
	dex
	bne 	_EXTCopyCBMFont
	ply 									; restore and exit.
	plx
	pla
	rts
