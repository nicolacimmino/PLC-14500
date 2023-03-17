;
; Example 2
; Basic program switching on OUT0 only when both IN0 and IN1 are on.

.board=PLC14500-Nano

IEN  IN6
OEN  IN6

LD   IN0
AND  IN1
STO  OUT0

JMP  0

