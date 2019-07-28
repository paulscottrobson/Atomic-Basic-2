; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		basic.asm
;		Purpose :	Basic Interpreter (Main)
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

		.include 	"porting.asm"			; implementation specific stuff

		* = $E000
		.include 	"include/tokens.inc"	; generated token tables and constants.

		.include 	"general/support.asm" 	; general support.
		.include 	"general/data.asm"		; data handling.
		.include 	"general/evaluate.asm"	; evaluation code.
		.include 	"general/variable.asm"	; variable handling.
		.include 	"general/screenio.asm"	; I/O functions.

		.include 	"binary/arithmetic.asm" ; basic arithmetic
		.include 	"binary/binary.asm" 	; binary operators
		.include 	"binary/multiply.asm" 	; multiplication
		.include 	"binary/divide.asm" 	; division and modulus
		.include 	"binary/compare.asm"	; numerical comparisons
		.include 	"binary/scompare.asm"	; string comparisons
		.include 	"unary/unary.asm"		; miscellaneous unary functions
		
		.include 	"commands/execute.asm"	; run/stop etc.		
		.include 	"commands/miscellany.asm" ; miscellany
		.include 	"commands/let.asm"		; assignment.

		
Start:
		#resetstack 						; reset CPU stack.
		jsr 	SIOInitialise 				; initialise the I/O system.
h1:		
		jsr 	SIOReadLine
;		#break
		bra 	h1

		jsr 	COMMAND_New 				; do a new 
		jsr 	COMMAND_Old 				; get back the old program as we're deving.

WarmStart:
		#resetstack 						; reset the stack
		jmp 	COMMAND_Run 				; RUN current program.

SyntaxError:
		lda 	#1
		break
		bra 	SyntaxError
ReportError:	
		lda 	#2
		break
		bra 	ReportError

		* = basicProgram					; load BASIC into RAM space.
		.include "include/basic_generated.inc"

