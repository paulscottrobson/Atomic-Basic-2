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
;								GOTO <line number>
;
; *******************************************************************************************

COMMAND_Goto: 	;; goto
		ldx 	#0 							; evaluate the linenumber
		jsr 	EvaluateBase
CMDGoto:		
		jsr 	FindProgramLine 			; find that program Line, put in zTargetAddr
		lda 	zTargetAddr 				; new line
		sta 	zCurrentLine
		lda 	zTargetAddr+1
		sta 	zCurrentLine+1
		ldy 	#3
		rts

; *******************************************************************************************
;	
;								GOSUB <line number>
;
; *******************************************************************************************

COMMAND_Gosub: ;; gosub
		ldx 	#0 							; evaluate the linenumber
		jsr 	EvaluateBase
		lda 	#KW_GOSUB
		jsr 	CDOPushPosOnStack 			; save return address on stack.
		bra 	CMDGoto

; *******************************************************************************************
;
;										RETURN
;
; *******************************************************************************************

COMMAND_Return: ;; return
		lda 	#KW_GOSUB 					; check GOSUB on BASIC Stack.
		jsr 	CDOCheckTopStack 
		jsr 	CDOPullPosOffStack 			; restore
		jmp 	CDOThrowPosOffStack 		; and drop it.

; *******************************************************************************************
;
;			Find Program Line in evalStack => zTargetAddr, fail if not found
;
; *******************************************************************************************

FindProgramLine:
		lda 	evalStack+2 				; check in range 0-65535
		ora 	evalStack+3 			
		bne		_FPLFail
		lda 	#BasicProgram & 255 		; start of code
		sta 	zTargetAddr
		lda 	#BasicProgram >> 8
		sta 	zTargetAddr+1
_FPLLoop:
		ldy 	#0 							; reached end
		lda 	(zTargetAddr),y		
		beq 	_FPLFail
		;
		iny 								; check line numbers
		lda 	(zTargetAddr),y
		cmp 	evalStack+0
		bne 	_FPLNext
		iny
		lda 	(zTargetAddr),y
		cmp 	evalStack+1
		bne 	_FPLNext
		rts
		;
_FPLNext:		
		ldy 	#0 							; go to next
		lda 	(zTargetAddr),y
		clc
		adc 	zTargetAddr
		sta 	zTargetAddr
		bcc 	_FPLLoop
		inc 	zTargetAddr+1
		bra 	_FPLLoop
		;
_FPLFail:		
		#error 	"LINE NOT FOUND"
		