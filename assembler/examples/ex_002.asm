;
; Example 2
;
; Copy IN0 to SPR0
; Copy SPR0 to OUT1
; Note: IN6 is the master switch, if flipped off outputs won't change.
;
ien IN6
oen IN6
ld IN0
sto SPR0
ld SPR0
sto OUT1
jmp 0
