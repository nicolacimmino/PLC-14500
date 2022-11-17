;
; Continuously copy input 0 and 1 to output 0 and 1
; the complement of 0 into 2.
; Also store IN0 in SPR.
ien 6
oen 6
ld 0    ; Load IN0
sto 0   ; Store it in OUT0
stoc 2  ; Store the complement into OUT2
sto 8   ; Store it in SPR0
ld 1    ; Load IN1
sto 1   ; Store it in OUT1
ld 2    ; Load IN2
sto 7   ; Trigger timer if set
ld 7    ; Load timer status
sto 3   ; Show timer status on OUT3
jmp 0   ; Back to start




