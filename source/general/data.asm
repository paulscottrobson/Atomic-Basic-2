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
zBasicStack:	.word 	? 					; stack for BASIC.
zLowMemory:		.word	?					; next free space after program (arrays,vars etc.)
zTemp1:			.word 	?					; temporary vars
zTemp2:			.word 	?

		* = startMemory

FixedVariables:	.fill 	26*4 				; address of 26 x 4 byte fixed variables A-Z

HashTableSize = 8 							; number of entries, must be a power of 2.
HashTable:		.fill	HashTableSize*2		; hash table for variable linked lists.

HighMemory:		.word 	?					; highest memory location available (2 bytes)
Temp1:			.dword	?					; 4 byte temporary stores.
SignCount:		.byte 	? 					; count of signs in divide.
StringBufferPos:.byte 	? 					; next free slot in string buffer

				.align	256 				
StringBuffer:	 							; string buffer.
				.byte ?

				.align	256 				
BasicProgram:					 			; BASIC program starts here.

		* = currentPosData

