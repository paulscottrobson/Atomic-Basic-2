; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		arithmetic.asm
;		Purpose :	Binary Arithmetic functions
;		Date :		26th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;										Add +4 to +0
;
; *******************************************************************************************

BFUNC_Add:	;; 	+
		clc
		lda 	evalStack+0,x
		adc 	evalStack+4,x
		sta 	evalStack+0,x	
		lda 	evalStack+1,x
		adc 	evalStack+5,x
		sta 	evalStack+1,x	
		lda 	evalStack+2,x
		adc 	evalStack+6,x
		sta 	evalStack+2,x	
		lda 	evalStack+3,x
		adc 	evalStack+7,x
		sta 	evalStack+3,x			
		rts

; *******************************************************************************************
;
;									  Subtract +4 from +0
;
; *******************************************************************************************

BFUNC_Subtract:	;; 	-
		sec
		lda 	evalStack+0,x
		sbc 	evalStack+4,x
		sta 	evalStack+0,x	
		lda 	evalStack+1,x
		sbc 	evalStack+5,x
		sta 	evalStack+1,x	
		lda 	evalStack+2,x
		sbc 	evalStack+6,x
		sta 	evalStack+2,x	
		lda 	evalStack+3,x
		sbc 	evalStack+7,x
		sta 	evalStack+3,x			
		rts

; *******************************************************************************************
;
;									  	Indirect Reads
;
; *******************************************************************************************
				
BFUNC_String: ;; 	$
		jsr 	BFUNC_Add
		rts

BFUNC_ByteInd: ;; 	?
		jsr 	BFUNC_Add
		jsr 	EVALReadByteIndirect
		rts
				
BFUNC_WordInd: ;; 	!
		jsr 	BFUNC_Add
		jsr 	EVALReadWordIndirect
		rts
