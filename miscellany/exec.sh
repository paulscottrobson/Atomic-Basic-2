rm rom.bin
64tass -a --m4510 -b test.asm  -L rom.lst -o rom.bin
if [ $? -eq 0 ]
then
../xmega65.native & >/dev/null
fi
