;
; 1 Bit Full Adder: A1 + B1 + C0 (carry-in) = R1 (result) + C1 (carry-out)
;
; Usage:
; - set value A1 (IN0)
; - set value B1 (IN1)
; - set carry-in (IN2)
; - OUT0 shows the result (R1)
; - OUT1 shows the carry-out
;
; This full adder doesn't need a Scratch Register for intermediate results!
;

.board=PLC14500-Nano

.io_A1 = IN0
.io_B1 = IN1
.io_C0 = IN2
.io_R1 = OUT0
.io_C1 = OUT1

;
; Prepare: Enable input
;

ORC  RR
IEN  RR
OEN  RR

;
; ADD A1 + B1 + C0 -> R1 + C1
;

; Calculate result -> R1

LD   A1
XNOR B1
XNOR C0
STO  R1

; Calculate next carry -> C1

LD   A1
AND  B1
IEN  C0
OR   A1
OR   B1
STO  C1

; Re-enable input

ORC  RR
IEN  RR

; Loop back

JMP  0
