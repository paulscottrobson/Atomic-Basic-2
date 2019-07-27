rm rom.bin memory.dump dump.mem
pushd ../scripts
python token_code.py
python token_basic.py 
popd

