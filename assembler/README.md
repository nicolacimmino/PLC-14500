

## Compling

````
.\asm14500.exe {file.asm}
````

## Source format

````
;
; This program implements a simple control
; logic for an hypotetical machine with the
; following controls:
;
; X1 on/off switch controls the machine power
; X3 start button
; X4 stop button
;
; Y5 Yellow lamp, indicates machine is started
; Y6 Green lamp, idicates machine is ready
; Y7 Red lamp, indicates machine power is on
;

.board=plc14500_nano

ien 7   ; Enable inputs, 7 is hardwired to 1
oen 7   ; Enable outputs
ld 1    ; Load X1 (Master)
sto 7   ; Set Y7 (Power Lamp, red)
ld 3    ; Load X3 (Start button)
or 0    ; OR with X0 (wired to Y0, latch)
andc 4  ; AND with X4 negated (stop button)
and 1   ; AND with X1 (Master)
sto 5   ; Set Y5 (Running Lamp, yellow)
sto 0   ; Set Y0 (wired to X0, latch state)
xnor 6  ; Negate, X1 is always zero
and 1   ; AND with X1 (Master)
sto 6   ; Set Y6 (Ready Lamp, green)
nopf    ; Reset and jump to start
````

## Transferring to the board

The toolchain doesn't currently provide a method of sending out software to the board. Since the bootloader just expects 256 bytes to load in RAM, in Windoes you can send the bin file simply with:

````
copy test1.bin com3 /B
````

