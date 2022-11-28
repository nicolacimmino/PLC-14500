@echo off
if not exist ".build" mkdir ".build"
copy "flash14500.cmd" ".build"
if not exist ".build\examples" mkdir ".build\examples"
xcopy "examples" ".build\examples" /Y
copy "..\bootloader\bootloader.ino" ".build"
copy "..\README.md" ".build"
dart compile exe "bin\assembler.dart" -o ".build\asm14500.exe"