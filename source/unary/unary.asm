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
		#error	"Cannot find string end"
		;
_ULFoundEOL:
		tya 								; length in A, restore Y
		ply
		sta 	evalStack+0,x
		lda 	#0 							; clear the rests
		sta 	evalStack+1,x				
		sta 	evalStack+2,x				
		sta 	evalStack+3,x				
		rts