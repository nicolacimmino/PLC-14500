;
; Example 1a
; 
; Room with multiple switches
;
;   |                                          |
;   +--------[ ]-------+----------( )----------+
;   |     BUTTON_A     |         LIGHT         |
;   |                  |                       |
;   +--------[ ]-------+                       |
;   |     BUTTON_B     |                       |
;   |                  |                       |
;   +--------[ ]-------+                       |
;   |     BUTTON_C     |                       |
;   |                  |                       |
;   +--------[ ]-------+                       |
;   |     BUTTON_D     |                       |
;   |                  |                       |
;   +--------[ ]-------+
;           LIGHT
;
; TMR0-TRIG = BUTTON_A OR BUTTON_B OR BUTTON_C OR BUTTON_D
; LIGHT = TMR0-OUT
;

.board=PLC14500-Nano

.io_MASTER=IN6
.io_SWITCH_A=IN0
.io_SWITCH_B=IN1
.io_SWITCH_C=IN2
.io_SWITCH_D=IN3
.io_LIGHT=SPR0

IEN   MASTER
OEN   MASTER

LD   SWITCH_A
OR   SWITCH_B
OR   SWITCH_C
OR   SWITCH_D

STO OUT7

LD   IN7
STO  LIGHT

JMP  0




