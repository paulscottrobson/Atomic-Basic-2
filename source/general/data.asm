; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		data.asm
;		Purpose :	Data Allocation
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

		currentPosData = *

		* = zeroPage

zCurrentLine: 	.word 	?					; address of current line (offset word)
zLowMemory:		.word	?					; next free space after program (arrays,vars etc.)
zTemp1:			.word 	?					; temporary vars
zTemp2:			.word 	?
zTargetAddr: 	.dword 	? 					; address of LHS of assignment, list pointer.

		* = startMemory

FixedVariables:	.fill 	27*4 				; address of 26 x 4 byte fixed variables @A-Z
											; these must be page aligned.

Control 		.byte 	? 					; 0 = normal, 1 = tokenise, 2 = run program.

InputLine:		.fill 	EXTWidth+1 			; screen input buffer, cannot cross page.

HighMemory:		.word 	?					; highest memory location available (2 bytes)
Temp1:			.dword	?					; 4 byte temporary stores.
SignCount:		.byte 	? 					; count of signs in divide.
StringBufferPos:.byte 	? 					; next free slot in string buffer
RandomSeed 		.word 	? 					; Random Number
xCursor 		.byte 	? 					; cursor position
yCursor 		.byte 	?
breakCheckCount	.byte 	?					; how often check for break.
basicStackIndex	.byte 	? 					; index into Basic Stack.
registers		.fill 	5 					; A X Y Z P registers in/out for LINK.

				.align	256 				
TokeniseBuffer: 							; tokenise buffer
				.fill 	256
StringBuffer:	 							; temporary string buffer (quoted strings in code)
				.fill 	256
 				
BasicProgram:					 			; BASIC program starts here.

		* = currentPosData

