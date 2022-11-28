;
; Example 1
;
; Copy IN0 to OUT0
; Note: IN6 is the master switch, if flipped off outputs won't change.
;
ien IN6
oen IN6
ld IN0
sto OUT0
jmp 0
