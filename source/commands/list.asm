; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		list.asm
;		Purpose :	List Statement
;		Date :		25th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

COMMAND_List: 	;; list
		lda 	(zCurrentLine),y 			; look first non space
		iny
		cmp 	#' '
		beq 	COMMAND_List
		dey
		cmp 	#"0" 						; not digit, list all
		bcc 	_CLIAll
		cmp 	#"9"+1
		bcs 	_CLIAll
		ldx 	#0 							; evaluate the linenumber
		jsr 	EvaluateBase
		jsr 	FindProgramLine 			; find that program Line, put in zTargetAddr
		bra 	_CLIMain 					; list it.

_CLIAll:		
		phy
		lda 	#BasicProgram & $FF 		; set target address
		sta 	zTargetAddr
		lda 	#BasicProgram >> 8 
		sta 	zTargetAddr+1
_CLIMain:		
		lda 	#16 						; print 16 lines
		sta 	zTargetAddr+2
_CLLILoop:
		ldy 	#0
		lda 	(zTargetAddr),y 			; if that offset is zero exit
		beq 	_CLLIExit
		jsr 	CLIOneLine 					; list one line.
		ldy 	#0 							; advance pointer to next.
		clc
		lda 	(zTargetAddr),y
		adc 	zTargetAddr
		sta 	zTargetAddr
		bcc 	_CLLINoCarry
		inc 	zTargetAddr+1
_CLLINoCarry:
		dec 	zTargetAddr+2 				; done all of them ?
		bne 	_CLLILoop
_CLLIExit:
		ply
		jmp 	WarmStart

CLIOneLine:
		ldy 	#1 							; get line#
		lda 	(zTargetAddr),y
		sta 	evalStack+0
		iny
		lda 	(zTargetAddr),y
		sta 	evalStack+1
		lda 	#0
		tax
		sta 	evalStack+2
		sta 	evalStack+3
		jsr 	CPRPrintInteger 			; print line#
		lda 	#32
		jsr 	SIOPrintCharacter	
		ldy 	#3 							; where to start
_CLIOutput:
		lda 	(zTargetAddr),y
		iny
		ora 	#0
		beq 	_CLIExit
		bpl		_CLISingle
		jsr 	CLIPrintToken 
		bra 	_CLIOutput
_CLISingle:
		jsr 	SIOPrintCharacter
		bra 	_CLIOutput
		;
_CLIExit:		
		lda 	#13 						; new line.
		jsr 	SIOPrintCharacter
		rts
		;
		;		Print token A.
		;
CLIPrintToken:
		phy 								; save Y
		and 	#$7F 						; 7 bit token -> Y
		tay
		ldx 	#0 							; offset into token text table.
_CLIFind:
		dey 								; decrement counter
		bmi 	_CLIFoundToken 				; if -ve found the token.
_CLISkip:
		lda 	TokenText,x
		inx
		asl		a
		bcc 	_CLISkip
		bra 	_CLIFind

_CLIFoundToken:
		ply
_CLIPrintIt:								; print the token out.
		lda 	TokenText,x
		inx
		pha
		and 	#$7F		
		jsr 	SIOPrintCharacter
		pla
		asl 	a
		bcc 	_CLIPrintIt		
		rts		