;
; 6 Bit Full Adder: A1-6 + B1-6 = R1-6, OUT6 = Carry out
;
; Usage:
; - switch IN6 -> ON to load IN0-5 into SPR0-5 (second operand = B1-6)
; - then switch IN6 -> OFF and set IN0-5 (first operand = A1-6)
; - OUT0-5 shows the result (= R1-6), OUT6 is the carry
;
; SPR6 is used as intermediate carry while calculating
;

.board=PLC14500-Nano

;
; Intermediate carry
;
.io_C-TMP = SPR6

;
; First operand
;
.io_A1 = IN0
.io_A2 = IN1
.io_A3 = IN2
.io_A4 = IN3
.io_A5 = IN4
.io_A6 = IN5

;
; Second operand
;
.io_B1 = SPR0
.io_B2 = SPR1
.io_B3 = SPR2
.io_B4 = SPR3
.io_B5 = SPR4
.io_B6 = SPR5

;
; Result
;
.io_R1 = OUT0
.io_R2 = OUT1
.io_R3 = OUT2
.io_R4 = OUT3
.io_R5 = OUT4
.io_R6 = OUT5

;
; Carry-out
;
.io_C-OUT = OUT6

;
; Prepare: Enable input
;

ORC  RR
IEN  RR

; Write A1-6 to B1-6 if IN6 is set
OEN  IN6

LD   A1
STO  B1
LD   A2
STO  B2
LD   A3
STO  B3
LD   A4
STO  B4
LD   A5
STO  B5
LD   A6
STO  B6

ORC  RR
OEN  RR

;
; Do the calculations
;

; 1st bit - half adder

LD   A1
XNOR B1
STOC R1

LD   A1
AND  B1
STO  C-TMP

; 2nd bit - full adder

LD   A2
XNOR B2
XNOR C-TMP
STO  R2

LD   A2
AND  B2
IEN  C-TMP
OR   A2
OR   B2
STO  C-TMP

ORC  RR
IEN  RR

; 3rd bit - full adder

LD   A3
XNOR B3
XNOR C-TMP
STO  R3

LD   A3
AND  B3
IEN  C-TMP
OR   A3
OR   B3
STO  C-TMP

ORC  RR
IEN  RR

; 4th bit - full adder

LD   A4
XNOR B4
XNOR C-TMP
STO  R4

LD   A4
AND  B4
IEN  C-TMP
OR   A4
OR   B4
STO  C-TMP

ORC  RR
IEN  RR

; 5th bit - full adder

LD   A5
XNOR B5
XNOR C-TMP
STO  R5

LD   A5
AND  B5
IEN  C-TMP
OR   A5
OR   B5
STO  C-TMP

ORC  RR
IEN  RR

; 6th bit - full adder

LD   A6
XNOR B6
XNOR C-TMP
STO  R6

LD   A6
AND  B6
IEN  C-TMP
OR   A6
OR   B6
STO  C-TMP

ORC  RR
IEN  RR

; 7th bit - show carry

LD   C-TMP
STO  C-OUT

; Loop back

JMP  0
