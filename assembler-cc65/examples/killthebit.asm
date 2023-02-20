;
; Kill the bit for PLC14500-Nano (with slower clock).
;
; NOTE! This game requires a REV.B or later board with R30 replaced with a 10K. This is
;   because the clock needs to be slowed down for the game to humanly playable. If you
;   feel inclined, you could replace R30 with a 10K trimmer instead, so you can tune the
;   game speed.
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

.include "../plc14500-nano-b.inc"

SWAP=SPR7       ; Swap bit used for temporary storage
INIT=SPR6       ; Bit indicating initialization has been done
GAME_BIT0=SPR1  ; Game bit 0
GAME_BIT1=SPR2  ; Game bit 1
GAME_BIT2=SPR3  ; Game bit 2
GAME_BIT3=SPR4  ; Game bit 3
GAME_BIT4=SPR5  ; Game bit 4
GAME_LED0=OUT0  ; Game LED 0
GAME_LED1=OUT1  ; Game LED 1
GAME_LED2=OUT2  ; Game LED 2
GAME_LED3=OUT3  ; Game LED 3
GAME_LED4=OUT4  ; Game LED 4
GAME_BUTTON=IN0 ; Game only button

.segment "CODE"

    IEN  IN6
    OEN  IN6

    ; Initialize the game with one bit.
    ; The second time around INIT will be 1 and this block
    ; won't execute.
    LDC  INIT
    SKZ
    STO  GAME_BIT0
    LDC  INIT
    SKZ
    STO  INIT

    ; Kill (or set!) the first bit.
    ; The bit will be killed if the button is pressed while it's high.
    LD   GAME_BUTTON
    XNOR GAME_BIT0
    STOC GAME_BIT0

    ; Display the game status by showing on the outputs the values stored in SPR.
    ; Note: we don't play directly on SPR as that would be confusing as some bits
    ;   in SPR are used to store RR (SPRO) and temporary values (SPR7).

.repeat 5,I
    LD   GAME_BIT0+I
    STO  GAME_LED0+I
.endrepeat

    ; Rotate all bits forward (and last back to first).
    LD   GAME_BIT4
    STO  SWAP
.repeat 4,I
    LD   GAME_BIT3-I
    STO  GAME_BIT4-I
    LD   GAME_BIT2
.endrepeat
    LD   SWAP
    STO  GAME_BIT0

    ; Don't JMP 0 here, the rest of the code will be
    ;   filled with NOP0 and act as a delay, otherwise the
    ;   game will be too fast even on the slow clock.
