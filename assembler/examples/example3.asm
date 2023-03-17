;
; Example 3
; A motor with separate start and stop buttons.

.board=PLC14500-Nano

.io_START=IN0
.io_STOP=IN1
.io_RUN=SPR1
.io_MOTOR=OUT0

ORC  RR
IEN  RR
OEN  RR

LD   START
OR   RUN
ANDC STOP
STO  RUN

STO  MOTOR

JMP  0