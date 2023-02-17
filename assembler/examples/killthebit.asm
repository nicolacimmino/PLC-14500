;
; Kill the bit for PLC14500-Nano (REV.C or later).
;
; NOTE! This game requires REV.C board (or a modified REV.B). This is because the clock
;   needs to be slowed down for the game to humanly playable. Also revisions prior to C
;   didn't have the RR wired up to SPR0 so the init code wouldn't work correctly.
;
; The game idea itself is from a game for the Altair by Dean McDaniel in 1975.
;
; The idea to implement it on the MC14500 came to me after watching this awesome
;   built by Usagi Electric ( https://www.youtube.com/watch?v=md_cPxVDqeM )
;   Also the code was heavily adapted from his project:
;   https://github.com/veremenko-y/mc14500-programs/blob/main/sbc1/killthebit.s
;

.board=PLC14500-Nano

.io_SWAP=SPR7       ; Swap bit used for temporary storage
.io_GAME_BIT0=SPR1  ; Game bit 0
.io_GAME_BIT1=SPR2  ; Game bit 1
.io_GAME_BIT2=SPR3  ; Game bit 2
.io_GAME_BIT3=SPR4  ; Game bit 3
.io_GAME_LED0=OUT0  ; Game LED 0
.io_GAME_LED1=OUT1  ; Game LED 1
.io_GAME_LED2=OUT2  ; Game LED 2
.io_GAME_LED3=OUT3  ; Game LED 3

.io_GAME_BUTTON=IN0 ; Game only button

STO  SWAP        ; Store RR
ORC  RR          ; Force RR=1
IEN  RR          ; Enable inputs
LD   SWAP        ; Restore RR

; This block will be run once at startup
LDC  RR          ; RR is 0 at reset, but will be 1
                 ;   once we looped once (see last line)
OEN  RR          ; Execute below only on the first round.
STO  GAME_BIT0   ; Initialize game with one bit.

; Here the main loop starts, the below code is executed always.
ORC  RR          ; 1 -> RR
OEN  SPR0        ; force enable main loop

; Kill (or set!) the first bit.
; The bit will be killed if the button is pressed while it's high.
LD   GAME_BUTTON
XNOR GAME_BIT0
STOC GAME_BIT0

; Display the game status by showing on the outputs the values stored in SPR.
; Note: we don't play directly on SPR as that would be confusing as some bits
;   in SPR are used to store RR (SPRO) and temporary values (SPR7).
LD   GAME_BIT0
STO  GAME_LED0
LD   GAME_BIT1
STO  GAME_LED1
LD   GAME_BIT2
STO  GAME_LED2
LD   GAME_BIT3
STO  GAME_LED3

; Rotate all bits forward (and last back to first).
LD   GAME_BIT3
STO  SWAP
LD   GAME_BIT2
STO  GAME_BIT3
LD   GAME_BIT1
STO  GAME_BIT2
LD   GAME_BIT0
STO  GAME_BIT1
LD   SWAP
STO  GAME_BIT0

; Force RR to 1 so when we loop around
;   the init block will be skipped.
ORC  RR

; Don't JMP 0 here, the rest of the code will
;   filled with NOPF and act as a delay, otherwise the
;   game will be too slow even on the slow clock.


