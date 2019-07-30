; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		if.asm
;		Purpose :	Print Statement
;		Date :		30th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;							IF <expr> [THEN] commands <[ELSE] commands>
;
; *******************************************************************************************

COMMAND_IF:		;; if
		ldx 	#0 							; do test
		jsr 	EvaluateBase
		lda 	evalStack+0 				; check if test 0
		ora 	evalStack+1
		ora 	evalStack+2
		ora 	evalStack+3
		beq 	_CIFSkip 					; if not, then skip to ELSE token or EOL.
		;	
_CIFExit:		
		rts
		;
_CIFSkip:
		lda 	(zCurrentLine),y 			; found EOL ?
		beq 	_CIFExit				
		iny 								; is it ELSE
		cmp 	#KW_ELSE
		bne 	_CIFSkip 					; no, keep going
		rts

; *******************************************************************************************
;
;						THEN is mostly syntactic, but allows THEN 40
;
; *******************************************************************************************

COMMAND_THEN:	;; then  					
		lda 	(zCurrentLine),y 			; find first non space
		iny 
		cmp 	#" "
		beq 	COMMAND_THEN
		dey
		cmp 	#"0" 						; THEN x is THEN GOTO x
		bcc 	_CTHNoBranch
		cmp 	#"9"+1
		bcs 	_CTHNoBranch
		jmp 	Command_GOTO 				; so do the GOTO code.
_CTHNoBranch:		
		rts

; *******************************************************************************************
;
;								ELSE skips to end of line.
;
; *******************************************************************************************

COMMAND_ELSE:	;; else
		lda 	(zCurrentLine),y
		iny
		cmp 	#0
		bne 	COMMAND_ELSE
		dey
		rts
