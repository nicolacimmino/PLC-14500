;
; Example 5
; Delayed on (TON timer), eg the fan in a bathroom that doesn't start immediately with the lights.

.board=PLC14500-Nano

.io_MASTER=IN6
.io_BUTTON_A=IN0
.io_LIGHT_ON=SPR0
.io_LIGHT=OUT0
.io_FAN=OUT1

IEN  MASTER
OEN  MASTER

LD   BUTTON_A

STO  OUT7
SKZ
STO  LIGHT_ON
SKZ
STO  LIGHT

LDC  IN7
AND  LIGHT_ON
STO  FAN

JMP  0

