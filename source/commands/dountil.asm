; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		dountil.asm
;		Purpose :	Do..Until commands
;		Date :		29th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;	
;								DO (top of loop)
;
; *******************************************************************************************

COMMAND_Do: 	;; do
		lda 	#KW_DO						; push position with a DO token.
		jsr 	CDOPushPosOnStack
		rts

; *******************************************************************************************
;	
;								UNTIL (bottom of loop)
;
; *******************************************************************************************

COMMAND_Until:	;; until
		lda 	#KW_DO 						; check TOS is a Do.
		jsr 	CDOCheckTopStack
		ldx 	#0 							; evaluate the test
		jsr 	EvaluateBase
		lda 	evalStack+0,x 				; check if zero
		ora 	evalStack+1,x
		ora 	evalStack+2,x
		ora 	evalStack+3,x
		beq 	CDOPullPosOffStack 			; zero, restore the position.
		bra 	CDOThrowPosOffStack			; non-zero chuck it.

; *******************************************************************************************
;
;			Push current position on stack, together with a structure code.
;
; *******************************************************************************************

CDOPushPosOnStack:
		ldx 	basicStackIndex
		pha
		tya
		sta 	BasicStack+1,x 				; +1 	Y Position
		lda 	zCurrentLine
		sta 	BasicStack+2,x 				; +2 	low of pos
		lda 	zCurrentLine+1
		sta 	BasicStack+3,x 				; +3 	high of pos
		pla 						
		sta 	BasicStack+4,x 				; +4 	token on stack
		inx
		inx
		inx
		inx 								; always points to TOS.
		stx 	basicStackIndex
		;
		rts

; *******************************************************************************************
;
;									Throw a saved position
;
; *******************************************************************************************

CDOThrowPosOffStack:
		lda 	basicStackIndex
		sec
		sbc 	#4
		sta 	basicStackIndex
		rts

; *******************************************************************************************
;
;							Restore a saved position - don't lose it.
;
; *******************************************************************************************

CDOPullPosOffStack:
		ldx 	basicStackIndex
		dex 
		dex 
		dex 
		dex 
		lda 	BasicStack+1,x 					; get position back.
		tay
		lda 	BasicStack+2,x
		sta 	zCurrentLine
		lda 	BasicStack+3,x
		sta 	zCurrentLine+1
		rts

; *******************************************************************************************
;
;									Check topmost element is A
;
; *******************************************************************************************

CDOCheckTopStack:
		ldx 	basicStackIndex 			; if match
		cmp 	BasicStack+0,x 
		bne 	_CDOCTSError
		rts
_CDOCTSError:
		#error 	"STRUCTURE MIXED"		
