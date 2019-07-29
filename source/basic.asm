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
		lda 	StartBehaviour 				; what to do ?
		cmp 	#'C'						; execute from command line
		beq		CommandLine
		cmp 	#'R' 						; run program in memory.
		beq	 	RunProgram
		cmp 	#'T'						; tokenise test
		beq 	TokeniseExec

		jmp		SyntaxError

; *******************************************************************************************
;
;									Run whatever is loaded
;
; *******************************************************************************************

RunProgram:
		.if TARGET=1						; copy BASIC into RAM on Mega65
		jsr 	CopyBasicCode
		.endif
		jsr 	COMMAND_New 				; do a new 
		jsr 	COMMAND_Old 				; get back the old program as we're deving.
		jmp 	COMMAND_Run

; *******************************************************************************************
;
;							Enter commands through the command line
;
; *******************************************************************************************

CommandLine:		
		jsr 	Command_New
WarmStart:
		#resetstack 						; reset the stack
		jmp 	WarmStart

; *******************************************************************************************
;
;						Tokenise whatever is in the buffer and exit
;
; *******************************************************************************************

TokeniseExec:
		lda 	#BasicCode & $FF 			; if so tokenise whatever I've put in the basic code
		sta 	zTemp1 						; area
		lda 	#BasicCode >> 8
		sta 	zTemp1+1
		jsr 	TokeniseString
		#exit 								; and exit immediately.

; *******************************************************************************************
;
;								BASIC Program, built in.
;
; *******************************************************************************************

		.if TARGET=2 						; emulator, can just include code and it's loaded
		* = BasicProgram 					; mega65, part of the ROM and needs copying in.
		.endif

BasicCode:
		.include "include/basic_generated.inc"

