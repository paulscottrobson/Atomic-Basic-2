; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		dim.asm
;		Purpose :	Array Dimensions
;		Date :		29th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************

; *******************************************************************************************
;
;		Formats:
;			AA(n)			Allocates (n+1) 4 bytes after end of program
;			A(n)			Allocates (n+1) bytes
; 
; *******************************************************************************************

COMMAND_Dim: 	;; dim
		lda 	(zCurrentLine),y 			; skip over , and space
		beq 	_CDIMExit
		cmp		#KW_COLON
		beq 	_CDIMExit
		iny
		cmp 	#KW_COMMA
		beq 	COMMAND_Dim
		cmp 	#" "
		beq 	COMMAND_Dim
		bra 	_CDIMDoDim
		;
_CDIMExit:
		rts
		;
_CDIMSyntax:
		jmp 	SyntaxError						
		;
_CDIMDoDim:
		;
		;		Get array and identify if A or AA.
		;
		cmp 	#"@"						; check it is @A-Z
		bcc 	_CDIMSyntax
		cmp 	#"Z"+1
		bcs 	_CDIMSyntax
		cmp 	(zCurrentLine),y 			; is it followed by a duplicate
		bne 	_CDIMNoDouble
		iny 								; yes, so skip it to the size.
		ora 	#$80 						; and set bit 7 to indicate AA(x) e.g. 4 bytes.
_CDIMNoDouble:
		pha 								; save array 'name'
		ldx 	#0 							; count it bottom stack level.
		jsr 	EvaluateAtomCurrentLevel		
		inc 	evalStack+0 				; add extra element
		bne 	_CDIMAlloc
		inc 	evalStack+1
		;
		;		Allocate evalStack bytes or words.
		;
_CDIMAlloc:		
		pla 								; get bit 7
		pha
		bpl 	_CDIMNotWord 				; if not set, then A(x) not AA(x) so use byte size.

		asl 	evalStack+0 				; shift left x 2
		rol 	evalStack+1
		asl 	evalStack+0 				; won't bother about the upper 16 bits.
		rol 	evalStack+1		
_CDIMNotWord:				
		;
		;		Copy low memory into variable
		;
		pla 								; variable back
		and 	#$1F 						; lower 5 bits
		asl 	a 							; x 4 now index into variable.
		asl 	a
		tax
		;
		lda 	zLowMemory 					; copy low memory into variable
		sta 	FixedVariables,x
		lda 	zLowMemory+1
		sta 	FixedVariables+1,x
		lda 	#0 							; zero upper 2 bytes
		sta 	FixedVariables+2,x
		sta 	FixedVariables+3,x
		;
		;		Add count to low memory pointer.
		;
		clc 	
		lda 	zLowMemory
		adc 	evalStack+0
		sta 	zLowMemory
		lda 	zLowMemory+1
		adc 	evalStack+1
		sta 	zLowMemory+1
		bcs 	_CDIMMemory					; out of memory ?

		lda 	HighMemory
		sec
		sbc 	zLowMemory
		lda 	HighMemory+1
		sbc 	zLowMemory+1
		bcc 	_CDIMMemory
		bra 	Command_DIM 				; go back try another.

_CDIMMemory:
		#error 	"OUT OF MEMORY"