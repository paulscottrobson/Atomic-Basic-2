; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		divide.asm
;		Purpose :	Divide +4 into +0 (and modulus)
;		Date :		26th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									Divide +4 into +0
;
; *******************************************************************************************

BFUNC_Divide: 	;; 	/
		lda 	evalStack+4,x 				; check for /0
		ora 	evalStack+5,x
		ora 	evalStack+6,x
		ora 	evalStack+7,x
		bne 	_BFDOkay
		#error	"Divison by Zero"
		;
_BFDOkay:
		lda 	#0 							; Temp1 is 'A' (and holds the remainder)
		sta 	Temp1 						; Q/Dividend/Left in +0
		sta 	Temp1+1 					; M/Divisor/Right in +4
		sta 	Temp1+2
		sta 	Temp1+3
		sta 	SignCount 					; Count of signs.
		jsr 	BFUNC_Negate 				; negate (and bump sign count)
		phx
		inx
		inx
		inx
		inx
		jsr 	BFUNC_Negate
		plx
		phy 								; Y is the counter
		ldy 	#32 						; 32 iterations of the loop.
_BFDLoop:
		asl 	evalStack+0,x 				; shift AQ left.
		rol 	evalStack+1,x
		rol 	evalStack+2,x
		rol 	evalStack+3,x
		rol 	Temp1
		rol 	Temp1+1
		rol 	Temp1+2
		rol 	Temp1+3
		;
		sec
		lda 	Temp1+0 					; Calculate A-M on stack.
		sbc 	evalStack+4,x
		pha
		lda 	Temp1+1
		sbc 	evalStack+5,x
		pha
		lda 	Temp1+2
		sbc 	evalStack+6,x
		pha
		lda 	Temp1+3
		sbc 	evalStack+7,x
		bcc 	_BFDNoAdd
		;
		sta 	Temp1+3 					; update A
		pla
		sta 	Temp1+2
		pla
		sta 	Temp1+1
		pla
		sta 	Temp1+0
		;
		lda 	evalStack+0,x 				; set Q bit 1.
		ora 	#1
		sta 	evalStack+0,x
		bra 	_BFDNext
_BFDNoAdd:
		pla 								; Throw away the intermediate calculations
		pla
		pla		
_BFDNext:									; do 32 times.
		dey
		bne 	_BFDLoop
		ply 								; restore Y and exit
		lsr 	SignCount 					; if sign count odd,
		bcs		BFUNC_NegateAlways 			; negate the result
		rts

; *******************************************************************************************
;
;			 Negate +0 if it is -ve (e.g. absolute value, and bump signcount)
;
; *******************************************************************************************

BFUNC_Negate:
		lda 	evalStack+3,x
		bpl 	BFNExit
BFUNC_NegateAlways:		
		sec
		lda 	#0
		sbc 	evalStack+0,x
		sta 	evalStack+0,x
		lda 	#0
		sbc 	evalStack+1,x
		sta 	evalStack+1,x
		lda 	#0
		sbc 	evalStack+2,x
		sta 	evalStack+2,x
		lda 	#0
		sbc 	evalStack+3,x
		sta 	evalStack+3,x
		;
		inc 	SignCount
BFNExit:
		rts		

; *******************************************************************************************
;
;							Divide +4 into +0, return modulus
;
; *******************************************************************************************

BFUNC_Modulus: 	;; %
		jsr 	BFUNC_Divide 				; start with division.
		lda 	Temp1+0 					; copy remainder
		sta 	evalStack+0,x
		lda 	Temp1+1
		sta 	evalStack+1,x
		lda 	Temp1+2
		sta 	evalStack+2,x
		lda 	Temp1+3
		sta 	evalStack+3,x
		rts
