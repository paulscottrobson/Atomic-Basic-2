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
	.word	COMMAND_CLS                   ; "cls"      ($009a)
	.word	UNARY_Ch                      ; "ch"       ($009b)
	.word	COMMAND_Do                    ; "do"       ($009c)
	.word	COMMAND_End                   ; "end"      ($009d)
	.word	SyntaxError                   ; "for"      ($009e)
	.word	COMMAND_Gosub                 ; "gosub"    ($009f)
	.word	COMMAND_Goto                  ; "goto"     ($00a0)
	.word	UNARY_Get                     ; "get"      ($00a1)
	.word	UNARY_IOAddr                  ; "ioaddr"   ($00a2)
	.word	SyntaxError                   ; "input"    ($00a3)
	.word	SyntaxError                   ; "if"       ($00a4)
	.word	COMMAND_List                  ; "list"     ($00a5)
	.word	SyntaxError                   ; "link"     ($00a6)
	.word	COMMAND_Let                   ; "let"      ($00a7)
	.word	UNARY_Len                     ; "len"      ($00a8)
	.word	SyntaxError                   ; "next"     ($00a9)
	.word	COMMAND_NewExec               ; "new"      ($00aa)
	.word	COMMAND_OldExec               ; "old"      ($00ab)
	.word	COMMAND_Print                 ; "print"    ($00ac)
	.word	UNARY_Page                    ; "page"     ($00ad)
	.word	COMMAND_Return                ; "return"   ($00ae)
	.word	COMMAND_Rem                   ; "rem"      ($00af)
	.word	COMMAND_Run                   ; "run"      ($00b0)
	.word	UNARY_Rnd                     ; "rnd"      ($00b1)
	.word	COMMAND_Stop                  ; "stop"     ($00b2)
	.word	SyntaxError                   ; "step"     ($00b3)
	.word	SyntaxError                   ; "then"     ($00b4)
	.word	UNARY_Top                     ; "top"      ($00b5)
	.word	SyntaxError                   ; "to"       ($00b6)
	.word	COMMAND_Until                 ; "until"    ($00b7)
	.word	BFUNC_Or                      ; "|"        ($00b8)
	.word	BFUNC_StringCompare           ; "~"        ($00b9)


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
	.byte $43,$4c,$d3                     ; $009a cls
	.byte $43,$c8                         ; $009b ch
	.byte $44,$cf                         ; $009c do
	.byte $45,$4e,$c4                     ; $009d end
	.byte $46,$4f,$d2                     ; $009e for
	.byte $47,$4f,$53,$55,$c2             ; $009f gosub
	.byte $47,$4f,$54,$cf                 ; $00a0 goto
	.byte $47,$45,$d4                     ; $00a1 get
	.byte $49,$4f,$41,$44,$44,$d2         ; $00a2 ioaddr
	.byte $49,$4e,$50,$55,$d4             ; $00a3 input
	.byte $49,$c6                         ; $00a4 if
	.byte $4c,$49,$53,$d4                 ; $00a5 list
	.byte $4c,$49,$4e,$cb                 ; $00a6 link
	.byte $4c,$45,$d4                     ; $00a7 let
	.byte $4c,$45,$ce                     ; $00a8 len
	.byte $4e,$45,$58,$d4                 ; $00a9 next
	.byte $4e,$45,$d7                     ; $00aa new
	.byte $4f,$4c,$c4                     ; $00ab old
	.byte $50,$52,$49,$4e,$d4             ; $00ac print
	.byte $50,$41,$47,$c5                 ; $00ad page
	.byte $52,$45,$54,$55,$52,$ce         ; $00ae return
	.byte $52,$45,$cd                     ; $00af rem
	.byte $52,$55,$ce                     ; $00b0 run
	.byte $52,$4e,$c4                     ; $00b1 rnd
	.byte $53,$54,$4f,$d0                 ; $00b2 stop
	.byte $53,$54,$45,$d0                 ; $00b3 step
	.byte $54,$48,$45,$ce                 ; $00b4 then
	.byte $54,$4f,$d0                     ; $00b5 top
	.byte $54,$cf                         ; $00b6 to
	.byte $55,$4e,$54,$49,$cc             ; $00b7 until
	.byte $fc                             ; $00b8 |
	.byte $fe                             ; $00b9 ~
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
	.byte $04                             ; $009a cls
	.byte $09                             ; $009b ch
	.byte $04                             ; $009c do
	.byte $04                             ; $009d end
	.byte $04                             ; $009e for
	.byte $04                             ; $009f gosub
	.byte $04                             ; $00a0 goto
	.byte $09                             ; $00a1 get
	.byte $09                             ; $00a2 ioaddr
	.byte $04                             ; $00a3 input
	.byte $04                             ; $00a4 if
	.byte $04                             ; $00a5 list
	.byte $04                             ; $00a6 link
	.byte $04                             ; $00a7 let
	.byte $09                             ; $00a8 len
	.byte $04                             ; $00a9 next
	.byte $04                             ; $00aa new
	.byte $04                             ; $00ab old
	.byte $04                             ; $00ac print
	.byte $09                             ; $00ad page
	.byte $04                             ; $00ae return
	.byte $04                             ; $00af rem
	.byte $04                             ; $00b0 run
	.byte $09                             ; $00b1 rnd
	.byte $04                             ; $00b2 stop
	.byte $04                             ; $00b3 step
	.byte $04                             ; $00b4 then
	.byte $09                             ; $00b5 top
	.byte $04                             ; $00b6 to
	.byte $04                             ; $00b7 until
	.byte $00                             ; $00b8 |
	.byte $01                             ; $00b9 ~


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
KW_CLS = $009a
KW_CH = $009b
KW_DO = $009c
KW_END = $009d
KW_FOR = $009e
KW_GOSUB = $009f
KW_GOTO = $00a0
KW_GET = $00a1
KW_IOADDR = $00a2
KW_INPUT = $00a3
KW_IF = $00a4
KW_LIST = $00a5
KW_LINK = $00a6
KW_LET = $00a7
KW_LEN = $00a8
KW_NEXT = $00a9
KW_NEW = $00aa
KW_OLD = $00ab
KW_PRINT = $00ac
KW_PAGE = $00ad
KW_RETURN = $00ae
KW_REM = $00af
KW_RUN = $00b0
KW_RND = $00b1
KW_STOP = $00b2
KW_STEP = $00b3
KW_THEN = $00b4
KW_TOP = $00b5
KW_TO = $00b6
KW_UNTIL = $00b7
KW_BAR = $00b8
KW_TILDE = $00b9

