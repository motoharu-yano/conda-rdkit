cd citus_src
cd code

./configure --with-security-flags

make -j$CPU_COUNT

make install -j$CPU_COUNT && make -C ./src/test/regress/ check-full

exit 0