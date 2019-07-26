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