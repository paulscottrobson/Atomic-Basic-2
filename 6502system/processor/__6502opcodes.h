case 0x00: /* $00 brk */
	Cycles(7);brkCode();break;
case 0x01: /* $01 ora (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);sValue = zValue = a = a | Read(eac);break;
case 0x02: /* $02 stop */
	Cycles(1);CPUExit();break;
case 0x05: /* $05 ora @1 */
	Cycles(3);eac = Fetch();sValue = zValue = a = a | Read01(eac);break;
case 0x06: /* $06 asl @1 */
	Cycles(5);eac = Fetch(); Write01(eac,aslCode(Read01(eac)));break;
case 0x08: /* $08 php */
	Cycles(3);Push(constructFlagRegister());break;
case 0x09: /* $09 ora #@1 */
	Cycles(2);sValue = zValue = a = a | Fetch();break;
case 0x0a: /* $0a asl a */
	Cycles(2);a = aslCode(a);break;
case 0x0d: /* $0d ora @2 */
	Cycles(4);FetchWord();eac = temp16;sValue = zValue = a = a | Read(eac);break;
case 0x0e: /* $0e asl @2 */
	Cycles(6);FetchWord();eac = temp16; Write(eac,aslCode(Read(eac)));break;
case 0x10: /* $10 bpl @r */
	Cycles(2);Branch((sValue & 0x80) == 0);break;
case 0x11: /* $11 ora (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;sValue = zValue = a = a | Read(eac);break;
case 0x15: /* $15 ora @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;sValue = zValue = a = a | Read01(eac);break;
case 0x16: /* $16 asl @1,x */
	Cycles(6);eac = (Fetch()+x) & 0xFF; Write01(eac,aslCode(Read01(eac)));break;
case 0x18: /* $18 clc */
	Cycles(2);carryFlag = 0;break;
case 0x19: /* $19 ora @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = a | Read(eac);break;
case 0x1a: /* $1a inc */
	Cycles(2);sValue = zValue = a = (a + 1) & 0xFF;break;
case 0x1d: /* $1d ora @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = a | Read(eac);break;
case 0x1e: /* $1e asl @2,x */
	Cycles(6);FetchWord();eac = (temp16+x) & 0xFFFF; Write(eac,aslCode(Read(eac)));break;
case 0x20: /* $20 jsr @2 */
	Cycles(6);FetchWord();eac = temp16;pc--;Push(pc >> 8);Push(pc & 0xFF);pc = eac;break;
case 0x21: /* $21 and (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8); a = a & Read(eac) ; sValue = zValue = a;break;
case 0x24: /* $24 bit @1 */
	Cycles(2);eac = Fetch(); bitCode(Read01(eac));break;
case 0x25: /* $25 and @1 */
	Cycles(3);eac = Fetch(); a = a & Read01(eac) ; sValue = zValue = a;break;
case 0x26: /* $26 rol @1 */
	Cycles(3);eac = Fetch(); Write01(eac,rolCode(Read01(eac)));break;
case 0x28: /* $28 plp */
	Cycles(4);explodeFlagRegister(Pop());break;
case 0x29: /* $29 and #@1 */
	Cycles(2); a = a & Fetch() ; sValue = zValue = a;break;
case 0x2a: /* $2a rol a */
	Cycles(2);a = rolCode(a);break;
case 0x2c: /* $2c bit @2 */
	Cycles(3);FetchWord();eac = temp16; bitCode(Read(eac));break;
case 0x2d: /* $2d and @2 */
	Cycles(4);FetchWord();eac = temp16; a = a & Read(eac) ; sValue = zValue = a;break;
case 0x2e: /* $2e rol @2 */
	Cycles(4);FetchWord();eac = temp16; Write(eac,rolCode(Read(eac)));break;
case 0x30: /* $30 bmi @r */
	Cycles(2);Branch((sValue & 0x80) != 0);break;
case 0x31: /* $31 and (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF; a = a & Read(eac) ; sValue = zValue = a;break;
case 0x34: /* $34 bit @1,x */
	Cycles(3);eac = (Fetch()+x) & 0xFF; bitCode(Read01(eac));break;
