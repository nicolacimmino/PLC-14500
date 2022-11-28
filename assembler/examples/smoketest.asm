;
; Smoke test for PLC14500-Nano.
;

.board=PLC14500-Nano

; *************************************************
; Prepare:
; All inputs off except IN6 (master switch) and
;   IN2 (TMR0 trigger, active low).
; *************************************************

IEN IN6   ; IN6 acts as master switch
OEN IN6   ; to enable/disable all I/O

; *************************************************
; Test: Input and outputs are working correctly

LD  IN0   ; Load IN0,
AND IN1   ; logical AND it with IN1
STO OUT0  ; and show the result in OUT0.

; Expect: OUT0 is on only when both IN0 and IN1 are on.
; *************************************************

; *************************************************
; Test: TMR0 is working correctly

LD  IN2   ; Load IN2
STO OUT7  ; use it to trigger TMR0.

; Expect: Clicking IN2 off turns on IN7 (TMR0 output)
;   and, after few seconds, IN7 returns off.
; *************************************************

; *************************************************
; Test: Scratchpad RAM is working correctly.

LD  IN3    ; Copy IN3 to SPR0
STO SPR0

LD  SPR0   ; Copy SPR0 to SPR1
STO SPR1

; Expect: Clicking IN3 turns on SPR0 and SPR1
; *************************************************

JMP 0     ; Repeat.