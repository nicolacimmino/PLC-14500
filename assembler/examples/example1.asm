;
; Example 1
; Basic program echoing to one output the status of one input.

.board=PLC14500-Nano

IEN  IN6
OEN  IN6

LD   IN0
STO  OUT0

JMP  0

