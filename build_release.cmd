@echo off
if not exist ".build" mkdir ".build"
copy "bootloader\flash14500.cmd" ".build"
if not exist ".build\examples" mkdir ".build\examples"
xcopy "assembler\examples" ".build\examples" /Y
copy "bootloader\bootloader.ino" ".build"
copy "README.md" ".build"

if not exist ".build\asm-14500-cc65" mkdir ".build\asm-14500-cc65"
copy "assembler-cc65\asm-14500-cc65.cmd" ".build\asm-14500-cc65"
copy "assembler-cc65\*.cfg" ".build\asm-14500-cc65"
copy "assembler-cc65\*.inc" ".build\asm-14500-cc65"
copy "assembler-cc65\README.md" ".build\asm-14500-cc65"
xcopy "assembler-cc65\examples\*" ".build\asm-14500-cc65\examples\" /Y
copy "bootloader\flash14500.cmd" ".build\asm-14500-cc65"

dart compile exe "assembler\bin\assembler.dart" -o ".build\asm14500.exe"