#
#		Build emulator.
#
del /Q *.inc
pushd ../processor
sh build.sh
popd
pushd ../roms
python export.py
popd
make -f makefile.linux