case 0x35: /* $35 and @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF; a = a & Read01(eac) ; sValue = zValue = a;break;
case 0x36: /* $36 rol @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF; Write01(eac,rolCode(Read01(eac)));break;
case 0x38: /* $38 sec */
	Cycles(2);carryFlag = 1;break;
case 0x39: /* $39 and @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF; a = a & Read(eac) ; sValue = zValue = a;break;
case 0x3a: /* $3a dec */
	Cycles(2);sValue = zValue = a = (a - 1) & 0xFF;break;
case 0x3c: /* $3c bit @2,x */
	Cycles(3);FetchWord();eac = (temp16+x) & 0xFFFF; bitCode(Read(eac));break;
case 0x3d: /* $3d and @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF; a = a & Read(eac) ; sValue = zValue = a;break;
case 0x3e: /* $3e rol @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF; Write(eac,rolCode(Read(eac)));break;
case 0x40: /* $40 rti */
	Cycles(6);explodeFlagRegister(Pop());pc = Pop();pc = pc | (((WORD16)Pop()) << 8);break;
case 0x41: /* $41 eor (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);sValue = zValue = a = a ^ Read(eac);break;
case 0x45: /* $45 eor @1 */
	Cycles(3);eac = Fetch();sValue = zValue = a = a ^ Read01(eac);break;
case 0x46: /* $46 lsr @1 */
	Cycles(3);eac = Fetch(); Write01(eac,lsrCode(Read01(eac)));break;
case 0x48: /* $48 pha */
	Cycles(3);Push(a);break;
case 0x49: /* $49 eor #@1 */
	Cycles(2);sValue = zValue = a = a ^ Fetch();break;
case 0x4a: /* $4a lsr a */
	Cycles(2);a = lsrCode(a);break;
case 0x4c: /* $4c jmp @2 */
	Cycles(3);FetchWord();eac = temp16;pc = eac;break;
case 0x4d: /* $4d eor @2 */
	Cycles(4);FetchWord();eac = temp16;sValue = zValue = a = a ^ Read(eac);break;
case 0x4e: /* $4e lsr @2 */
	Cycles(4);FetchWord();eac = temp16; Write(eac,lsrCode(Read(eac)));break;
case 0x50: /* $50 bvc @r */
	Cycles(2);Branch(overflowFlag == 0);break;
case 0x51: /* $51 eor (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;sValue = zValue = a = a ^ Read(eac);break;
case 0x55: /* $55 eor @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;sValue = zValue = a = a ^ Read01(eac);break;
case 0x56: /* $56 lsr @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF; Write01(eac,lsrCode(Read01(eac)));break;
case 0x58: /* $58 cli */
	Cycles(2);interruptDisableFlag = 0;break;
case 0x59: /* $59 eor @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = a ^ Read(eac);break;
case 0x5a: /* $5a phy */
	Cycles(3);Push(y);break;
case 0x5d: /* $5d eor @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = a ^ Read(eac);break;
case 0x5e: /* $5e lsr @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF; Write(eac,lsrCode(Read(eac)));break;
case 0x60: /* $60 rts */
	Cycles(6);pc = Pop();pc = pc | (((WORD16)Pop()) << 8);pc++;break;
case 0x61: /* $61 adc (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);sValue = zValue = a = add8Bit(a,Read(eac),decimalFlag);break;
case 0x65: /* $65 adc @1 */
	Cycles(3);eac = Fetch();sValue = zValue = a = add8Bit(a,Read01(eac),decimalFlag);break;
case 0x66: /* $66 ror @1 */
	Cycles(3);eac = Fetch(); Write01(eac,rorCode(Read01(eac)));break;
case 0x68: /* $68 pla */
	Cycles(4);a = sValue = zValue = Pop();break;
case 0x69: /* $69 adc #@1 */
	Cycles(2);sValue = zValue = a = add8Bit(a,Fetch(),decimalFlag);break;
case 0x6a: /* $6a ror a */
	Cycles(2);a = rorCode(a);break;
case 0x6c: /* $6c jmp (@2) */
	Cycles(5);FetchWord();eac = ReadWord(temp16);pc = eac;break;
case 0x6d: /* $6d adc @2 */
	Cycles(4);FetchWord();eac = temp16;sValue = zValue = a = add8Bit(a,Read(eac),decimalFlag);break;
