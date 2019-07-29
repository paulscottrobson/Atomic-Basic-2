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
		lda 	#1
		break
		bra 	SyntaxError
ReportError:	
		lda 	#2
		break
		bra 	ReportError

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
		#error 	"Missing token"		

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
