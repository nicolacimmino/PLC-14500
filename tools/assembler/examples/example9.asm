.board=PLC14500-Nano

.io_LIGHT_A=SPR0
.io_LIGHT_B=SPR1
.io_LIGHT_C=SPR2
.io_SWAP=SPR3

STO     SWAP        ; Save RR
ORC     RR          ; RR=RR|!RR (always 1)
IEN     RR          ; Enable inputs
OEN     RR          ; Enable outputs
LD      SWAP        ; Restore RR

LDC     RR          
OEN     RR

STO     LIGHT_A     ; Start with only the first light on
STOC    LIGHT_B
STOC    LIGHT_C

ORC     RR          ; RR=RR|!RR (always 1)
OEN     RR

; Rotate all bits forward (and last back to first).
;   But only when TMR0 expires.

LDC     TMR0-OUT    ; If TMR0 expired
OEN     RR
STO     TMR0-TRIG   ; Pulse TMR0 trigger
STOC    TMR0-TRIG

LD      LIGHT_C
STO     SWAP
LD      LIGHT_B
STO     LIGHT_C
LD      LIGHT_A
STO     LIGHT_B
LD      SWAP
STO     LIGHT_A

; Reflect the status on outputs
LD   LIGHT_A
STO  OUT0
LD   LIGHT_B
STO  OUT1
LD   LIGHT_C
STO  OUT2
LD   LIGHT_A
STO  OUT3
LD   LIGHT_B
STO  OUT4
LD   LIGHT_C
STO  OUT5
LD   LIGHT_A
STO  OUT6

ORC     RR          

JMP 0
