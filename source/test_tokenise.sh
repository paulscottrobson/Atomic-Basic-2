rm rom.bin memory.dump 
pushd ../scripts
rm block.check
python token_code.py
python test_maketok.py create
popd
64tass -q -c -D TARGET=2 -b basic.asm  -L rom.lst -o rom.bin
if [ $? -eq 0 ]
then
	../6502system/emulator/em6502 rom.bin go
	python ../scripts/test_maketok.py check
fi
