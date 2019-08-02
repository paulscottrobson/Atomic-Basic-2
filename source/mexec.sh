sh prelim.sh
64tass --m4510 -D TARGET=1 -b basic.asm  -L rom.lst -o rom.bin
truncate rom.bin -s 131072
if [ $? -eq 0 ]
then
	../../xemu/build/bin/xmega65.native -loadrom rom.bin -forcerom 1>/dev/null
fi
