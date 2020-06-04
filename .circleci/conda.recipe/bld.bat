mkdir build
REM if errorlevel 1 exit 1
cd build
REM if errorlevel 1 exit 1
cmake ^
    -G "Visual Studio 16 2019" ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    ..
REM if errorlevel 1 exit 1
cmake --build . --config RelWithDebInfo --target install
REM if errorlevel 1 exit 1
ctest
REM if errorlevel 1 exit 1
