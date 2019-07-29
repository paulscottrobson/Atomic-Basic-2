; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		tokeniser.asm
;		Purpose :	Tokenise a string into the TokeniseBuffer from zTemp1
;		Date :		27th July 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;				Tokenise string at zTemp1 into the Tokenise Buffer.
;
; *******************************************************************************************

TokeniseString:
		ldy 	#0							; source
		ldx 	#0 							; target
_TokLoop:
		lda 	(zTemp1),y 					; get first
		beq 	_TokExit 					; End, exit.
		cmp 	#32 						; if space, copy it
		beq 	_TokCopy1
		cmp 	#'"' 						; if string, copy that in.
		beq 	_TokCopyString
		cmp 	#"0" 						; punctuation, search for it.
		bcc 	_TokPunctuation
		cmp 	#"9"+1 						; digits are just copied over.
		bcc 	_TokCopy1
		cmp 	#"A"						; more punctuation
		bcc 	_TokPunctuation 
		cmp 	#"Z"+1 						; and more punctuation
		;
		;		Tokenise 1 word, e.g. it begins with @-Z
		;
_TokWord:
		jsr 	TokeniseSearch 				; search for tokenised word.
		bcs 	_TokFound 					; if successful, copy it out.
_TokSkip:
		lda 	(zTemp1),y 					; copy all A-Z as can't start token in mid word.
		cmp 	#"A"
		bcc 	_TokLoop
		cmp 	#"Z"+1
		bcs 	_TokLoop
		sta 	TokeniseBuffer,x
		inx
		iny
		bra 	_TokSkip
		;
		;		Tokenise a punctuation character or characters.
		;
_TokPunctuation:
		jsr 	TokeniseSearch 				; find it.
		bcc 	_TokCopy1 					; if found, just copy 1 character
_TokFound:
		sta 	TokeniseBuffer,x 			; save in tokenise buffer.
		inx 								; advance target ; source is already advanced.
		bra 	_TokLoop 					; do the next character.		
		;
		;		Tokenise 1 character
		;
_TokCopy1:		
		lda 	(zTemp1),y
		sta 	TokeniseBuffer,x
		inx
		iny
		bra 	_TokLoop
		;
		;		Tokenise (e.g. copy) a quoted string.
		;
_TokCopyString:		
		lda 	#KW_DQUOTE 					; output double quote token
		sta 	TokeniseBuffer,x
		inx 								; skip buffer and first quote.
		iny
_TokCSLoop:
		lda 	(zTemp1),y 					; get next character
		beq 	_TokExit 					; if EOL, then you have a mismatch, but we exit.
		sta 	TokeniseBuffer,x 			; write to buffer
		inx 								; advance both.
		iny		
		cmp 	#'"'						; keep going till other quote found.
		bne 	_TokCSLoop
		lda 	#KW_DQUOTE 					; add the trailing quote token, overwriting the
		sta 	TokeniseBuffer-1,x 			; " character that's just been copied
		bra 	_TokLoop
		;
		;		Exit
		;
_TokExit:				
		lda 	#0 							; mark the end of the tokenise buffer.
		sta 	TokeniseBuffer,x
		rts

; *******************************************************************************************
;
;		Look for a matching token. The token to match is at (zTemp1),y. Return CC and no
;		change if failed, return CS, A = token ID, and Y advanced past if succeeded.
;
; *******************************************************************************************

TokeniseSearch:
		pha 								; save AXY
		phx
		phy
		;
		lda 	#128 						; zTemp2 keeps track of the token #
		sta 	zTemp2 				
		ldx 	#0 							; index into TokenText table.		
		;
		;		Check the next token.
		;
_TSNext:lda 	TokenText,x 				; get the first token character
		and 	#$7F 						; bit 7 marks the end.
		cmp 	(zTemp1),y 					; do the characters match.
		beq 	_TSTryFullMatch 			; if so, try the full match.
											; (it's in alphabetical order on first character)
		;
		;		Go forward to the next token.
		;
_TSGotoNext:		
		lda 	TokenText,x 				; read it
		inx 								; bump index
		asl 	a 							; shift into C
		bcc 	_TSGotoNext 				; keep going until read the end character
		inc 	zTemp2 						; bump the current token pointer.
		lda 	TokenText,x 				; look at the first character of the next token
		bne 	_TSNext 					; if non-zero, go to the next.
		;
		;		Search has failed
		;
_TSFail:		
		ply 								; fail.
		plx
		pla
		clc 				 				; return with carry clear.
		rts
		;
		;		Try the full token match.
		;
_TSTryFullMatch:	
		phx									; save X and Y.
		phy 
_TSFullMatch:
		lda 	TokenText,x 				; compare the 7 bits.
		and 	#$7F
		cmp 	(zTemp1),y
		bne 	_TSFullFail 				; different, this one doesn't match.
		lda 	TokenText,x
		inx 								; advance to next character
		iny 	
		asl 	a 							; bit 7 of token text in C
		bcc 	_TSFullMatch
		;
		;		Successful full match. Y points to the character after.
		;
		sty 	zTemp2+1 					; save the Y after last
		pla 								; so we don't restore Y
		pla 								; or X from the full test.
		;
		ply 								; restore original Y and X and A
		plx
		pla 
		lda 	zTemp2 						; and return token ID in A
		ldy 	zTemp2+1 					; Y after the tokenised text.
		sec 								; with carry set.
		rts
		;
		;		Failed full match
		;
_TSFullFail:		
		ply 								; restore Y and X
		plx
		bra 	_TSGotoNext 				; and go to the next token to test.

; *******************************************************************************************
;
;										Testing code
;
; *******************************************************************************************

TokeniseTest:
		lda 	#TTString & $FF
		sta 	zTemp1
		lda 	#TTString >> 8
		sta 	zTemp1+1
		jsr 	TokeniseString
		#break		

TTString:
		.text 	' ABCD 41$"LENA"5LENA',0 			; 4 1 $[T] "LENA" 5 LEN[T] A

