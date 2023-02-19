;
; Example 6
; Delayed on (TON timer), and delayed off (TOFF timer).
; Light system for a bathroom with the following features:
;   - ON/OFF light switch
;   - Fan starts only if lights on for longer than a certain time
;   - Once fan starts it stays on as long as the lights are on
;   - When lights go off fan continues for a certain time
;
; This is the same code as assembler/examples/example6.asm but adapted for the cc65 syntax.

.include "../plc14500-nano-b.inc"

SWITCH=IN0
LIGHT=OUT0
FAN=OUT1
FANTON=SPR2
FANTOFF=SPR1

.segment "CODE"

    ien  IN6
    oen  IN6

    ld  SWITCH         ; Lights always follow the switch.
    sto  LIGHT

    andc FANTON         ; Trigger the timer if lights on and
    sto TMR0TRIG       ; TON timer was not triggered yet.
    skz
    sto FANTON

    ldc TMR0OUT        ; Start the fan if timer elapsed and
    and FANTON          ; TON timer was triggered.
    skz                 ; this block can never switch off the fan
    sto FAN

    ldc SWITCH          ; Trigger the timer if lights are off,
    and FANTON          ; TON has been triggered
    andc FANTOFF        ; TOFF has not been triggered (yet)
    andc TMR0OUT       ; and the timer is not running.
    sto TMR0TRIG
    skz
    sto FANTOFF

    ldc FANTOFF         ; If TOFF has not been triggered
    skz                 ; we are done, go around.
    jmp 0

    ld TMR0OUT         ; If the TOFF timer has not elapsed
    skz                 ; go around, nothing else to do.
    jmp 0

    sto FAN             ; The TOFF timer elapsed, turn off the fan
    sto FANTON          ; reset everything
    sto FANTOFF         ;
    jmp 0               ; and go back to start.
