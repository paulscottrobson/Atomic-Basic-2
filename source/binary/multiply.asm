; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		multiply.asm
;		Purpose :	Multiply +4 into +0
;		Date :		26th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									Multiply +4 into +0
;
; *******************************************************************************************

BFUNC_Multiply:		;; *
		lda 	evalStack+0,x				; copy +0 to +8
		sta 	evalStack+8,x
		lda 	evalStack+1,x			
		sta 	evalStack+9,x
		lda 	evalStack+2,x			
		sta 	evalStack+10,x
		lda 	evalStack+3,x			
		sta 	evalStack+11,x
		;
		lda 	#0
		sta 	evalStack+0,x 				; zero +0
		sta 	evalStack+1,x
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		;
_BFMMultiply:
		lda 	evalStack+8,x 				; get LSBit of 8-11
		and 	#1
		beq 	_BFMNoAdd
		jsr 	BFunc_Add 					; if bit set, add 4 to 0.
_BFMNoAdd:
		;
		asl 	evalStack+4,x 				; shift +4 left
		rol 	evalStack+5,x
		rol 	evalStack+6,x
		rol 	evalStack+7,x
		;
		lsr 	evalStack+11,x 				; shift +8 right
		ror 	evalStack+10,x
		ror 	evalStack+9,x
		ror 	evalStack+8,x
		;
		lda 	evalStack+8,x 				; continue if +8 is nonzero
		ora 	evalStack+9,x
		ora 	evalStack+10,x
		ora 	evalStack+11,x
		bne 	_BFMMultiply
		;
		rts

