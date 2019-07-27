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
	.word	SyntaxError                   ; "list"     ($00a2)
	.word	SyntaxError                   ; "loop"     ($00a3)
	.word	SyntaxError                   ; "link"     ($00a4)
	.word	COMMAND_Let                   ; "let"      ($00a5)
	.word	UNARY_Len                     ; "len"      ($00a6)
	.word	SyntaxError                   ; "next"     ($00a7)
	.word	COMMAND_New                   ; "new"      ($00a8)
	.word	COMMAND_Old                   ; "old"      ($00a9)
	.word	SyntaxError                   ; "print"    ($00aa)
	.word	COMMAND_Rem                   ; "rem"      ($00ab)
	.word	UNARY_Rnd                     ; "rnd"      ($00ac)
	.word	COMMAND_Stop                  ; "stop"     ($00ad)
	.word	SyntaxError                   ; "step"     ($00ae)
	.word	SyntaxError                   ; "then"     ($00af)
	.word	UNARY_Top                     ; "top"      ($00b0)
	.word	SyntaxError                   ; "to"       ($00b1)
	.word	BFUNC_Or                      ; "|"        ($00b2)
	.word	BFUNC_StringCompare           ; "~"        ($00b3)


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
	.byte $61,$73,$73,$65,$72,$f4         ; $0097 assert
	.byte $61,$62,$f3                     ; $0098 abs
	.byte $63,$6c,$65,$61,$f2             ; $0099 clear
	.byte $63,$e8                         ; $009a ch
	.byte $64,$ef                         ; $009b do
	.byte $65,$6e,$e4                     ; $009c end
	.byte $66,$6f,$f2                     ; $009d for
	.byte $67,$6f,$73,$75,$e2             ; $009e gosub
	.byte $67,$6f,$74,$ef                 ; $009f goto
	.byte $69,$6e,$70,$75,$f4             ; $00a0 input
	.byte $69,$e6                         ; $00a1 if
	.byte $6c,$69,$73,$f4                 ; $00a2 list
	.byte $6c,$6f,$6f,$f0                 ; $00a3 loop
	.byte $6c,$69,$6e,$eb                 ; $00a4 link
	.byte $6c,$65,$f4                     ; $00a5 let
	.byte $6c,$65,$ee                     ; $00a6 len
	.byte $6e,$65,$78,$f4                 ; $00a7 next
	.byte $6e,$65,$f7                     ; $00a8 new
	.byte $6f,$6c,$e4                     ; $00a9 old
	.byte $70,$72,$69,$6e,$f4             ; $00aa print
	.byte $72,$65,$ed                     ; $00ab rem
	.byte $72,$6e,$e4                     ; $00ac rnd
	.byte $73,$74,$6f,$f0                 ; $00ad stop
	.byte $73,$74,$65,$f0                 ; $00ae step
	.byte $74,$68,$65,$ee                 ; $00af then
	.byte $74,$6f,$f0                     ; $00b0 top
	.byte $74,$ef                         ; $00b1 to
	.byte $fc                             ; $00b2 |
	.byte $fe                             ; $00b3 ~
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
	.byte $09                             ; $00ac rnd
	.byte $04                             ; $00ad stop
	.byte $04                             ; $00ae step
	.byte $04                             ; $00af then
	.byte $09                             ; $00b0 top
	.byte $04                             ; $00b1 to
	.byte $00                             ; $00b2 |
	.byte $01                             ; $00b3 ~


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
KW_RND = $00ac
KW_STOP = $00ad
KW_STEP = $00ae
KW_THEN = $00af
KW_TOP = $00b0
KW_TO = $00b1
KW_BAR = $00b2
KW_TILDE = $00b3

