KeywordVectorTable:
	.word	BFUNC_WordInd                 ; "!"        ($0080)
	.word	SyntaxError                   ; """        ($0081)
	.word	SyntaxError                   ; "#"        ($0082)
	.word	BFUNC_String                  ; "$"        ($0083)
	.word	BFUNC_Modulus                 ; "%"        ($0084)
	.word	BFUNC_And                     ; "&"        ($0085)
	.word	SyntaxError                   ; "'"        ($0086)
	.word	SyntaxError                   ; "("        ($0087)
	.word	SyntaxError                   ; ")"        ($0088)
	.word	BFUNC_Multiply                ; "*"        ($0089)
	.word	BFUNC_Add                     ; "+"        ($008a)
	.word	BFUNC_Subtract                ; "-"        ($008b)
	.word	BFUNC_Divide                  ; "/"        ($008c)
	.word	SyntaxError                   ; ":"        ($008d)
	.word	SyntaxError                   ; ";"        ($008e)
	.word	BFUNC_LessEqual               ; "<="       ($008f)
	.word	BFUNC_NotEquals               ; "<>"       ($0090)
	.word	BFUNC_Less                    ; "<"        ($0091)
	.word	BFUNC_Equals                  ; "="        ($0092)
	.word	BFUNC_GreaterEqual            ; ">="       ($0093)
	.word	BFUNC_Greater                 ; ">"        ($0094)
	.word	BFUNC_ByteInd                 ; "?"        ($0095)
	.word	BFUNC_Xor                     ; "^"        ($0096)
	.word	COMMAND_Assert                ; "assert"   ($0097)
	.word	UNARY_Abs                     ; "abs"      ($0098)
	.word	COMMAND_Clear                 ; "clear"    ($0099)
	.word	UNARY_Ch                      ; "ch"       ($009a)
	.word	SyntaxError                   ; "do"       ($009b)
	.word	COMMAND_End                   ; "end"      ($009c)
	.word	SyntaxError                   ; "for"      ($009d)
	.word	SyntaxError                   ; "gosub"    ($009e)
	.word	SyntaxError                   ; "goto"     ($009f)
	.word	SyntaxError                   ; "input"    ($00a0)
	.word	SyntaxError                   ; "if"       ($00a1)
	.word	COMMAND_List                  ; "list"     ($00a2)
	.word	SyntaxError                   ; "loop"     ($00a3)
	.word	SyntaxError                   ; "link"     ($00a4)
	.word	COMMAND_Let                   ; "let"      ($00a5)
	.word	UNARY_Len                     ; "len"      ($00a6)
	.word	SyntaxError                   ; "next"     ($00a7)
	.word	COMMAND_New                   ; "new"      ($00a8)
	.word	COMMAND_Old                   ; "old"      ($00a9)
	.word	COMMAND_Print                 ; "print"    ($00aa)
	.word	COMMAND_Rem                   ; "rem"      ($00ab)
	.word	COMMAND_Run                   ; "run"      ($00ac)
	.word	UNARY_Rnd                     ; "rnd"      ($00ad)
	.word	COMMAND_Stop                  ; "stop"     ($00ae)
	.word	SyntaxError                   ; "step"     ($00af)
	.word	SyntaxError                   ; "then"     ($00b0)
	.word	UNARY_Top                     ; "top"      ($00b1)
	.word	SyntaxError                   ; "to"       ($00b2)
	.word	BFUNC_Or                      ; "|"        ($00b3)
	.word	BFUNC_StringCompare           ; "~"        ($00b4)


TokenText:
	.byte $a1                             ; $0080 !
	.byte $a2                             ; $0081 "
	.byte $a3                             ; $0082 #
	.byte $a4                             ; $0083 $
	.byte $a5                             ; $0084 %
	.byte $a6                             ; $0085 &
	.byte $a7                             ; $0086 '
	.byte $a8                             ; $0087 (
	.byte $a9                             ; $0088 )
	.byte $aa                             ; $0089 *
	.byte $ab                             ; $008a +
	.byte $ad                             ; $008b -
	.byte $af                             ; $008c /
	.byte $ba                             ; $008d :
	.byte $bb                             ; $008e ;
	.byte $3c,$bd                         ; $008f <=
	.byte $3c,$be                         ; $0090 <>
	.byte $bc                             ; $0091 <
	.byte $bd                             ; $0092 =
	.byte $3e,$bd                         ; $0093 >=
	.byte $be                             ; $0094 >
	.byte $bf                             ; $0095 ?
	.byte $de                             ; $0096 ^
	.byte $41,$53,$53,$45,$52,$d4         ; $0097 assert
	.byte $41,$42,$d3                     ; $0098 abs
	.byte $43,$4c,$45,$41,$d2             ; $0099 clear
	.byte $43,$c8                         ; $009a ch
	.byte $44,$cf                         ; $009b do
	.byte $45,$4e,$c4                     ; $009c end
	.byte $46,$4f,$d2                     ; $009d for
	.byte $47,$4f,$53,$55,$c2             ; $009e gosub
	.byte $47,$4f,$54,$cf                 ; $009f goto
	.byte $49,$4e,$50,$55,$d4             ; $00a0 input
	.byte $49,$c6                         ; $00a1 if
	.byte $4c,$49,$53,$d4                 ; $00a2 list
	.byte $4c,$4f,$4f,$d0                 ; $00a3 loop
	.byte $4c,$49,$4e,$cb                 ; $00a4 link
	.byte $4c,$45,$d4                     ; $00a5 let
	.byte $4c,$45,$ce                     ; $00a6 len
	.byte $4e,$45,$58,$d4                 ; $00a7 next
	.byte $4e,$45,$d7                     ; $00a8 new
	.byte $4f,$4c,$c4                     ; $00a9 old
	.byte $50,$52,$49,$4e,$d4             ; $00aa print
	.byte $52,$45,$cd                     ; $00ab rem
	.byte $52,$55,$ce                     ; $00ac run
	.byte $52,$4e,$c4                     ; $00ad rnd
	.byte $53,$54,$4f,$d0                 ; $00ae stop
	.byte $53,$54,$45,$d0                 ; $00af step
	.byte $54,$48,$45,$ce                 ; $00b0 then
	.byte $54,$4f,$d0                     ; $00b1 top
	.byte $54,$cf                         ; $00b2 to
	.byte $fc                             ; $00b3 |
	.byte $fe                             ; $00b4 ~
	.byte $00

TokenTypeInformation:
	.byte $04                             ; $0080 !
	.byte $0a                             ; $0081 "
	.byte $0a                             ; $0082 #
	.byte $04                             ; $0083 $
	.byte $03                             ; $0084 %
	.byte $00                             ; $0085 &
	.byte $0a                             ; $0086 '
	.byte $0a                             ; $0087 (
	.byte $0a                             ; $0088 )
	.byte $03                             ; $0089 *
	.byte $02                             ; $008a +
	.byte $02                             ; $008b -
	.byte $03                             ; $008c /
	.byte $0a                             ; $008d :
	.byte $0a                             ; $008e ;
	.byte $01                             ; $008f <=
	.byte $01                             ; $0090 <>
	.byte $01                             ; $0091 <
	.byte $01                             ; $0092 =
	.byte $01                             ; $0093 >=
	.byte $01                             ; $0094 >
	.byte $04                             ; $0095 ?
	.byte $00                             ; $0096 ^
	.byte $04                             ; $0097 assert
	.byte $09                             ; $0098 abs
	.byte $04                             ; $0099 clear
	.byte $09                             ; $009a ch
	.byte $04                             ; $009b do
	.byte $04                             ; $009c end
	.byte $04                             ; $009d for
	.byte $04                             ; $009e gosub
	.byte $04                             ; $009f goto
	.byte $04                             ; $00a0 input
	.byte $04                             ; $00a1 if
	.byte $04                             ; $00a2 list
	.byte $04                             ; $00a3 loop
	.byte $04                             ; $00a4 link
	.byte $04                             ; $00a5 let
	.byte $09                             ; $00a6 len
	.byte $04                             ; $00a7 next
	.byte $04                             ; $00a8 new
	.byte $04                             ; $00a9 old
	.byte $04                             ; $00aa print
	.byte $04                             ; $00ab rem
	.byte $04                             ; $00ac run
	.byte $09                             ; $00ad rnd
	.byte $04                             ; $00ae stop
	.byte $04                             ; $00af step
	.byte $04                             ; $00b0 then
	.byte $09                             ; $00b1 top
	.byte $04                             ; $00b2 to
	.byte $00                             ; $00b3 |
	.byte $01                             ; $00b4 ~


KTYPE_PRECBASE = $00
KTYPE_COMMAND = $08
KTYPE_UNARYFN = $09
KTYPE_SYNTAX = $0a

KW_PLING = $0080
KW_DQUOTE = $0081
KW_HASH = $0082
KW_DOLLAR = $0083
KW_PERCENT = $0084
KW_AMPERSAND = $0085
KW_SQUOTE = $0086
KW_LPAREN = $0087
KW_RPAREN = $0088
KW_STAR = $0089
KW_PLUS = $008a
KW_MINUS = $008b
KW_FSLASH = $008c
KW_COLON = $008d
KW_SEMICOLON = $008e
KW_LESSEQUAL = $008f
KW_LESSGREATER = $0090
KW_LESS = $0091
KW_EQUAL = $0092
KW_GREATEREQUAL = $0093
KW_GREATER = $0094
KW_QUESTION = $0095
KW_HAT = $0096
KW_ASSERT = $0097
KW_ABS = $0098
KW_CLEAR = $0099
KW_CH = $009a
KW_DO = $009b
KW_END = $009c
KW_FOR = $009d
KW_GOSUB = $009e
KW_GOTO = $009f
KW_INPUT = $00a0
KW_IF = $00a1
KW_LIST = $00a2
KW_LOOP = $00a3
KW_LINK = $00a4
KW_LET = $00a5
KW_LEN = $00a6
KW_NEXT = $00a7
KW_NEW = $00a8
KW_OLD = $00a9
KW_PRINT = $00aa
KW_REM = $00ab
KW_RUN = $00ac
KW_RND = $00ad
KW_STOP = $00ae
KW_STEP = $00af
KW_THEN = $00b0
KW_TOP = $00b1
KW_TO = $00b2
KW_BAR = $00b3
KW_TILDE = $00b4

