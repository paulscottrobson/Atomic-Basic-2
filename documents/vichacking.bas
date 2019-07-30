\

;viciv-modes-16-bit-charmode-1.prg ==0801==
    0 poke0,65
   10 a=53248
   20 rem enable vic-iv registers
   30 pokea+47,asc("g")
   40 pokea+47,asc("s")
   50 rem enable 16-bit text mode
   60 pokea+84,1
  100 rem clear screen
  110 fori=0to999:poke1024+i,0:next
  120 rem clear screen
  130 cr=a+2048
  140 fori=0to999:pokecr+i,0:next
  150 pokea+49,peek(a+49)or32:rem vic-iii attributes enable
  200 print"{home}vic-iii character mode attributes       ";
  210 print"                                        ";
  220 fori=0to255:poke1024+80+i*2+0,10:next
  230 fori=0to255:poke1024+80+i*2+1,0:next
  240 fori=0to255:pokecr+80+i*2+0,0:next
  250 fori=0to255:pokecr+80+i*2+1,i:next
  299 v=1:gosub2000
  300 print"{home}16-bit char mode: screen byte 0         ";
  310 print"                                        ";
  320 fori=0to255:poke1024+80+i*2+0,i:next
  330 fori=0to255:poke1024+80+i*2+1,0:next
  340 fori=0to255:pokecr+80+i*2+0,0:next
  350 fori=0to255:pokecr+80+i*2+1,0:next
  399 v=1:gosub2000
  400 print"{home}16-bit char mode: screen byte 1 mask $e1";
  410 print"                                        ";
  420 fori=0to255:poke1024+80+i*2+0,6:next
  430 fori=0to255:poke1024+80+i*2+1,iand225:next
  440 fori=0to255:pokecr+80+i*2+0,0:next
  450 fori=0to255:pokecr+80+i*2+1,0:next
  499 v=1:gosub2000
  500 print"{home}16-bit char mode: colour byte 0         ";
  510 print"                                        ";
  520 fori=0to255:poke1024+80+i*2+0,6:next
  530 fori=0to255:poke1024+80+i*2+1,0:next
  540 fori=0to255:pokecr+80+i*2+0,i:next
  550 fori=0to255:pokecr+80+i*2+1,0:next
  599 v=1:gosub2000
  600 print"{home}16-bit char mode: colour byte 1         ";
  610 print"                                        ";
  620 fori=0to255:poke1024+80+i*2+0,6:next
  630 fori=0to255:poke1024+80+i*2+1,0:next
  640 fori=0to255:pokecr+80+i*2+0,0:next
  650 fori=0to255:pokecr+80+i*2+1,i:next
  699 v=1:gosub2000
  700 print"{home}16-bit char mode: double charset        ";
  710 print"                                        ";
  720 fori=0to459:poke1024+80+i*2+0,iand255:next
  730 fori=0to459:poke1024+80+i*2+1,i/256:next
  740 fori=0to255:pokecr+80+i*2+0,0:next
  750 fori=0to255:pokecr+80+i*2+1,0:next
  799 v=1:gosub2000
  980 pokea+84,0
  990 end
 2000 r=53248+17:r2=r+1
 2010 rem wait for bottom of screen
 2020 waitr,128,0:poke53280,0
 2030 rem clear 16 bit char mode
 2040 pokea+84,0
 2050 rem wait until after a couple of rows of text
 2060 waitr,128,128:poke53280,2
 2070 waitr2,64,0:poke53280,1
 2080 pokea+84,v
 2090 geta$:ifa$=""goto2010
 2100 return

