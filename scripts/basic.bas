110 dim c(32),zz(5):print
111 zz0 = cpu:!zz0 = 0:zz0?4=0
112 c?0 = #A2:c?1=#83
113 c?2 = #60
150 print &c
170 link c
175 gosub 2000
176 stop

1985 rem
1990 rem Dump CPU Status.
1995 rem
2000 zz0 = cpu
2010 print"6502: A:"&zz0?0" X:"&zz0?1" Y:"&zz0?2" Z:"&zz0?3" P:";&zz0?4;" NVSBDIZC:";
2020 zz1 = 0:zz2=zz0?4:do:print &(zz2 & #80)/128;:zz2 = zz2*2:zz1 = zz1+1:until zz1 = 8:print
2030 return
