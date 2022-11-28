# Introduction

The PLC14500 Nano is a retro-style trainer board intended for the user to familiarize with the Motorola MC14500 1-bit
ICU (Industrial Control Unit), PLCs and Ladder Logic. The board has abundant LEDs that show the status of 
the system buses and registers. This, combined with the possibility to run the software step by step,
gives the user a great deal of insight into how their programs are executing. The slow clock mode 
makes instead for a mesmerizing light show that won't fail to impress when the board is parked on a desk,
waiting for the next coding adventure.

Main features:

* 256 Bytes of program RAM (can be replaced with an EEPROM)
* 7 Inputs each with toggle and momentary switch capability
* 7 Outputs
* 1 Timer mapped to the I/O bus (0.5 to 30s, adjustable via a trimmer)
* 8 bits scratchpad RAM
* 3 clock modes (fast, slow, manual step)


True to its retro style PLC14500 Nano sports exclusively through-hole components and chips in DIP packages.
You might notice an intruder in the Bill of Materials, an Arduino Nano. It's there purely to act as a
bootloader, with a convenient USB interface that surely is easy to connect to modern PCs. However,
to not spoil the illusion, the Arduino is mounted on the bottom side of the PCB, so it won't be visible when 
using the board.

![Board](documentation/board.png)

# Assembling the board

To keep the assembled board visually free from clutter, and to give more prominence to the labels
relevant in regular use, it was chosen to hide the component reference numbers on the silkscreen.
Where possible these are on the silkscreen under the component itself but, where not possible, 
these have been omitted completely. To help with the assembly please refer to the assembly view 
available in the `board` folder.

**NOTE** Make sure you refer to the right revision of the board matching the one you have. The board
revision can be found on the bottom side silk screen (eg `PLC14500 Nano REV.A`)

As usual start from the lower profile components (such as resistors and ICs), and work towards taller
profile ones, to finish with large caps and the trimmer. 

**NOTE** The Arduino Nano is to be assembled on the bottom side of the board, opposite the components,
as indicated in the silk screen.

For a pure retro vibe, or if you decide to use the board as a display item, you
could assemble the Arduino on a row of female pin-headers and plug it only to program the board. In this
case you will need to replace the RAM with an EEPROM (the bootloader is already capable of driving it),
so the program will be persisted and the Arduino board won't need to be permanently installed.

# Getting started

Before starting writing your programs and testing them on the board, you will need to flash the bootloader
into the Arduino. This can be easily done with the Arduino IDE. Load the sketch you find in the `bootloader`
folder and make sure the board selected is "Arduino Nano". Connect the board to your PC with a USB cable
and select, in the Arduino IDE, the new serial port that will be assigned to the board. Upload the sketch
and you are ready to go.

Unless there will be an update to the bootloader you won't need to repeat this step in the future.

# Assembling a program

You can write your programs in any text editor of your choice, as long as you save them with a `.asm`
extension. This is a first example program to make sure your board is correctly assembled and functioning.

````
ien IN6   ; IN6 acts as master switch 
oen IN6   ; to enable/disable all I/O

ld IN0    ; Load IN0,
and IN1   ; logical AND it with IN1
sto OUT0  ; and show the result in OUT0.

ld IN2    ; Load IN2    
sto OUT7  ; use it to trigger TMR0.
ld IN7    ; Read the output of TMR0
sto OUT3  ; and store in OUT3.

jmp 0   ; Repeat.
````

Save it to a `test.asm` file and assemble it into a binary with the assembler found in the `assembler` folder:

````windows
.\asm14500.exe .\test.asm
````

This will produce a `test.bin` file, which should be 256 bytes in size.

# Transferring a program to the board

To transfer it to the board program RAM, make sure the USB cable is plugged in and take note of which serial port 
your board got mapped to in the Arduino IDE. You can then upload the file with:

````windows
mode COM3 dtr=off rts=off baud=9600 parity=n data=8 stop=1
copy test.bin COM3 /B
````

Replacing `COM3` with the correct port number for your board.

# Testing

If you uploaded the above example program you can verify the board correct functioning by following these
steps:

* Ensure all inputs are switched toward zero except IN6
* Adjust the trimmer controlling TMR0 about half way
* All OUTn should be off
* Switch on IN0 and IN1
* OUT0 should be on (OUT0 = INO AND IN1)
* Press briefly on IN2
* OUT3 should be on and go back off after about 10s (depending on the trimmer position)
* If you switch off IN6 the outputs should not change even if you change IN0/IN1 or trigger TMR0
* Switching back on IN6 should resume all functionality


