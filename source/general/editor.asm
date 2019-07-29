; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		editor.asm
;		Purpose :	Edit Program
;		Date :		29th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;		Editing command (e.g. begins with a digit). Tokenised Code at (zCurrentLine),y
;
; *******************************************************************************************

EditProgram:	
		ldx 	#0
		jsr 	EvaluateAtomCurrentLevel 	; get the line number
		lda 	evalStack+2,x 				; upper bytes must be zero
		ora 	evalStack+3,x
		bne 	_EPBadLine
		lda 	evalStack+0,x 				; lower bytes must be non-zero
		ora 	evalStack+1,x
		beq 	_EPBadLine
		phy 								; save position
		jsr 	EDFindLine 					; locate the line.
		bcc 	_EPNotFound 				; skip delete if not found.
		;
		;		Delete the line as it already exists.
		;
		lda 	zTemp1 						; save the target address, as we will
		pha 								; insert the line, if done, at the same
		lda 	zTemp1+1 					; place
		pha
		jsr 	COMMAND_Clear 				; clear all vars, make sure zLowMemory is right.
		jsr 	EDDeleteLine 				; delete the line at zTemp1
		pla 								; restore the target address.
		sta 	zTemp1+1
		pla
		sta 	zTemp1
_EPNotFound		
		jsr 	COMMAND_Clear 				; set up all the pointers again and reset everything.
		ply 								; get pointer back
_EPSkipSpaces:
		lda 	(zCurrentLine),y 			; get character
		beq 	_EPGoWarmStart 				; EOL, just delete, so warm start.
		iny
		cmp 	#32
		beq 	_EPSkipSpaces
		dey
		#break 								; at line contents
		jsr 	EDInsertLine 				; insert the line.
		jsr 	COMMAND_Clear 				; set up all the pointers again and reset everything.
_EPGoWarmStart:
		jmp 	WarmStart

_EPBadLine:
		#error	"BAD LINE"		

; *******************************************************************************************
;
;		Find line. If found then return CS and zTemp1 points to the line. If
;		not found return CC and zTemp1 points to the next line after it.
;
;		Line# is in evalStack+0,1
;
; *******************************************************************************************

EDFindLine:		
		lda 	#BasicProgram & $FF 		; set zTemp1 
		sta 	zTemp1
		lda 	#BasicProgram >> 8 			
		sta 	zTemp1+1
_EDFLLoop:
		ldy 	#0 							; reached the end
		lda 	(zTemp1),y 	
		beq 	_EDFLFail 					; then obviously that's the end ;-) (great comment !)
		;
		iny
		sec
		lda 	evalStack+0					; subtract the current from the target
		sbc 	(zTemp1),y 					; so if searching for 100 and this one is 90, 
		tax	 								; this will return 10.
		lda 	evalStack+1
		iny
		sbc 	(zTemp1),y
		bcc 	_EDFLFail					; if target < current then failed.
		bne 	_EDFLNext 					; if non-zero then goto next
		cpx 	#0 							; same for the LSB - zero if match found.
		beq 	_EDFLFound
_EDFLNext:									; go to the next.
		ldy 	#0 							; get offset
		clc 
		lda 	(zTemp1),y					
		adc 	zTemp1 						; add to pointer
		sta 	zTemp1
		bcc 	_EDFLLoop
		inc 	zTemp1+1 					; carry out.
		bra 	_EDFLLoop
_EDFLFail:
		clc
		rts		
_EDFLFound:
		sec
		rts		

; *******************************************************************************************
;
;								Delete line at zTemp1
;
; *******************************************************************************************

EDDeleteLine:	
		ldy 	#0 							; this is the offset to copy down.
		ldx 	#0
		lda 	(zTemp1),y
		tay 								; put in Y
_EDDelLoop:
		lda 	(zTemp1),y 					; get it
		sta 	(zTemp1,x) 					; write it.
		;
		lda 	zTemp1 						; check if pointer has reached the end of 
		cmp		zLowMemory 					; low memory. We will have copied down an
		bne 	_EDDelNext 					; extra pile of stuff - technically should
		lda 	zTemp1+1 					; check the upper value (e.g. zTemp1+y)
		cmp 	zLowMemory+1				; doesn't really matter.
		beq		_EDDelExit
		;
_EDDelNext:		
		inc 	zTemp1 						; go to next byte.
		bne 	_EDDelLoop
		inc 	zTemp1+1
		bra 	_EDDelLoop
_EDDelExit:
		rts

; *******************************************************************************************
;
;				Insert line at (zCurrentLine),y into program space at (zTemp1)
;
; *******************************************************************************************

EDInsertLine:
		#break
		tya 								; make zCurrentLine point to the actual new line.
		clc
		adc 	zCurrentLine
		sta 	zCurrentLine
		;
		;		Work out in Y, the line length in pure characters - so NO offset,
		; 		line number or end marker. So A=4 is 3.
		;
		ldy 	#0 							; work out the line length.
_EDGetLength:
		lda 	(zCurrentLine),y
		iny
		cmp 	#0
		bne 	_EDGetLength
		dey 								; fix up.
		;
		;		Shift up memory to make room. Use zLowMemory as we'll reset it after.
		;
		phy 								; save on stack.
		tya
		clc
		adc 	#1+2+1 						; size required. 1 for offset, 2 for line#, 1 for end.
		tay 								; in Y
		ldx 	#0 			
_EDInsLoop:
		lda 	(zLowMemory,x)				; copy it up
		sta 	(zLowMemory),y
		;
		lda 	zLowMemory 					; reached the insert point (zTemp1)
		cmp 	zTemp1
		bne 	_EDINextShift
		lda 	zLowMemory+1
		cmp 	zTemp1+1
		beq 	_EDIShiftOver
		;
_EDINextShift:		
		lda 	zLowMemory 					; decrement the copy pointer.
		bne 	_EDINoBorrow
		dec 	zLowMemory+1
_EDINoBorrow:
		dec 	zLowMemory			
		bra 	_EDInsLoop
		;
		;		Shift is done. So copy the new stuff in.
		;
_EDIShiftOver:		
		#break
		rts

