; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		scompare.asm
;		Purpose :	String comparison, returns -1 0 1 like strcmp
;		Date :		26th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;	
;									String Comparison
;
; *******************************************************************************************

BFUNC_StringCompare:	;; ~
		lda 	evalStack+0,x 				; get address into temporaries.
		sta 	zTemp1
		lda 	evalStack+1,x
		sta 	zTemp1+1
		lda 	evalStack+4,x
		sta 	zTemp2
		lda 	evalStack+5,x
		sta 	zTemp2+1		

		phy
		ldy 	#0
_BFSCLoop:
		lda 	(zTemp1),y 					; comparison
		sec
		cmp 	(zTemp2),y		
		bne		_BFSCDifferent 				; return different result.
		iny
		cmp 	#0							; until both EOS.
		bne 	_BFSCLoop
		ply
		lda 	#0
_BFSCSetAll:
		sta 	evalStack+0,x
		sta 	evalStack+1,x
		sta 	evalStack+2,x
		sta 	evalStack+3,x
		rts
;
_BFSCDifferent:
		ply
		lda 	#255 						; if CC set all as <
		bcc 	_BFSCSetAll
		lda 	#0 							; set all zero
		jsr 	_BFSCSetAll
		inc 	evalStack+0,x 				; and make it one.
		rts
