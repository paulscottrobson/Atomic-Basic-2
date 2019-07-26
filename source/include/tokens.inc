KeywordVectorTable:
	.word	SyntaxError                   ; "!"        ($0080)
	.word	SyntaxError                   ; """        ($0081)
	.word	SyntaxError                   ; "#"        ($0082)
	.word	SyntaxError                   ; "$"        ($0083)
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
	.word	SyntaxError                   ; "?"        ($0095)
	.word	BFUNC_Xor                     ; "^"        ($0096)
	.word	SyntaxError                   ; "assert"   ($0097)
	.word	SyntaxError                   ; "abs"      ($0098)
	.word	SyntaxError                   ; "clear"    ($0099)
	.word	SyntaxError                   ; "ch"       ($009a)
	.word	SyntaxError                   ; "do"       ($009b)
	.word	SyntaxError                   ; "else"     ($009c)
	.word	SyntaxError                   ; "end"      ($009d)
	.word	SyntaxError                   ; "for"      ($009e)
	.word	SyntaxError                   ; "gosub"    ($009f)
	.word	SyntaxError                   ; "goto"     ($00a0)
	.word	SyntaxError                   ; "input"    ($00a1)
	.word	SyntaxError                   ; "if"       ($00a2)
	.word	SyntaxError                   ; "local"    ($00a3)
	.word	SyntaxError                   ; "list"     ($00a4)
	.word	SyntaxError                   ; "loop"     ($00a5)
	.word	SyntaxError                   ; "link"     ($00a6)
	.word	SyntaxError                   ; "let"      ($00a7)
	.word	SyntaxError                   ; "len"      ($00a8)
	.word	SyntaxError                   ; "next"     ($00a9)
	.word	SyntaxError                   ; "new"      ($00aa)
	.word	SyntaxError                   ; "old"      ($00ab)
	.word	SyntaxError                   ; "print"    ($00ac)
	.word	SyntaxError                   ; "rem"      ($00ad)
	.word	SyntaxError                   ; "rnd"      ($00ae)
	.word	SyntaxError                   ; "stop"     ($00af)
	.word	SyntaxError                   ; "step"     ($00b0)
	.word	SyntaxError                   ; "then"     ($00b1)
	.word	SyntaxError                   ; "top"      ($00b2)
	.word	SyntaxError                   ; "to"       ($00b3)
	.word	BFUNC_Or                      ; "|"        ($00b4)
	.word	BFUNC_StringCompare           ; "~"        ($00b5)


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
	.byte $65,$6c,$73,$e5                 ; $009c else
	.byte $65,$6e,$e4                     ; $009d end
	.byte $66,$6f,$f2                     ; $009e for
	.byte $67,$6f,$73,$75,$e2             ; $009f gosub
	.byte $67,$6f,$74,$ef                 ; $00a0 goto
	.byte $69,$6e,$70,$75,$f4             ; $00a1 input
	.byte $69,$e6                         ; $00a2 if
	.byte $6c,$6f,$63,$61,$ec             ; $00a3 local
	.byte $6c,$69,$73,$f4                 ; $00a4 list
	.byte $6c,$6f,$6f,$f0                 ; $00a5 loop
	.byte $6c,$69,$6e,$eb                 ; $00a6 link
	.byte $6c,$65,$f4                     ; $00a7 let
	.byte $6c,$65,$ee                     ; $00a8 len
	.byte $6e,$65,$78,$f4                 ; $00a9 next
	.byte $6e,$65,$f7                     ; $00aa new
	.byte $6f,$6c,$e4                     ; $00ab old
	.byte $70,$72,$69,$6e,$f4             ; $00ac print
	.byte $72,$65,$ed                     ; $00ad rem
	.byte $72,$6e,$e4                     ; $00ae rnd
	.byte $73,$74,$6f,$f0                 ; $00af stop
	.byte $73,$74,$65,$f0                 ; $00b0 step
	.byte $74,$68,$65,$ee                 ; $00b1 then
	.byte $74,$6f,$f0                     ; $00b2 top
	.byte $74,$ef                         ; $00b3 to
	.byte $fc                             ; $00b4 |
	.byte $fe                             ; $00b5 ~
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
	.byte $04                             ; $009c else
	.byte $04                             ; $009d end
	.byte $04                             ; $009e for
	.byte $04                             ; $009f gosub
	.byte $04                             ; $00a0 goto
	.byte $04                             ; $00a1 input
	.byte $04                             ; $00a2 if
	.byte $04                             ; $00a3 local
	.byte $04                             ; $00a4 list
	.byte $04                             ; $00a5 loop
	.byte $04                             ; $00a6 link
	.byte $04                             ; $00a7 let
	.byte $09                             ; $00a8 len
	.byte $04                             ; $00a9 next
	.byte $04                             ; $00aa new
	.byte $04                             ; $00ab old
	.byte $04                             ; $00ac print
	.byte $04                             ; $00ad rem
	.byte $09                             ; $00ae rnd
	.byte $04                             ; $00af stop
	.byte $04                             ; $00b0 step
	.byte $04                             ; $00b1 then
	.byte $09                             ; $00b2 top
	.byte $04                             ; $00b3 to
	.byte $00                             ; $00b4 |
	.byte $01                             ; $00b5 ~


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
KW_ELSE = $009c
KW_END = $009d
KW_FOR = $009e
KW_GOSUB = $009f
KW_GOTO = $00a0
KW_INPUT = $00a1
KW_IF = $00a2
KW_LOCAL = $00a3
KW_LIST = $00a4
KW_LOOP = $00a5
KW_LINK = $00a6
KW_LET = $00a7
KW_LEN = $00a8
KW_NEXT = $00a9
KW_NEW = $00aa
KW_OLD = $00ab
KW_PRINT = $00ac
KW_REM = $00ad
KW_RND = $00ae
KW_STOP = $00af
KW_STEP = $00b0
KW_THEN = $00b1
KW_TOP = $00b2
KW_TO = $00b3
KW_BAR = $00b4
KW_TILDE = $00b5

