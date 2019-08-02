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

		.if TARGET=2 						; emulator, can just include code and it's loaded
		* = BasicProgram 					; mega65, part of the ROM and needs copying in.
		.endif
		
IncludeBasicCode:
		.include "include/basic_generated.inc"
EndBasicCode:
	
		* = $8000
		.text "Page 8"
		* = $9000
		.text "Page 9"
		* = $C000
		.text "Hello world"
		* = $D000
		.text "Goodbye Cruel World"

		* = $E000
		.include 	"include/tokens.inc"	; generated token tables and constants.

		.include 	"general/support.asm" 	; general support.
		.include 	"general/data.asm"		; data handling.
		.include 	"general/evaluate.asm"	; evaluation code.
		.include 	"general/variable.asm"	; variable handling.
		.include 	"general/screenio.asm"	; I/O functions.
		.include 	"general/tokeniser.asm"	; tokeniser.
		.include 	"general/editor.asm"	; program editing.

		.include 	"binary/arithmetic.asm" ; basic arithmetic
		.include 	"binary/binary.asm" 	; binary operators
		.include 	"binary/compare.asm"	; numerical comparisons
		.include 	"binary/divide.asm" 	; division and modulus
		.include 	"binary/multiply.asm" 	; multiplication
		.include 	"binary/scompare.asm"	; string comparisons

		.include 	"unary/unary.asm"		; miscellaneous unary functions
		
		.include 	"commands/dim.asm" 		; dimension
		.include 	"commands/dountil.asm"	; do/until statements
		.include 	"commands/goto.asm"		; goto/gosub/return statements
		.include 	"commands/if.asm"		; if/then/else statement.
		.include 	"commands/let.asm"		; assignment.
		.include 	"commands/list.asm"		; list statement
		.include 	"commands/miscellany.asm" ; miscellaneous statements
		.include 	"commands/print.asm" 	; print statement
		.include 	"commands/execute.asm"	; run/stop etc.		
				
Start:
		#resetstack 						; reset CPU stack.
		.if TARGET=1
		;jsr 	RemapMemory 				; remap memory (Mega65 only)
		.endif
		jsr 	SIOInitialise 				; initialise the I/O system.
		ldx 	#BootMsg1 & 255 			; boot text.
		ldy 	#BootMsg1 >> 8
		jsr 	SIOPrintString
		ldx 	#(endMemory-startMemory-1) & $FF
		ldy 	#(endMemory-startMemory-1) >> 8
		jsr 	PrintWordInteger
		ldx 	#BootMsg2 & 255
		ldy 	#BootMsg2 >> 8
		jsr 	SIOPrintString

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
		jsr 	COMMAND_NewCode 			; do a new 
		jsr 	COMMAND_OldCode 			; get back the old program as we're deving.
		jmp 	COMMAND_Run

; *******************************************************************************************
;
;							Enter commands through the command line
;
; *******************************************************************************************

CommandLine:		
		jsr 	Command_NewCode
WarmStart:
		#resetstack 						; reset the stack
		jsr 	SIOReadLine 				; read input line.
		;
		lda 	#InputLine & $FF 			; tokenise the line
		sta 	zTemp1
		lda 	#InputLine >> 8
		sta 	zTemp1+1
		jsr 	TokeniseString
		;
		lda 	#TokeniseBuffer & $FF 		; point current line to tokenised input buffer.
		sta 	zCurrentLine
		lda 	#TokeniseBuffer >> 8
		sta 	zCurrentLine+1
		ldy 	#0
_WSSkipSpace: 								; look for first non space character
		lda 	(zCurrentLine),y
		iny
		cmp 	#' '
		beq 	_WSSkipSpace
		dey
		cmp 	#"0" 						; if not a digit
		bcc 	_WSExecute
		cmp 	#"9"+1
		bcs 	_WSExecute
		jsr 	EditProgram
		jmp 	WarmStart

_WSExecute:
		jmp 	CRUNNextInstruction

; *******************************************************************************************
;
;						Tokenise whatever is in the buffer and exit
;
; *******************************************************************************************

TokeniseExec:
		lda 	#IncludeBasicCode & $FF 	; if so tokenise whatever I've put in the basic code
		sta 	zTemp1 						; area
		lda 	#IncludeBasicCode >> 8
		sta 	zTemp1+1
		jsr 	TokeniseString
		#exit 								; and exit immediately.

BootMsg1:
		.text 	"*** ATOMIC BASIC ***",13,13,0
BootMsg2:		
		.text	" BYTES FREE.",13,13,0

