;
; Example 3
; A motor with separate start and stop buttons.

.board=PLC14500-Nano
.io_MASTER=IN6
.io_START=IN0
.io_STOP=IN1
.io_RUN=SPR0
.io_MOTOR=OUT0

IEN MASTER
OEN MASTER

LD START
OR RUN
ANDC STOP
STO RUN

STO MOTOR

JMP 0

