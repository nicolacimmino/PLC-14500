;
; Another smoke test for PLC14500-Nano (Rev_C).
;
; This shall test the following:
; - IN0-6 (buttons and switches)
; - OUT0-6 (LEDs, activated by IN0-6)
; - Timer TMR0 (IN7, OUT7)
; - SPR0-6 (running light)
; - ADDR0-7 (by omitting the last JMP)
; - DATA0-7, J, RR, W (indirectly)
;

.board=PLC14500-Nano

;
; Prepare: Enable input and output
;

ORC  RR
IEN  RR
OEN  RR

;
; Test: Copy IN0 - IN6 to OUT0 - OUT6
; The user can test all inputs and outputs using the switches and buttons
;

LD   IN0
STO  OUT0

LD   IN1
STO  OUT1

LD   IN2
STO  OUT2

LD   IN3
STO  OUT3

LD   IN4
STO  OUT4

LD   IN5
STO  OUT5

LD   IN6
STO  OUT6

;
; Test: Start timer TMR0 when elapsed (set 0 -> 1)
;

LD   TMR0-OUT
STOC TMR0-TRIG

;
; Loop if timer TMR0 hasn't elapsed
;

SKZ
JMP  0

;
; Timer has elapsed -> move running SPR light
;

; Move SPR 5 -> 6
; If SPR5 is 1 -> set to 0 and jump back

LD   SPR5
STO  SPR6
SKZ
STOC SPR5
SKZ
JMP  0

; Move SPR 4 -> 5

LD   SPR4
STO  SPR5
SKZ
STOC SPR4
SKZ
JMP  0

; Move SPR 3 -> 4

LD   SPR3
STO  SPR4
SKZ
STOC SPR3
SKZ
JMP  0

; Move SPR 2 -> 3

LD   SPR2
STO  SPR3
SKZ
STOC SPR2
SKZ
JMP  0

; Move SPR 1 -> 2

LD   SPR1
STO  SPR2
SKZ
STOC SPR1
SKZ
JMP  0

; Move SPR 0 -> 1

LD   SPR0
STO  SPR1
SKZ
STOC SPR0
SKZ
JMP  0

; If this point is reached SPR0 - 6 are all 0
; -> The running light needs to be initialized

ORC  RR
STO  SPR0

; Intentionally commented out to test ADDR6 + 7
; JMP  0
