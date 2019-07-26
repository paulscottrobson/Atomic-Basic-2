static const char *_mnemonics[] = { "brk","ora (@1,x)","stop","byte 03","byte 04","ora @1","asl @1","byte 07","php","ora #@1","asl a","byte 0b","byte 0c","ora @2","asl @2","byte 0f","bpl @r","ora (@1),y","byte 12","byte 13","byte 14","ora @1,x","asl @1,x","byte 17","clc","ora @2,y","inc","byte 1b","byte 1c","ora @2,x","asl @2,x","byte 1f","jsr @2","and (@1,x)","byte 22","byte 23","bit @1","and @1","rol @1","byte 27","plp","and #@1","rol a","byte 2b","bit @2","and @2","rol @2","byte 2f","bmi @r","and (@1),y","byte 32","byte 33","bit @1,x","and @1,x","rol @1,x","byte 37","sec","and @2,y","dec","byte 3b","bit @2,x","and @2,x","rol @2,x","byte 3f","rti","eor (@1,x)","byte 42","byte 43","byte 44","eor @1","lsr @1","byte 47","pha","eor #@1","lsr a","byte 4b","jmp @2","eor @2","lsr @2","byte 4f","bvc @r","eor (@1),y","byte 52","byte 53","byte 54","eor @1,x","lsr @1,x","byte 57","cli","eor @2,y","phy","byte 5b","byte 5c","eor @2,x","lsr @2,x","byte 5f","rts","adc (@1,x)","byte 62","byte 63","byte 64","adc @1","ror @1","byte 67","pla","adc #@1","ror a","byte 6b","jmp (@2)","adc @2","ror @2","byte 6f","bvs @r","adc (@1),y","byte 72","byte 73","byte 74","adc @1,x","ror @1,x","byte 77","sei","adc @2,y","ply","byte 7b","byte 7c","adc @2,x","ror @2,x","byte 7f","bra @r","sta (@1,x)","byte 82","byte 83","sty @1","sta @1","stx @1","byte 87","dey","bit #@1","txa","byte 8b","sty @2","sta @2","stx @2","byte 8f","bcc @r","sta (@1),y","byte 92","byte 93","sty @1,x","sta @1,x","stx @1,y","byte 97","tya","sta @2,y","txs","byte 9b","byte 9c","sta @2,x","byte 9e","byte 9f","ldy #@1","lda (@1,x)","ldx #@1","byte a3","ldy @1","lda @1","ldx @1","byte a7","tay","lda #@1","tax","byte ab","ldy @2","lda @2","ldx @2","byte af","bcs @r","lda (@1),y","byte b2","byte b3","ldy @1,x","lda @1,x","ldx @1,y","byte b7","clv","lda @2,y","tsx","byte bb","ldy @2,x","lda @2,x","ldx @2,y","byte bf","cpy #@1","cmp (@1,x)","byte c2","byte c3","cpy @1","cmp @1","dec @1","byte c7","iny","cmp #@1","dex","byte cb","cpy @2","cmp @2","dec @2","byte cf","bne @r","cmp (@1),y","byte d2","byte d3","byte d4","cmp @1,x","dec @1,x","byte d7","cld","cmp @2,y","phx","byte db","byte dc","cmp @2,x","dec @1,x","byte df","cpx #@1","sbc (@1,x)","byte e2","byte e3","cpx @1","sbc @1","inc @1","byte e7","inx","sbc #@1","nop","byte eb","cpx @2","sbc @2","inc @2","byte ef","beq @r","sbc (@1),y","byte f2","byte f3","byte f4","sbc @1,x","inc @1,x","byte f7","sed","sbc @2,y","plx","byte fb","byte fc","sbc @2,x","inc @2,x","byte ff"};