case 0x6e: /* $6e ror @2 */
	Cycles(4);FetchWord();eac = temp16; Write(eac,rorCode(Read(eac)));break;
case 0x70: /* $70 bvs @r */
	Cycles(2);Branch(overflowFlag != 0);break;
case 0x71: /* $71 adc (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;sValue = zValue = a = add8Bit(a,Read(eac),decimalFlag);break;
case 0x75: /* $75 adc @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;sValue = zValue = a = add8Bit(a,Read01(eac),decimalFlag);break;
case 0x76: /* $76 ror @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF; Write01(eac,rorCode(Read01(eac)));break;
case 0x78: /* $78 sei */
	Cycles(2);interruptDisableFlag = 1;break;
case 0x79: /* $79 adc @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = add8Bit(a,Read(eac),decimalFlag);break;
case 0x7a: /* $7a ply */
	Cycles(4);y = sValue = zValue = Pop();break;
case 0x7d: /* $7d adc @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = add8Bit(a,Read(eac),decimalFlag);break;
case 0x7e: /* $7e ror @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF; Write(eac,rorCode(Read(eac)));break;
case 0x80: /* $80 bra @r */
	Cycles(2);Branch(1);break;
case 0x81: /* $81 sta (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);Write(eac,a);break;
case 0x84: /* $84 sty @1 */
	Cycles(3);eac = Fetch();Write01(eac,y);break;
case 0x85: /* $85 sta @1 */
	Cycles(3);eac = Fetch();Write01(eac,a);break;
case 0x86: /* $86 stx @1 */
	Cycles(3);eac = Fetch();Write01(eac,x);break;
case 0x88: /* $88 dey */
	Cycles(2);sValue = zValue = y = (y - 1) & 0xFF;break;
case 0x89: /* $89 bit #@1 */
	Cycles(3);bitCode(Fetch());break;
case 0x8a: /* $8a txa */
	Cycles(2);sValue = zValue = a = x;break;
case 0x8c: /* $8c sty @2 */
	Cycles(4);FetchWord();eac = temp16;Write(eac,y);break;
case 0x8d: /* $8d sta @2 */
	Cycles(4);FetchWord();eac = temp16;Write(eac,a);break;
case 0x8e: /* $8e stx @2 */
	Cycles(4);FetchWord();eac = temp16;Write(eac,x);break;
case 0x90: /* $90 bcc @r */
	Cycles(2);Branch(carryFlag == 0);break;
case 0x91: /* $91 sta (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;Write(eac,a);break;
case 0x94: /* $94 sty @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;Write01(eac,y);break;
case 0x95: /* $95 sta @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;Write01(eac,a);break;
case 0x96: /* $96 stx @1,y */
	Cycles(4);eac = (Fetch()+y) & 0xFF;Write01(eac,x);break;
case 0x98: /* $98 tya */
	Cycles(2);sValue = zValue = a = y;break;
case 0x99: /* $99 sta @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;Write(eac,a);break;
case 0x9a: /* $9a txs */
	Cycles(2);s = x;break;
case 0x9d: /* $9d sta @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;Write(eac,a);break;
case 0xa0: /* $a0 ldy #@1 */
	Cycles(2);y = sValue = zValue = Fetch();break;
case 0xa1: /* $a1 lda (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);a = sValue = zValue = Read(eac);break;
case 0xa2: /* $a2 ldx #@1 */
	Cycles(2);x = sValue = zValue = Fetch();break;
case 0xa4: /* $a4 ldy @1 */
	Cycles(3);eac = Fetch();y = sValue = zValue = Read01(eac);break;
case 0xa5: /* $a5 lda @1 */
	Cycles(3);eac = Fetch();a = sValue = zValue = Read01(eac);break;
case 0xa6: /* $a6 ldx @1 */
	Cycles(3);eac = Fetch();x = sValue = zValue = Read01(eac);break;
case 0xa8: /* $a8 tay */
	Cycles(2);sValue = zValue = y = a;break;
case 0xa9: /* $a9 lda #@1 */
	Cycles(2);a = sValue = zValue = Fetch();break;
