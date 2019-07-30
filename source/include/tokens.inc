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
	.word	SyntaxError                   ; ","        ($008b)
	.word	BFUNC_Subtract                ; "-"        ($008c)
	.word	BFUNC_Divide                  ; "/"        ($008d)
	.word	SyntaxError                   ; ":"        ($008e)
	.word	SyntaxError                   ; ";"        ($008f)
	.word	BFUNC_LessEqual               ; "<="       ($0090)
	.word	BFUNC_NotEquals               ; "<>"       ($0091)
	.word	BFUNC_Less                    ; "<"        ($0092)
	.word	BFUNC_Equals                  ; "="        ($0093)
	.word	BFUNC_GreaterEqual            ; ">="       ($0094)
	.word	BFUNC_Greater                 ; ">"        ($0095)
	.word	BFUNC_ByteInd                 ; "?"        ($0096)
	.word	BFUNC_Xor                     ; "^"        ($0097)
	.word	COMMAND_Assert                ; "assert"   ($0098)
	.word	UNARY_Abs                     ; "abs"      ($0099)
	.word	COMMAND_Clear                 ; "clear"    ($009a)
	.word	COMMAND_CLS                   ; "cls"      ($009b)
	.word	UNARY_Ch                      ; "ch"       ($009c)
	.word	COMMAND_Dim                   ; "dim"      ($009d)
	.word	COMMAND_Do                    ; "do"       ($009e)
	.word	COMMAND_ELSE                  ; "else"     ($009f)
	.word	COMMAND_End                   ; "end"      ($00a0)
	.word	SyntaxError                   ; "for"      ($00a1)
	.word	COMMAND_Gosub                 ; "gosub"    ($00a2)
	.word	COMMAND_Goto                  ; "goto"     ($00a3)
	.word	UNARY_Get                     ; "get"      ($00a4)
	.word	UNARY_IOAddr                  ; "ioaddr"   ($00a5)
	.word	SyntaxError                   ; "input"    ($00a6)
	.word	COMMAND_IF                    ; "if"       ($00a7)
	.word	COMMAND_List                  ; "list"     ($00a8)
	.word	SyntaxError                   ; "link"     ($00a9)
	.word	COMMAND_Let                   ; "let"      ($00aa)
	.word	UNARY_Len                     ; "len"      ($00ab)
	.word	SyntaxError                   ; "next"     ($00ac)
	.word	COMMAND_NewExec               ; "new"      ($00ad)
	.word	COMMAND_OldExec               ; "old"      ($00ae)
	.word	COMMAND_Print                 ; "print"    ($00af)
	.word	UNARY_Page                    ; "page"     ($00b0)
	.word	COMMAND_Return                ; "return"   ($00b1)
	.word	COMMAND_Rem                   ; "rem"      ($00b2)
	.word	COMMAND_Run                   ; "run"      ($00b3)
	.word	COMMAND_RST                   ; "rst"      ($00b4)
	.word	UNARY_Rnd                     ; "rnd"      ($00b5)
	.word	COMMAND_Stop                  ; "stop"     ($00b6)
	.word	SyntaxError                   ; "step"     ($00b7)
	.word	COMMAND_THEN                  ; "then"     ($00b8)
	.word	UNARY_Top                     ; "top"      ($00b9)
	.word	SyntaxError                   ; "to"       ($00ba)
	.word	COMMAND_Until                 ; "until"    ($00bb)
	.word	BFUNC_Or                      ; "|"        ($00bc)
	.word	BFUNC_StringCompare           ; "~"        ($00bd)


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
	.byte $ac                             ; $008b ,
	.byte $ad                             ; $008c -
	.byte $af                             ; $008d /
	.byte $ba                             ; $008e :
	.byte $bb                             ; $008f ;
	.byte $3c,$bd                         ; $0090 <=
	.byte $3c,$be                         ; $0091 <>
	.byte $bc                             ; $0092 <
	.byte $bd                             ; $0093 =
	.byte $3e,$bd                         ; $0094 >=
	.byte $be                             ; $0095 >
	.byte $bf                             ; $0096 ?
	.byte $de                             ; $0097 ^
	.byte $41,$53,$53,$45,$52,$d4         ; $0098 assert
	.byte $41,$42,$d3                     ; $0099 abs
	.byte $43,$4c,$45,$41,$d2             ; $009a clear
	.byte $43,$4c,$d3                     ; $009b cls
	.byte $43,$c8                         ; $009c ch
	.byte $44,$49,$cd                     ; $009d dim
	.byte $44,$cf                         ; $009e do
	.byte $45,$4c,$53,$c5                 ; $009f else
	.byte $45,$4e,$c4                     ; $00a0 end
	.byte $46,$4f,$d2                     ; $00a1 for
	.byte $47,$4f,$53,$55,$c2             ; $00a2 gosub
	.byte $47,$4f,$54,$cf                 ; $00a3 goto
	.byte $47,$45,$d4                     ; $00a4 get
	.byte $49,$4f,$41,$44,$44,$d2         ; $00a5 ioaddr
	.byte $49,$4e,$50,$55,$d4             ; $00a6 input
	.byte $49,$c6                         ; $00a7 if
	.byte $4c,$49,$53,$d4                 ; $00a8 list
	.byte $4c,$49,$4e,$cb                 ; $00a9 link
	.byte $4c,$45,$d4                     ; $00aa let
	.byte $4c,$45,$ce                     ; $00ab len
	.byte $4e,$45,$58,$d4                 ; $00ac next
	.byte $4e,$45,$d7                     ; $00ad new
	.byte $4f,$4c,$c4                     ; $00ae old
	.byte $50,$52,$49,$4e,$d4             ; $00af print
	.byte $50,$41,$47,$c5                 ; $00b0 page
	.byte $52,$45,$54,$55,$52,$ce         ; $00b1 return
	.byte $52,$45,$cd                     ; $00b2 rem
	.byte $52,$55,$ce                     ; $00b3 run
	.byte $52,$53,$d4                     ; $00b4 rst
	.byte $52,$4e,$c4                     ; $00b5 rnd
	.byte $53,$54,$4f,$d0                 ; $00b6 stop
	.byte $53,$54,$45,$d0                 ; $00b7 step
	.byte $54,$48,$45,$ce                 ; $00b8 then
	.byte $54,$4f,$d0                     ; $00b9 top
	.byte $54,$cf                         ; $00ba to
	.byte $55,$4e,$54,$49,$cc             ; $00bb until
	.byte $fc                             ; $00bc |
	.byte $fe                             ; $00bd ~
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
	.byte $0a                             ; $008b ,
	.byte $02                             ; $008c -
	.byte $03                             ; $008d /
	.byte $0a                             ; $008e :
	.byte $0a                             ; $008f ;
	.byte $01                             ; $0090 <=
	.byte $01                             ; $0091 <>
	.byte $01                             ; $0092 <
	.byte $01                             ; $0093 =
	.byte $01                             ; $0094 >=
	.byte $01                             ; $0095 >
	.byte $04                             ; $0096 ?
	.byte $00                             ; $0097 ^
	.byte $08                             ; $0098 assert
	.byte $09                             ; $0099 abs
	.byte $08                             ; $009a clear
	.byte $08                             ; $009b cls
	.byte $09                             ; $009c ch
	.byte $08                             ; $009d dim
	.byte $08                             ; $009e do
	.byte $08                             ; $009f else
	.byte $08                             ; $00a0 end
	.byte $08                             ; $00a1 for
	.byte $08                             ; $00a2 gosub
	.byte $08                             ; $00a3 goto
	.byte $09                             ; $00a4 get
	.byte $09                             ; $00a5 ioaddr
	.byte $08                             ; $00a6 input
	.byte $08                             ; $00a7 if
	.byte $08                             ; $00a8 list
	.byte $08                             ; $00a9 link
	.byte $08                             ; $00aa let
	.byte $09                             ; $00ab len
	.byte $08                             ; $00ac next
	.byte $08                             ; $00ad new
	.byte $08                             ; $00ae old
	.byte $08                             ; $00af print
	.byte $09                             ; $00b0 page
	.byte $08                             ; $00b1 return
	.byte $08                             ; $00b2 rem
	.byte $08                             ; $00b3 run
	.byte $08                             ; $00b4 rst
	.byte $09                             ; $00b5 rnd
	.byte $08                             ; $00b6 stop
	.byte $08                             ; $00b7 step
	.byte $08                             ; $00b8 then
	.byte $09                             ; $00b9 top
	.byte $08                             ; $00ba to
	.byte $08                             ; $00bb until
	.byte $00                             ; $00bc |
	.byte $01                             ; $00bd ~


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
KW_COMMA = $008b
KW_MINUS = $008c
KW_FSLASH = $008d
KW_COLON = $008e
KW_SEMICOLON = $008f
KW_LESSEQUAL = $0090
KW_LESSGREATER = $0091
KW_LESS = $0092
KW_EQUAL = $0093
KW_GREATEREQUAL = $0094
KW_GREATER = $0095
KW_QUESTION = $0096
KW_HAT = $0097
KW_ASSERT = $0098
KW_ABS = $0099
KW_CLEAR = $009a
KW_CLS = $009b
KW_CH = $009c
KW_DIM = $009d
KW_DO = $009e
KW_ELSE = $009f
KW_END = $00a0
KW_FOR = $00a1
KW_GOSUB = $00a2
KW_GOTO = $00a3
KW_GET = $00a4
KW_IOADDR = $00a5
KW_INPUT = $00a6
KW_IF = $00a7
KW_LIST = $00a8
KW_LINK = $00a9
KW_LET = $00aa
KW_LEN = $00ab
KW_NEXT = $00ac
KW_NEW = $00ad
KW_OLD = $00ae
KW_PRINT = $00af
KW_PAGE = $00b0
KW_RETURN = $00b1
KW_REM = $00b2
KW_RUN = $00b3
KW_RST = $00b4
KW_RND = $00b5
KW_STOP = $00b6
KW_STEP = $00b7
KW_THEN = $00b8
KW_TOP = $00b9
KW_TO = $00ba
KW_UNTIL = $00bb
KW_BAR = $00bc
KW_TILDE = $00bd

