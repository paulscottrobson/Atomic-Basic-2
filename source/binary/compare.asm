; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		compare.asm
;		Purpose :	Number Comparison
;		Date :		26th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;	
;					Equals: In pairs, so CC accept result, CS invert it.
;
; *******************************************************************************************

BFUNC_Equals:		;; 	=
		clc
		bra 	BFUNC_EqualCheck
BFUNC_NotEquals:	;; <>		
		sec
BFUNC_EqualCheck:
		php									; save invert flag
		lda 	evalStack+0 				; check equality
		cmp 	evalStack+4
		bne 	COMP_Fail
		lda 	evalStack+1
		cmp 	evalStack+5
		bne 	COMP_Fail
		lda 	evalStack+2
		cmp 	evalStack+6
		bne 	COMP_Fail
		lda 	evalStack+3
		cmp 	evalStack+7
		bne 	COMP_Fail
;
COMP_Succeed: 								; here return -1
		lda 	#$FF
		bra 	COMP_SetResult
COMP_Fail:
		lda 	#0 							; here return 0
COMP_SetResult:
		plp 								; but if CS
		bcc 	COMP_Accept
		eor 	#$FF 						; invert that
COMP_Accept:
		sta 	evalStack+0,x 				; write to result.
		sta 	evalStack+1,x
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		rts				

; *******************************************************************************************
;	
;					Less Than : In pairs, so CC accept result, CS invert it.
;
; *******************************************************************************************

BFUNC_Less:			;; 	<
		clc
		bra 	BFUNC_LessCheck
BFUNC_GreaterEqual:	;; >= 
		sec
BFUNC_LessCheck:
		php
		sec
		lda 	evalStack+0 				; compare using direct subtraction
		sbc 	evalStack+4
		lda 	evalStack+1
		sbc 	evalStack+5
		lda 	evalStack+2
		sbc 	evalStack+6
		lda 	evalStack+3
		sbc 	evalStack+7
		bmi 	COMP_Succeed
		bra 	COMP_Fail

; *******************************************************************************************
;	
;					Less Than : In pairs, so CC accept result, CS invert it.
;
; *******************************************************************************************

BFUNC_Greater:		;; 	>
		clc
		bra 	BFUNC_GreaterCheck
BFUNC_LessEqual:	;; <= 
		sec
BFUNC_GreaterCheck:
		php
		sec	
		lda 	evalStack+4 				; compare using direct subtraction
		sbc 	evalStack+0
		lda 	evalStack+5
		sbc 	evalStack+1
		lda 	evalStack+6
		sbc 	evalStack+2
		lda 	evalStack+7
		sbc 	evalStack+3
		bmi 	COMP_Succeed
		bra 	COMP_Fail



