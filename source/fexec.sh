sh prelim.sh
64tass -q --m4510 -D TARGET=1 -b basic.asm  -L rom.lst -o rom.bin
if [ $? -eq 0 ]
then
	pushd ../documents
	sh bootrom.sh
	popd
fi
