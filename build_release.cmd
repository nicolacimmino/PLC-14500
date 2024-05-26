@echo off
if not exist ".build" mkdir ".build"
copy "tools\flash\flash14500.cmd" ".build"
if not exist ".build\examples" mkdir ".build\examples"
xcopy "tools\assembler\examples" ".build\examples" /Y /S
copy "README.md" ".build"

dart compile exe "tools\assembler\bin\assembler.dart" -o ".build\asm14500.exe"