case 0xaa: /* $aa tax */
	Cycles(2);sValue = zValue = x = a;break;
case 0xac: /* $ac ldy @2 */
	Cycles(4);FetchWord();eac = temp16;y = sValue = zValue = Read(eac);break;
case 0xad: /* $ad lda @2 */
	Cycles(4);FetchWord();eac = temp16;a = sValue = zValue = Read(eac);break;
case 0xae: /* $ae ldx @2 */
	Cycles(4);FetchWord();eac = temp16;x = sValue = zValue = Read(eac);break;
case 0xb0: /* $b0 bcs @r */
	Cycles(2);Branch(carryFlag != 0);break;
case 0xb1: /* $b1 lda (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;a = sValue = zValue = Read(eac);break;
case 0xb4: /* $b4 ldy @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;y = sValue = zValue = Read01(eac);break;
case 0xb5: /* $b5 lda @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;a = sValue = zValue = Read01(eac);break;
case 0xb6: /* $b6 ldx @1,y */
	Cycles(4);eac = (Fetch()+y) & 0xFF;x = sValue = zValue = Read01(eac);break;
case 0xb8: /* $b8 clv */
	Cycles(2);overflowFlag = 0;break;
case 0xb9: /* $b9 lda @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;a = sValue = zValue = Read(eac);break;
case 0xba: /* $ba tsx */
	Cycles(2);sValue = zValue = x = s;break;
case 0xbc: /* $bc ldy @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;y = sValue = zValue = Read(eac);break;
case 0xbd: /* $bd lda @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;a = sValue = zValue = Read(eac);break;
case 0xbe: /* $be ldx @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;x = sValue = zValue = Read(eac);break;
case 0xc0: /* $c0 cpy #@1 */
	Cycles(2);carryFlag = 1;sValue = zValue = sub8Bit(y,Fetch(),0);break;
case 0xc1: /* $c1 cmp (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);carryFlag = 1;sValue = zValue = sub8Bit(a,Read(eac),0);break;
case 0xc4: /* $c4 cpy @1 */
	Cycles(3);eac = Fetch();carryFlag = 1;sValue = zValue = sub8Bit(y,Read01(eac),0);break;
case 0xc5: /* $c5 cmp @1 */
	Cycles(3);eac = Fetch();carryFlag = 1;sValue = zValue = sub8Bit(a,Read01(eac),0);break;
case 0xc6: /* $c6 dec @1 */
	Cycles(5);eac = Fetch();sValue = zValue = (Read01(eac)-1) & 0xFF; Write01(eac,sValue);break;
case 0xc8: /* $c8 iny */
	Cycles(2);sValue = zValue = y = (y + 1) & 0xFF;break;
case 0xc9: /* $c9 cmp #@1 */
	Cycles(2);carryFlag = 1;sValue = zValue = sub8Bit(a,Fetch(),0);break;
case 0xca: /* $ca dex */
	Cycles(2);sValue = zValue = x = (x - 1) & 0xFF;break;
case 0xcc: /* $cc cpy @2 */
	Cycles(4);FetchWord();eac = temp16;carryFlag = 1;sValue = zValue = sub8Bit(y,Read(eac),0);break;
case 0xcd: /* $cd cmp @2 */
	Cycles(4);FetchWord();eac = temp16;carryFlag = 1;sValue = zValue = sub8Bit(a,Read(eac),0);break;
case 0xce: /* $ce dec @2 */
	Cycles(6);FetchWord();eac = temp16;sValue = zValue = (Read(eac)-1) & 0xFF; Write(eac,sValue);break;
case 0xd0: /* $d0 bne @r */
	Cycles(2);Branch(zValue != 0);break;
case 0xd1: /* $d1 cmp (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;carryFlag = 1;sValue = zValue = sub8Bit(a,Read(eac),0);break;
case 0xd5: /* $d5 cmp @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;carryFlag = 1;sValue = zValue = sub8Bit(a,Read01(eac),0);break;
case 0xd6: /* $d6 dec @1,x */
	Cycles(6);eac = (Fetch()+x) & 0xFF;sValue = zValue = (Read01(eac)-1) & 0xFF; Write01(eac,sValue);break;
case 0xd8: /* $d8 cld */
	Cycles(2);decimalFlag = 0;break;
