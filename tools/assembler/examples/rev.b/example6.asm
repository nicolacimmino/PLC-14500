;
; Example 6
; Delayed on (TON timer), and delayed off (TOFF timer).
; Light system for a bathroom with the following features:
;   - ON/OFF light switch
;   - Fan starts only if lights on for longer than a certain time
;   - Once fan starts it stays on as long as the lights are on
;   - When lights go off fan continues for a certain time
;

.board=PLC14500-Nano

.io_SWITCH=IN0
.io_LIGHT=OUT0
.io_FAN=OUT1
.io_FANTON=SPR2
.io_FANTOFF=SPR1

IEN  IN6
OEN  IN6

LD   SWITCH         ; Lights always follow the switch.
STO  LIGHT

ANDC FANTON         ; Trigger the timer if lights on and
STO TMR0-TRIG       ; TON timer was not triggered yet.
SKZ
STO FANTON

LDC TMR0-OUT        ; Start the fan if timer elapsed and
AND FANTON          ; TON timer was triggered.
SKZ                 ; this block can never switch off the fan
STO FAN

LDC SWITCH          ; Trigger the timer if lights are off,
AND FANTON          ; TON has been triggered
ANDC FANTOFF        ; TOFF has not been triggered (yet)
ANDC TMR0-OUT       ; and the timer is not running.
STO TMR0-TRIG
SKZ
STO FANTOFF

LDC FANTOFF         ; If TOFF has not been triggered
SKZ                 ; we are done, go around.
JMP 0

LD TMR0-OUT         ; If the TOFF timer has not elapsed
SKZ                 ; go around, nothing else to do.
JMP 0

STO FAN             ; The TOFF timer elapsed, turn off the fan
STO FANTON          ; reset everything
STO FANTOFF         ;
JMP 0               ; and go back to start.
