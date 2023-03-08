;
; Kill the bit for PLC14500-Nano (with slower clock).
;
; NOTE! This game requires a REV.C (or REV.B with a mod) board with R30 replaced with a 10K.
; This is because the clock needs to be slowed down for the game to be humanly playable. If you
;   feel inclined, you could replace R30 with a 10K trimmer instead, so you can tune the game speed.
;
; The game idea itself is from a game for the Altair by Dean McDaniel in 1975.
; Original Description:
;   Object: Kill the rotating bit. If you miss the lit bit, another
;   bit turns on leaving two bits to destroy. Quickly
;   toggle the switch, don't leave the switch in the up
;   position. Before starting, make sure all the switches
;   are in the down position.
;
; The idea to implement it on the MC14500 came to me after watching this awesome
;   build by Usagi Electric: https://www.youtube.com/watch?v=md_cPxVDqeM
;   Also the code was heavily adapted from this one:
;   https://github.com/veremenko-y/mc14500-programs/blob/main/sbc1/killthebit.s
;

.board=PLC14500-Nano

.io_SWAP=SPR6       ; Swap bit used for temporary storage
.io_GAME_BIT0=SPR0  ; Game bit 0
.io_GAME_BIT1=SPR1  ; Game bit 1
.io_GAME_BIT2=SPR2  ; Game bit 2
.io_GAME_BIT3=SPR3  ; Game bit 3
.io_GAME_BIT4=SPR4  ; Game bit 4
.io_GAME_LED0=OUT0  ; Game LED 0
.io_GAME_LED1=OUT1  ; Game LED 1
.io_GAME_LED2=OUT2  ; Game LED 2
.io_GAME_LED3=OUT3  ; Game LED 3
.io_GAME_LED4=OUT4  ; Game LED 4
.io_GAME_BUTTON=IN0 ; Game only button

STO     SWAP        ; Save RR
ORC     RR          ; RR=RR|!RR (always 1)
IEN     RR          ; Enable inputs
OEN     RR          ; Enable output
LD      SWAP        ; Restore RR

; This STO is executed only once because after the first loop we
;   set RR=1 (see last line of the whole program), so when we come here
;   RR is 1 and LDC will load a 0.
LDC     RR          ; This is 1 on reset (RR is initialized to 0)
SKZ
STO     GAME_BIT0   ; initialize memory with 1 initial bit

; Kill (or set!) the first bit.
; The bit will be killed if the button is pressed while it's high.
LD   GAME_BUTTON
XNOR GAME_BIT0
STOC GAME_BIT0

LD SPR5
STOC SPR5
OEN RR

; Display the game status by showing on the outputs the values stored in SPR.
; Note: we don't play directly on SPR as that would be confusing as some bits
;   in SPR are used to store RR and temporary values.
LD   GAME_BIT0
STO  GAME_LED0
LD   GAME_BIT1
STO  GAME_LED1
LD   GAME_BIT2
STO  GAME_LED2
LD   GAME_BIT3
STO  GAME_LED3
LD   GAME_BIT4
STO  GAME_LED4

; Rotate all bits forward (and last back to first).
LD   GAME_BIT4
STO  SWAP
LD   GAME_BIT3
STO  GAME_BIT4
LD   GAME_BIT2
STO  GAME_BIT3
LD   GAME_BIT1
STO  GAME_BIT2
LD   GAME_BIT0
STO  GAME_BIT1
LD   SWAP
STO  GAME_BIT0

; Don't JMP 0 here, the rest of the code will be
;   filled with NOPF and act as a delay, otherwise the
;   game will be too fast even on the slow clock.

ORC  RR         ; RR=RR|!RR (always 1)
                ; This will cause the code that initializes the game bit
                ;   to be skipped.