case 0xd9: /* $d9 cmp @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;carryFlag = 1;sValue = zValue = sub8Bit(a,Read(eac),0);break;
case 0xda: /* $da phx */
	Cycles(3);Push(x);break;
case 0xdd: /* $dd cmp @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;carryFlag = 1;sValue = zValue = sub8Bit(a,Read(eac),0);break;
case 0xde: /* $de dec @1,x */
	Cycles(6);eac = (Fetch()+x) & 0xFF;sValue = zValue = (Read01(eac)-1) & 0xFF; Write01(eac,sValue);break;
case 0xe0: /* $e0 cpx #@1 */
	Cycles(2);carryFlag = 1;sValue = zValue = sub8Bit(x,Fetch(),0);break;
case 0xe1: /* $e1 sbc (@1,x) */
	Cycles(7);temp8 = (Fetch()+x) & 0xFF;eac = ReadWord01(temp8);sValue = zValue = a = sub8Bit(a,Read(eac),decimalFlag);break;
case 0xe4: /* $e4 cpx @1 */
	Cycles(3);eac = Fetch();carryFlag = 1;sValue = zValue = sub8Bit(x,Read01(eac),0);break;
case 0xe5: /* $e5 sbc @1 */
	Cycles(3);eac = Fetch();sValue = zValue = a = sub8Bit(a,Read01(eac),decimalFlag);break;
case 0xe6: /* $e6 inc @1 */
	Cycles(5);eac = Fetch();sValue = zValue = (Read01(eac)+1) & 0xFF; Write01(eac, sValue);break;
case 0xe8: /* $e8 inx */
	Cycles(2);sValue = zValue = x = (x + 1) & 0xFF;break;
case 0xe9: /* $e9 sbc #@1 */
	Cycles(2);sValue = zValue = a = sub8Bit(a,Fetch(),decimalFlag);break;
case 0xea: /* $ea nop */
	Cycles(2);{};break;
case 0xec: /* $ec cpx @2 */
	Cycles(4);FetchWord();eac = temp16;carryFlag = 1;sValue = zValue = sub8Bit(x,Read(eac),0);break;
case 0xed: /* $ed sbc @2 */
	Cycles(4);FetchWord();eac = temp16;sValue = zValue = a = sub8Bit(a,Read(eac),decimalFlag);break;
case 0xee: /* $ee inc @2 */
	Cycles(6);FetchWord();eac = temp16;sValue = zValue = (Read(eac)+1) & 0xFF; Write(eac, sValue);break;
case 0xf0: /* $f0 beq @r */
	Cycles(2);Branch(zValue == 0);break;
case 0xf1: /* $f1 sbc (@1),y */
	Cycles(6);temp8 = Fetch();eac = (ReadWord01(temp8)+y) & 0xFFFF;sValue = zValue = a = sub8Bit(a,Read(eac),decimalFlag);break;
case 0xf5: /* $f5 sbc @1,x */
	Cycles(4);eac = (Fetch()+x) & 0xFF;sValue = zValue = a = sub8Bit(a,Read01(eac),decimalFlag);break;
case 0xf6: /* $f6 inc @1,x */
	Cycles(6);eac = (Fetch()+x) & 0xFF;sValue = zValue = (Read01(eac)+1) & 0xFF; Write01(eac, sValue);break;
case 0xf8: /* $f8 sed */
	Cycles(2);decimalFlag = 1;break;
case 0xf9: /* $f9 sbc @2,y */
	Cycles(4);FetchWord();eac = (temp16+y) & 0xFFFF;sValue = zValue = a = sub8Bit(a,Read(eac),decimalFlag);break;
case 0xfa: /* $fa plx */
	Cycles(4);x = sValue = zValue = Pop();break;
case 0xfd: /* $fd sbc @2,x */
	Cycles(4);FetchWord();eac = (temp16+x) & 0xFFFF;sValue = zValue = a = sub8Bit(a,Read(eac),decimalFlag);break;
case 0xfe: /* $fe inc @2,x */
	Cycles(6);FetchWord();eac = (temp16+x) & 0xFFFF;sValue = zValue = (Read(eac)+1) & 0xFF; Write(eac, sValue);break;
