#!/bin/sh

# @echo off
# if not exist ".build" mkdir ".build"
mkdir -p ./build
# copy "tools\flash\flash14500.cmd" ".build"
cp tools/flash/flash14500.sh ./build
# if not exist ".build\examples" mkdir ".build\examples"
mkdir -p ./build/examples
# xcopy "tools\assembler\examples" ".build\examples" /Y /S
cp -af tools/assembler/examples ./build/examples
# copy "README.md" ".build"
cp README.md ./build

# dart compile exe "tools\assembler\bin\assembler.dart" -o ".build\asm14500.exe"
cd tools/assembler
dart pub get
dart compile exe bin/assembler.dart -o ../../build/asm14500
cd ../../
