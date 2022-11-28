@echo off
if not exist ".build" mkdir ".build"
copy "bootloader\flash14500.cmd" ".build"
if not exist ".build\examples" mkdir ".build\examples"
xcopy "assembler\examples" ".build\examples" /Y
copy "bootloader\bootloader.ino" ".build"
copy "README.md" ".build"
dart compile exe "assembler\bin\assembler.dart" -o ".build\asm14500.exe"