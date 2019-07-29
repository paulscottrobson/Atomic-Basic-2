; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		unary.asm
;		Purpose :	Simple Unary Functions
;		Date :		27th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;										LEN(string)
;
; *******************************************************************************************

UNARY_Len: 	;; len
		jsr 	EvaluateAtomCurrentLevel 	; get the string to measure the length of.
		lda 	evalStack+0,x 				; copy string address to zTemp1
		sta 	zTemp1
		lda 	evalStack+1,x
		sta 	zTemp1+1
		phy
		ldy 	#0 							; now figure out its length.

_ULGetLength:
		lda 	(zTemp1),y 					; read character
		beq 	_ULFoundEOL 				; found end of line.
		iny
		bne 	_ULGetLength 				; scan 256 only.
		#error	"CANNOT FIND STRING END"
		;
_ULFoundEOL:
		tya 								; length in A, restore Y
		ply
UNARY_ReturnByte:		
		sta 	evalStack+0,x
		lda 	#0 							; clear the rests
		sta 	evalStack+1,x				
		sta 	evalStack+2,x				
		sta 	evalStack+3,x				
		rts

; *******************************************************************************************
;
;									CH(string) - character code
;
; *******************************************************************************************

UNARY_Ch: 	;; ch
		jsr 	EvaluateAtomCurrentLevel 	; get the string to measure the length of.
		lda 	evalStack+0,x 				; copy string address to zTemp1
		sta 	zTemp1
		lda 	evalStack+1,x
		sta 	zTemp1+1
		phy
		ldy 	#0 							; now get first character
		lda 	(zTemp1),y
		ply
		bra 	UNARY_ReturnByte 			; return that byte.

; *******************************************************************************************
;
;									ABS(int) - absolute value
;
; *******************************************************************************************

UNARY_Abs: 	;; abs
		#break
		jsr 	EvaluateAtomCurrentLevel 	; get the string to measure the length of.
		jsr 	BFUNC_Negate 				; there's an ABS routine in divide
		rts

; *******************************************************************************************
;
;									TOP - current High Memory
;
; *******************************************************************************************

UNARY_Top: 	;; top
		lda 	highMemory
		sta 	evalStack+0,x
		lda 	highMemory+1
		sta 	evalStack+1,x				
		lda 	#0
		sta 	evalStack+2,x				
		sta 	evalStack+3,x				
		rts

; *******************************************************************************************
;
;									RND - 32 bit random
;
; *******************************************************************************************

UNARY_Rnd: 	;; rnd
		jsr 	Random16 					; call 16 bit RNG twice
		inx
		inx
		jsr 	Random16
		dex
		dex
		rts

Random16:
		lda 	RandomSeed 					; initialise if nonzero
		ora 	RandomSeed+1
		bne 	_R16_NoInit
		inc 	RandomSeed 					; by setting low to 1
		phy
		ldy 	#20 						; call it 20 times to get it started
_R16_Setup:		
		jsr 	Random16
		dey
		bne 	_R16_Setup
		ply
_R16_NoInit:
		lsr 	RandomSeed+1				; shift seed right
		ror 	RandomSeed
		bcc 	_R16_NoXor
		lda 	RandomSeed+1				; xor MSB with $B4 if bit set.
		eor 	#$B4 						; like the Wikipedia one.
		sta 	RandomSeed+1
_R16_NoXor:				
		lda 	RandomSeed					; copy result to evaluate stack.
		sta 	evalStack+0,x
		lda 	RandomSeed+1
		sta 	evalStack+1,x
		rts