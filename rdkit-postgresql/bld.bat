echo cleaning up previous build

rmdir /s /q .\build 2> NUL
mkdir build
cd build

echo configuring with cmake

rem there is a problem where you can not use 'NMake Makefiles JOM' generator.
rem this creates incorrect pgsql_install.bat file at work\build\Code\PgSQL\rdkit where last line that installs rdkit.dll is incorrect
rem it contains 'Release' folder in the path like work\build\Code\PgSQL\rdkit\Release\rdkit.dll
rem while binary is still put into work\build\Code\PgSQL\rdkit\rdkit.dll
rem so the binary can not be copied and since installation is not properly done - postgres load test for rdkit cartridge fails

cmake ^
    -G "NMake Makefiles" ^
    -D CMAKE_SYSTEM_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -D CMAKE_BUILD_TYPE=Release ^
    -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -D BOOST_ROOT=%LIBRARY_PREFIX% ^
    -D Boost_NO_SYSTEM_PATHS=ON ^
    -D Boost_NO_BOOST_CMAKE=ON ^
    -D RDK_BUILD_AVALON_SUPPORT=ON ^
    -D RDK_BUILD_CPP_TESTS=OFF ^
    -D RDK_BUILD_INCHI_SUPPORT=ON ^
    -D RDK_INSTALL_STATIC_LIBS=OFF ^
    -D RDK_INSTALL_DEV_COMPONENT=OFF ^
    -D RDK_INSTALL_INTREE=OFF ^
    -D RDK_BUILD_PYTHON_WRAPPERS=OFF ^
    -D RDK_USE_BOOST_SERIALIZATION=OFF ^
    -D RDK_BUILD_FREESASA_SUPPORT=OFF ^
    -D RDK_USE_FLEXBISON=OFF ^
    -D RDK_BUILD_THREADSAFE_SSS=ON ^
    -D RDK_TEST_MULTITHREADED=ON ^
    -D RDK_OPTIMIZE_POPCNT=ON ^
    -D RDK_BUILD_PGSQL=ON ^
    -D RDK_PGSQL_STATIC=ON ^
    ..

if errorlevel 1 exit 1

echo starting build

rem building with jom like this because building this recipe with cmake does not seem to parallelize

where jom 2> NUL
if %ERRORLEVEL% equ 0 (
    set MAKE_CMD=jom -j%CPU_COUNT%
) else (
    set MAKE_CMD=nmake
)

%MAKE_CMD%

echo finished build, installing postgres rdkit extension

cd .\Code\PgSQL\rdkit
call pgsql_install.bat

set PGPORT=54321
set PGDATA=%SRC_DIR%\pgdata

rem cleanup required when building variants
rmdir /s /q $PGDATA 2> NULL 

pg_ctl initdb

rem ensure that the rdkit extension is loaded at process startup
echo shared_preload_libraries = 'rdkit' >> %PGDATA%\postgresql.conf

pg_ctl -D %PGDATA% -l %PGDATA%/log.txt start

rem wait a few seconds just to make sure that the server has started
ping -n 5 127.0.0.1 > NUL

echo starting the test

set "RDBASE=%SRC_DIR%"
ctest -V
set check_result=%ERRORLEVEL%

pg_ctl stop

exit /b %check_result%
