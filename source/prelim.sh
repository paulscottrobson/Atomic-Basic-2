rm rom.bin memory.dump block.check
pushd ../scripts
python token_code.py
#python token_basic.py 
#python test_math.py
python test_assign.py
popd

