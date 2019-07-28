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
		.include 	"general/tokeniser.asm"	; tokeniser.

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
		.include 	"commands/print.asm" 	; print statement
		.include 	"commands/list.asm"		; list statement
		
Start:
		#resetstack 						; reset CPU stack.

		.if TARGET=1 						; on the MEGA65 if we provide code we have to copy
		jsr 	CopyBasicCode 				; it into the BASIC area.
		.endif

		jsr 	SIOInitialise 				; initialise the I/O system.
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

		.if TARGET=2 						; emulator, can just include code and it's loaded
		* = BasicProgram
		.endif
BasicCode:
		.include "include/basic_generated.inc"

