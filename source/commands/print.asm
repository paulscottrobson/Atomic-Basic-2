; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		print.asm
;		Purpose :	Print Statement
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;										Print command
;
; *******************************************************************************************

COMMAND_Print: 	;; print
		lda 	(zCurrentLine),y			; look at next character
		beq 	_CPRExitNL 					; zero end of line.
		iny
		cmp 	#' '
		beq 	COMMAND_Print
		cmp 	#KW_COLON 					; colon, end of line
		beq 	_CPRExitNL
		cmp 	#KW_SEMICOLON 				; semicolon ?
		bne 	_CPRNotSemicolon
		;
		lda 	(zCurrentLine),y 			; look at next character, is ; last thing
		beq 	_CPRExit
		cmp 	#KW_COLON
		bne 	COMMAND_Print 				; if not, just go back round again
		rts
		;
_CPRExitNL:									; exit, new line.
		lda 	#13
		jsr 	SIOPrintCharacter
_CPRExit:									; exit.
		rts		
		;
_CPRNotSemicolon:
		cmp 	#KW_SQUOTE 					; single quote
		beq 	_CPRNewLine 				; new line
		cmp 	#KW_DQUOTE 					; double quote
		bne 	_CPRNotQuote
		;
_CPRPrintText:
		lda 	(zCurrentLine),y			; get next character
		beq 	_CPRError 					; if zero no closing quote
		iny
		cmp 	#KW_DQUOTE					; double quote
		beq 	COMMAND_Print 				; go round again.
		jsr 	SIOPrintCharacter 			; print and do next character
		bra 	_CPRPrintText 				
		;
_CPRError:
		#error 	"MISSING CLOSING QUOTE"
		;
_CPRNewLine:
		lda 	#13
		jsr 	SIOPrintCharacter
		bra 	COMMAND_Print
		;
		;		Value of some sort, could be a string ($x) hex (&x) constant x
		;
_CPRNotQuote:				
		cmp 	#KW_DOLLAR 					; not a string ?
		bne 	_CPRNumber 					; print a number.
		;
		jsr 	EvaluateBase 				; this is the address to print.
		phy
		ldy 	evalStack+1,x 				; get the address
		lda 	evalStack+0,x
		tax
		jsr 	SIOPrintString
		ply
		bra 	COMMAND_Print
		;
		;		Expression, hex or decimal.
		;
_CPRNumber:
		cmp 	#KW_AMPERSAND
		beq 	_CPRHexadecimal

		dey 								; must be 1st char of expr
		jsr 	EvaluateBase 				; this is the value to print.
		lda 	evalStack+3,x 				; is it -ve
		bpl 	_CPRIsPositive
		jsr 	BFUNC_NegateAlways 			; negate it
		lda 	#"-" 						; print - it.
		jsr 	SIOPrintCharacter
_CPRIsPositive:		
		jsr 	CPRPrintInteger 			; Print string at current eval stack, base 10.
		jmp 	COMMAND_Print
		;
_CPRHexadecimal:
		jsr 	EvaluateBase 				; this is the value to print.
		jsr 	_CPRPrintRecHex 			; hex version of it.
		jmp 	COMMAND_Print

_CPRPrintRecHex:
		lda 	evalStack+0 				; get the remainder
		and 	#15 						; and put on stack
		pha

		ldx 	#4 							; divide by 16
_CPRShiftDiv:
		lsr 	evalStack+3
		ror 	evalStack+2
		ror		evalStack+1
		ror		evalStack+0
		dex
		bne 	_CPRShiftDiv
		;
		lda 	evalStack+0 				; any more to print
		ora 	evalStack+1
		ora 	evalStack+2
		ora 	evalStack+3
		beq 	_CPRNoHexRec
		jsr 	_CPRPrintRecHex 			
_CPRNoHexRec:
		pla 								; original remainder.
		cmp 	#10
		bcc		_CPRNH2 
		adc 	#6
_CPRNH2:adc 	#48
		jmp 	SIOPrintCharacter

; *******************************************************************************************
;
;						 	Print number in eval stack,X in base 10
;
; *******************************************************************************************

CPRPrintInteger:
		pha 								; save on stack.
		phx
		phy
		jsr 	_CPRPrintRec 				; recursive print call
		ply
		plx
		pla
		rts

_CPRPrintRec:
		lda 	#10 						; save base
		sta 	evalStack+4,x 				; put in next slot.
		lda 	#0 							; clear upper 3 bytes
		sta 	evalStack+5,x
		sta 	evalStack+6,x
		sta 	evalStack+7,x
		jsr 	BFUNC_Divide 				; divide by 10.
		lda 	Temp1+0		 				; push remainder on stack
		pha

		lda 	evalStack+0,x 				; is the result #0
		ora 	evalStack+1,x
		ora 	evalStack+2,x
		ora 	evalStack+3,x
		beq 	_CPRNoRecurse
		jsr 	_CPRPrintRec 				; recursive print.
_CPRNoRecurse:		
		pla
		ora 	#"0"
		jmp 	SIOPrintCharacter

; *******************************************************************************************
;
;									CLS Clear Screen
;
; *******************************************************************************************

COMMAND_CLS:	;; cls
		jmp 	SIOClearScreen