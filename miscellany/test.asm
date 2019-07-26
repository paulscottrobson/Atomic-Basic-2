		* = 	$0000
		.byte 	0

;
;	0000,1 		Mapping
;	0002,9FFF 	RAM
; 	A000,BFFF 	ROM image
;	C000,CFFF 	RAM
;	D000,DFFF 	Probably I/O mapped here.
;	E000,FFF 	ROM image
;

vwrite 	.macro
		ldz 	#\1
		lda 	#\2
		nop
		sta 	($04),z
.endm
		* = 	$E000						; find out how much leeway.
PETFont:
		.binary "c64-chargen.rom"
		* = 	$D000
		.word 	$D000
		* = 	$C000
		.word 	$C000
		* = 	$B000
		.word 	$B000
		* = 	$A000
		.word 	$A000
		* = 	$9000
		.word 	$9000
		* = 	$8000
		.word 	$8000

		* = 	$F000
Start:	
		lda 	#$02 						; zap all memory.
		sta 	$03
		lda 	#$00
		sta 	$02
Fill1:	ldy 	#$00
Fill2:	tya
		lsr 	a
		lda 	#$AA
		bcc 	Fill3
		lda 	#$55
Fill3:		
		sta 	($02),y
		iny
		bne 	Fill2
		inc 	$03
		lda 	$03
		cmp 	#$D0
		bne 	Fill1
NoFill:

		lda 	#$0F 						; set up to write to video system.
		sta 	$07
		lda 	#$FD
		sta 	$06
		lda 	#$30
		sta 	$05
		lda 	#$00
		sta 	$04

		#vwrite 	$2F,$47
		#vwrite 	$2F,$53

		#vwrite 	$30,$40
		#vwrite 	$31,$40

		lda $d031	; VIC-III Control Register B
		and #$40	; bit-6 is 4mhz
		sta $d031

		#vwrite $20,0 						; black border
		#vwrite $21,0 						; black background

		#vwrite $6F,$80						; 60Mhz mode.


		lda $d066
		and #$7F
		sta $d066

		#vwrite $6A,$00
		#vwrite $6B,$00
		#vwrite $78,$00
		#vwrite $5F,$00
		
		#vwrite $5A,$78
		#vwrite $5D,$C0
		#vwrite $5C,80

		; point VIC-IV to bottom 16KB of display memory
		;
		lda #$ff
		sta $DD01
		sta $DD00

		#vwrite $18,$14
		#vwrite $11,$1B
		#vwrite $16,$C8

		#vwrite $C5,$54

		#vwrite $58,80
		#vwrite $59,0

		#vwrite $18,$42	 					; screen address $0800 video address $2000
		#vwrite $11,$1B

		lda 	#$00						; colour RAM at $1F800-1FFFF (2kb)
		sta 	$0B 						; char RAM appears to be here.
		lda 	#$01
		sta 	$0A
		lda 	#$F8
		sta 	$09
		lda 	#$00
		sta 	$08
		ldz 	#0
SetColorRam:	
		tza
		nop
		sta 	($08),z
		dez
		bne 	SetColorRam
		inc 	$09
		bne 	SetColorRam

Screen = $1000								; 2k screen RAM here

		ldx 	#0
Clear2:
		txa
		and 	#1									; odd bits write zero
		eor 	#1
		beq 	_CL2Write
		txa
		;and 	#2
		lsr 	a
_CL2Write:									
		sta 	Screen,x
		sta 	Screen+$100,x
		sta 	Screen+$200,x
		sta 	Screen+$300,x
		sta 	Screen+$400,x
		sta 	Screen+$500,x
		sta 	Screen+$600,x
		sta 	Screen+$700,x
		inx
		bne 	Clear2

CSet = $800

		ldx 	#0
CopyPetFont:
		lda 	PETFont,x
		sta 	CSet,x
		lda 	PETFont+$100,x
		sta 	CSet+$100,x
		lda 	PETFont+$200,x
		sta 	CSet+$200,x
		lda 	PETFont+$300,x
		sta 	CSet+$300,x
		dex
		bne 	CopyPetFont

		lda 	#$36
		sta 	$05
		lda 	#$10
		sta 	$04

Halt:	ldz 	#0
		nop
		lda		($04),z
		beq 	Halt
		pha
		lsr 	a
		lsr 	a
		lsr 	a
		lsr 	a
		jsr 	ToHex
		sta 	Screen+2
		pla
		jsr 	ToHex
		sta 	Screen+4
		nop
		sta 	($04),z

		bra 	Halt

Dummy:	rti

ToHex:	and 	#15
		cmp 	#10
		bcc 	_IsDigit
		sbc 	#48+9
_IsDigit:		
		adc 	#48
		rts
		rts

		* = 	$FFFA
		.word 	Dummy
		.word 	Start		
		.word 	Dummy
