100 a = 0
110 do
115 a?2=#AA
120 gosub 1000
130 a = a + #1000
140 until a = #10000
150 stop
1000 print &a,
1010 x = 0
1020 do
1025 if a?x<16 then print "0";
1030 print &a?x;" ";
1040 x = x + 1
1050 until x = 16
1100 print
1110 return

