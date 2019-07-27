sh prelim.sh
64tass --m4510 -D TARGET=1 -b basic.asm  -L rom.lst -o rom.bin
if [ $? -eq 0 ]
then
../xmega65.native 1>/dev/null
fi
