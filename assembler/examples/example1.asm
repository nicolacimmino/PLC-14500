;
; Example 1
; Basic program echoing to one output the status of one input.

.board=PLC14500-Nano

ORC  RR
IEN  RR
OEN  RR

LD   IN0
STO  OUT0

JMP  0

