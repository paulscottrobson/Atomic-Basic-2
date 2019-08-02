110 dim c(128),zz(5),tt(5):zz0 = cpu
115 x = #E5
120 p = c:gosub 19000:rem set up test1
130 gosub 18000:rem set up immediate.
135 gosub 17000:rem calculate result.
140 ?p = #60:link c:if tt3 <> !cpu then gosub 20000
160 goto 120


16997 rem
16998 rem Calculate result.
16999 rem
17000 g = x/16
17010 if g = 0 then tt3 = tt2|tt0
17020 if g = 2 then tt3 = tt2&tt0
17030 if g = 6 then tt3 = tt2+tt0
17040 if g = 14 then tt3 = tt0-tt2
17200 return
17997 rem 
17998 rem Set up to do x (immediate, 4 byte). tt2 the value to be used is in tt2.
17999 rem
18000 tt2 = rnd:print "Op "&x;" with ";&tt2
18002 !#84 = tt2:?(cpu+5) = 0
18005 ?p = #42:p?1 = #42:p?2 = x:p!3 = #84:p = p + 4
18010 return
18997 rem
18998 rem Set up code to load in a constant using NEG NEG mode. TT0 is the value loaded.
18999 rem
19000 tt0 = rnd:print "Load ";&tt0
19010 tt1 = #80:!tt1 = tt0
19015 ?p = #42:p?1=#42:p?2=#A5:p?3=#80:p = p + 4:rem neg neg lda $80
19020 ?p = #60:link c:if !zz0 <> tt0 then gosub 20000:stop
19020 return
19985 rem 
19990 rem Dump CPU Status.
19995 rem 
20000 zz0 = cpu
20010 print"6502: A:"&zz0?0" X:"&zz0?1" Y:"&zz0?2" Z:"&zz0?3" P:";&zz0?4;" NVSBDIZC:";
20020 zz1 = 0:zz2=zz0?4:do:print &(zz2 & #80)/128;:zz2 = zz2*2:zz1 = zz1+1:until zz1 = 8:print
20030 return

21000 ?p = #42:p?1 = #42:p?2 = #69:p!3 = 1:p = p  +7:return
