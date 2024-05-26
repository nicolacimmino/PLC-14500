.board=PLC14500-Nano

.io_CTRL=IN0
.io_PWM0=SPR0
.io_PWM1=SPR1
.io_PWM2=SPR2
.io_PWM3=SPR3
.io_REV=SPR4
.io_PWMOUT=OUT0

ORC RR
IEN RR

; If (CTRL ON && TMR0 expired) ramp up PWM by setting PWM0 to PWM3
LDC REV         ; CTRL on 
ANDC TMR0-OUT   ; && TMR0 expired
OEN RR

STO     TMR0-TRIG   ; Pulse TMR0 trigger
STOC    TMR0-TRIG

; Rotate all bits forward 
LD      PWM3
STO     REV
LD      PWM2
STO     PWM3
LD      PWM1
STO     PWM2
LD      PWM0
STO     PWM1
ORC     RR
STO     PWM0

ORC     RR          ; endif
OEN     RR

LD PWM0             ; PWM Out ON if % > 0
STO PWMOUT

# if (!CTRL && TMR0 expired) ramp down PWM by resetting PWM3 to PWM0
LD REV
ANDC TMR0-OUT   ; && TMR0 expired
OEN RR

STO     TMR0-TRIG   ; Pulse TMR0 trigger
STOC    TMR0-TRIG

# Rotate all bits backwards 
LD      PWM0
STO     REV
LD      PWM1
STO     PWM0
LD      PWM2
STO     PWM1
LD      PWM3
STO     PWM2
ORC     RR
STOC    PWM3

ORC RR          ; end if
OEN RR


LDC PWM1        ; Keep PWM high if 50%
SKZ
STOC PWMOUT

NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO

LDC PWM2
SKZ
STOC PWMOUT
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO
NOPO

LDC PWM3
SKZ
STOC PWMOUT

JMP 0