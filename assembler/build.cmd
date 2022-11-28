@echo off
if not exist ".build" mkdir ".build"
copy flash14500.cmd .build
if not exist ".build\examples" mkdir ".build\examples"
xcopy "examples" ".build\examples" /Y

dart compile exe "bin\assembler.dart" -o ".build\asm14500.exe"