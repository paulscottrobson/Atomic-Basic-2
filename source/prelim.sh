rm rom.bin memory.dump 
pushd ../scripts
rm block.check

python token_code.py

#python test_math.py
#python test_assign.py

python token_basic.py 

popd

