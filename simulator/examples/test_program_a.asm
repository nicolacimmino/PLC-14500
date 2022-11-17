;
; Continuously copy input 0 and 1 to output 0 and 1
; the complement of 0 into 2.
ld 0    ; Load IN0
sto 0   ; Store it in OUT0
stoc 2  ; Store the complement into OUT2
ld 1    ; Load IN1
sto 1   ; Store it in OUT1
jmp 0   ; Back to start




