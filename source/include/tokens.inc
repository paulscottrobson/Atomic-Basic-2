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
	.word	UNARY_CPU                     ; "cpu"      ($009c)
	.word	UNARY_Ch                      ; "ch"       ($009d)
	.word	COMMAND_Dim                   ; "dim"      ($009e)
	.word	COMMAND_Do                    ; "do"       ($009f)
	.word	COMMAND_ELSE                  ; "else"     ($00a0)
	.word	COMMAND_End                   ; "end"      ($00a1)
	.word	SyntaxError                   ; "for"      ($00a2)
	.word	COMMAND_Gosub                 ; "gosub"    ($00a3)
	.word	COMMAND_Goto                  ; "goto"     ($00a4)
	.word	UNARY_Get                     ; "get"      ($00a5)
	.word	UNARY_IOAddr                  ; "ioaddr"   ($00a6)
	.word	SyntaxError                   ; "input"    ($00a7)
	.word	COMMAND_IF                    ; "if"       ($00a8)
	.word	COMMAND_List                  ; "list"     ($00a9)
	.word	SyntaxError                   ; "link"     ($00aa)
	.word	COMMAND_Let                   ; "let"      ($00ab)
	.word	UNARY_Len                     ; "len"      ($00ac)
	.word	SyntaxError                   ; "next"     ($00ad)
	.word	COMMAND_NewExec               ; "new"      ($00ae)
	.word	COMMAND_OldExec               ; "old"      ($00af)
	.word	COMMAND_Print                 ; "print"    ($00b0)
	.word	UNARY_Page                    ; "page"     ($00b1)
	.word	COMMAND_Return                ; "return"   ($00b2)
	.word	COMMAND_Rem                   ; "rem"      ($00b3)
	.word	COMMAND_Run                   ; "run"      ($00b4)
	.word	COMMAND_RST                   ; "rst"      ($00b5)
	.word	UNARY_Rnd                     ; "rnd"      ($00b6)
	.word	COMMAND_Stop                  ; "stop"     ($00b7)
	.word	SyntaxError                   ; "step"     ($00b8)
	.word	COMMAND_THEN                  ; "then"     ($00b9)
	.word	UNARY_Top                     ; "top"      ($00ba)
	.word	SyntaxError                   ; "to"       ($00bb)
	.word	COMMAND_Until                 ; "until"    ($00bc)
	.word	BFUNC_Or                      ; "|"        ($00bd)
	.word	BFUNC_StringCompare           ; "~"        ($00be)


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
	.byte $43,$50,$d5                     ; $009c cpu
	.byte $43,$c8                         ; $009d ch
	.byte $44,$49,$cd                     ; $009e dim
	.byte $44,$cf                         ; $009f do
	.byte $45,$4c,$53,$c5                 ; $00a0 else
	.byte $45,$4e,$c4                     ; $00a1 end
	.byte $46,$4f,$d2                     ; $00a2 for
	.byte $47,$4f,$53,$55,$c2             ; $00a3 gosub
	.byte $47,$4f,$54,$cf                 ; $00a4 goto
	.byte $47,$45,$d4                     ; $00a5 get
	.byte $49,$4f,$41,$44,$44,$d2         ; $00a6 ioaddr
	.byte $49,$4e,$50,$55,$d4             ; $00a7 input
	.byte $49,$c6                         ; $00a8 if
	.byte $4c,$49,$53,$d4                 ; $00a9 list
	.byte $4c,$49,$4e,$cb                 ; $00aa link
	.byte $4c,$45,$d4                     ; $00ab let
	.byte $4c,$45,$ce                     ; $00ac len
	.byte $4e,$45,$58,$d4                 ; $00ad next
	.byte $4e,$45,$d7                     ; $00ae new
	.byte $4f,$4c,$c4                     ; $00af old
	.byte $50,$52,$49,$4e,$d4             ; $00b0 print
	.byte $50,$41,$47,$c5                 ; $00b1 page
	.byte $52,$45,$54,$55,$52,$ce         ; $00b2 return
	.byte $52,$45,$cd                     ; $00b3 rem
	.byte $52,$55,$ce                     ; $00b4 run
	.byte $52,$53,$d4                     ; $00b5 rst
	.byte $52,$4e,$c4                     ; $00b6 rnd
	.byte $53,$54,$4f,$d0                 ; $00b7 stop
	.byte $53,$54,$45,$d0                 ; $00b8 step
	.byte $54,$48,$45,$ce                 ; $00b9 then
	.byte $54,$4f,$d0                     ; $00ba top
	.byte $54,$cf                         ; $00bb to
	.byte $55,$4e,$54,$49,$cc             ; $00bc until
	.byte $fc                             ; $00bd |
	.byte $fe                             ; $00be ~
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
	.byte $09                             ; $009c cpu
	.byte $09                             ; $009d ch
	.byte $08                             ; $009e dim
	.byte $08                             ; $009f do
	.byte $08                             ; $00a0 else
	.byte $08                             ; $00a1 end
	.byte $08                             ; $00a2 for
	.byte $08                             ; $00a3 gosub
	.byte $08                             ; $00a4 goto
	.byte $09                             ; $00a5 get
	.byte $09                             ; $00a6 ioaddr
	.byte $08                             ; $00a7 input
	.byte $08                             ; $00a8 if
	.byte $08                             ; $00a9 list
	.byte $08                             ; $00aa link
	.byte $08                             ; $00ab let
	.byte $09                             ; $00ac len
	.byte $08                             ; $00ad next
	.byte $08                             ; $00ae new
	.byte $08                             ; $00af old
	.byte $08                             ; $00b0 print
	.byte $09                             ; $00b1 page
	.byte $08                             ; $00b2 return
	.byte $08                             ; $00b3 rem
	.byte $08                             ; $00b4 run
	.byte $08                             ; $00b5 rst
	.byte $09                             ; $00b6 rnd
	.byte $08                             ; $00b7 stop
	.byte $08                             ; $00b8 step
	.byte $08                             ; $00b9 then
	.byte $09                             ; $00ba top
	.byte $08                             ; $00bb to
	.byte $08                             ; $00bc until
	.byte $00                             ; $00bd |
	.byte $01                             ; $00be ~


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
KW_CPU = $009c
KW_CH = $009d
KW_DIM = $009e
KW_DO = $009f
KW_ELSE = $00a0
KW_END = $00a1
KW_FOR = $00a2
KW_GOSUB = $00a3
KW_GOTO = $00a4
KW_GET = $00a5
KW_IOADDR = $00a6
KW_INPUT = $00a7
KW_IF = $00a8
KW_LIST = $00a9
KW_LINK = $00aa
KW_LET = $00ab
KW_LEN = $00ac
KW_NEXT = $00ad
KW_NEW = $00ae
KW_OLD = $00af
KW_PRINT = $00b0
KW_PAGE = $00b1
KW_RETURN = $00b2
KW_REM = $00b3
KW_RUN = $00b4
KW_RST = $00b5
KW_RND = $00b6
KW_STOP = $00b7
KW_STEP = $00b8
KW_THEN = $00b9
KW_TOP = $00ba
KW_TO = $00bb
KW_UNTIL = $00bc
KW_BAR = $00bd
KW_TILDE = $00be

