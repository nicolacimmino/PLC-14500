@echo off

if [%1]==[] goto usage

where /q ca65 || ECHO Could not find ca65.exe, make sure CC65 is installed and its bin folder in PATH. && EXIT /B
where /q ld65 || ECHO Could not find ld65.exe, make sure CC65 is installed and its bin folder in PATH. && EXIT /B

set asmFilename=%~f1
set filenameRoot=%~n1

if not exist .build\ mkdir .build\

if exist .build\%filenameRoot%.*  del .build\%filenameRoot%.*

@echo Assembling %filenameRoot%.asm 
ca65 -g %asmFilename% -o .build\%filenameRoot%.o -l .build\%filenameRoot%.lst --list-bytes 0

@echo Linking .build\%filenameRoot%.o
ld65 -o .build\%filenameRoot%.bin -Ln .build\%filenameRoot%.labels -m .build\%filenameRoot%.map -C plc14500-nano-b.cfg .build\%filenameRoot%.o

@echo Done. Binary in: .build\%filenameRoot%.bin

goto :eof

:usage
@echo Usage: %0 file.asm
exit /B 1

