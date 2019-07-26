pushd ../6502system/emulator
sh build.sh
popd
rm rom.bin memory.dump dump.mem uart.sock
64tass  -c -D TARGET=2 -b basic.asm  -L rom.lst -o rom.bin
if [ $? -eq 0 ]
then
	../6502system/emulator/em6502 rom.bin go &
fi
