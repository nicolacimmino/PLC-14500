;
; Kill the bit for PLC14500-Nano.
; The game idea itself is from a game for the Altair by Dean McDaniel in 1975.
; The idea to implement it on the MC14500 came to me after watching this awesome
;   built by Usagi Electric ( https://www.youtube.com/watch?v=md_cPxVDqeM )
;

.board=PLC14500-Nano

IEN IN6   ; IN6 acts as master switch
OEN IN6   ; to enable/disable all I/O

LD IN0
XNOR SPR0
STOC SPR0

LD IN0
SKZ
JMP 0


ld SPR0
sto OUT0
ld SPR1
sto OUT1
ld SPR2
sto OUT2
ld SPR3
sto OUT3
ld SPR4
sto OUT4
ld SPR5
sto OUT5
ld SPR6
sto OUT6

ld      SPR5
sto     SPR7
ld      SPR4
sto     SPR5
ld      SPR7
sto     SPR4

ld      SPR4
sto     SPR7
ld      SPR3
sto     SPR4
ld      SPR7
sto     SPR3

ld      SPR3
sto     SPR7
ld      SPR2
sto     SPR3
ld      SPR7
sto     SPR2

ld      SPR2
sto     SPR7
ld      SPR1
sto     SPR2
ld      SPR7
sto     SPR1

ld      SPR1
sto     SPR7
ld      SPR0
sto     SPR1
ld      SPR7
sto     SPR0

ld      SPR0
sto     SPR7
ld      SPR6
sto     SPR0
ld      SPR7
sto     SPR6



