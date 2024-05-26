@echo off
set file=%1%
set port=%2%

echo flashing %file% to PLC14500 on %port%
mode %port% dtr=off rts=off baud=9600 parity=n data=8 stop=1

REM NOTE! For port numbers above 9 change to \\.\%port%
copy %file% %port% /B
timeout /t 5
echo done.
echo Press RST on the board!