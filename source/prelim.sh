rm rom.bin memory.dump
pushd ../scripts
python token_code.py
#python token_basic.py 
python test_basic.py
popd

