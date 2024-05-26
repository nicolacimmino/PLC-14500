;
; Example 2
; Basic program switching on OUT0 only when both IN0 and IN1 are on.

.board=PLC14500-Nano

ORC  RR
IEN  RR
OEN  RR

LD   IN0
AND  IN1
STO  OUT0

JMP  0

