rm rom.bin memory.dump dump.mem
pushd ../scripts
rm block.check
python token_code.py

#
#		One of these establishes what preloaded code will be in the ROM image.
#

#python test_math.py
#python test_assign.py
python token_basic.py 

popd

