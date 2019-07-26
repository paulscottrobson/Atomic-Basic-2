; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		binary.asm
;		Purpose :	Binary Logical functions
;		Date :		26th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;										And +4 into +0
;
; *******************************************************************************************

BFUNC_And:	;; 	&
		lda 	evalStack+0,x
		and 	evalStack+4,x
		sta 	evalStack+0,x	
		lda 	evalStack+1,x
		and 	evalStack+5,x
		sta 	evalStack+1,x	
		lda 	evalStack+2,x
		and 	evalStack+6,x
		sta 	evalStack+2,x	
		lda 	evalStack+3,x
		and 	evalStack+7,x
		sta 	evalStack+3,x	
		rts

; *******************************************************************************************
;
;										Or +4 into +0
;
; *******************************************************************************************

BFUNC_Or:	;; 	|
		lda 	evalStack+0,x
		ora 	evalStack+4,x
		sta 	evalStack+0,x	
		lda 	evalStack+1,x
		ora 	evalStack+5,x
		sta 	evalStack+1,x	
		lda 	evalStack+2,x
		ora 	evalStack+6,x
		sta 	evalStack+2,x	
		lda 	evalStack+3,x
		ora 	evalStack+7,x
		sta 	evalStack+3,x	
		rts

; *******************************************************************************************
;
;										Xor +4 into +0
;
; *******************************************************************************************

BFUNC_Xor:	;; 	^
		lda 	evalStack+0,x
		eor 	evalStack+4,x
		sta 	evalStack+0,x	
		lda 	evalStack+1,x
		eor 	evalStack+5,x
		sta 	evalStack+1,x	
		lda 	evalStack+2,x
		eor 	evalStack+6,x
		sta 	evalStack+2,x	
		lda 	evalStack+3,x
		eor 	evalStack+7,x
		sta 	evalStack+3,x	
		rts

