; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		support.asm
;		Purpose :	General support macros etc.
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

break:	.macro
		nop
		.endm

exit:	.macro
		.byte 	2
		.endm

resetstack: .macro
		#EXTResetStack
		.endm

error:	.macro
		jsr 	ReportError
		.text 	\1,$00
		.endm

; *******************************************************************************************
;
;									Error Reporting
;
; *******************************************************************************************

SyntaxError:
		jsr 	ReportError
		.text	"SYNTAX ERROR",0
ReportError:	
		plx
		ply
		inx
		bne 	_REPrint
		iny
_REPrint:
		jsr 	SIOPrintString
		lda 	zCurrentLine+1 				; running from tokeniser buffer
		cmp 	#TokeniseBuffer>>8
		beq 	_RENoLineNumber
		lda 	#" "
		jsr 	SIOPrintCharacter
		lda 	#"@"
		jsr 	SIOPrintCharacter
		ldy 	#1
		lda 	(zCurrentLine),y
		tax
		iny
		lda 	(zCurrentLine),y
		tay
		jsr 	PrintWordInteger
_RENoLineNumber:
		lda 	#13
		jsr 	SIOPrintCharacter
		jmp 	WarmStart		

; *******************************************************************************************
;
;							Print XY as an integer
;
; *******************************************************************************************

PrintWordInteger:
		txa
		ldx 	#0
		sta 	evalStack+0,x
		tya
		sta 	evalStack+1,x
		iny
		lda 	#0
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		jsr 	CPRPrintInteger
		rts

; *******************************************************************************************
;
;					  Check and skip next character in program
;
; *******************************************************************************************

CheckNextCharacter:
		sta 	Temp1 						; save character to check
_CNCLoop:		
		lda 	(zCurrentLine),y			; get next
		beq 	_CNCFail 					; end of line, so no character
		iny
		cmp 	#' ' 						; skip spaces
		beq 	_CNCLoop
		cmp 	Temp1 						; fail if not what was wanted
		bne 	_CNCFail
		rts
_CNCFail:
		#error 	"MISSING TOKEN"

; *******************************************************************************************
;
;		On the Mega65 copy the first 1/2k into RAM. Obviously can't do
;		this seriously.
;
; *******************************************************************************************

		.if TARGET=1
CopyBasicCode:
		ldx 	#0
_CopyLoop:		
		lda 	BasicCode,x
		sta 	BasicProgram,x
		lda 	BasicCode+$100,x
		sta 	BasicProgram+$100,x
		inx
		bne 	_CopyLoop
		rts
		.endif
