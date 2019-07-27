#
#		Build emulator.
#
rm *.inc
pushd ../processor
sh build.sh
popd
pushd ../roms
python export.py
popd
make -f makefile.linux


