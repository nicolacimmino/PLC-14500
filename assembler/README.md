
# PLC14500 Assembler

You can find a precompiled version of the assembler and a batch file to flash the programs into the board in the
[releases](https://github.com/nicolacimmino/PLC-14500/releases) zip file. If you prefer to build your own, or you want
to build for something else than Windows, you will need to have a properly configured Dart development environment
and build with:

````
dart compile exe "assembler\bin\assembler.dart" -o "asm14500.exe"
````

## Assembling

````
asm14500.exe test.asm
````

The output will be a `.bin` file of the same name. The output file is always 256 bytes for a PLC14500-Nano, your program
will be starting from offset 0x00 and will be padded to 256 with 0x0Fs (`NOPF`).

## Source format

````
;
; Comments are preceeded by semicolon, they can be at the beginning of
;   a line inline or after an instruction.

; This is metadata for the preprocessor. You MUST specify the target board.
.board=PLC14500-Nano

; These are friendly names. They allow to write code like STO MOTOR instead of STO OUT0
.io_MASTER=IN6
.io_START=IN0
.io_STOP=IN1
.io_RUN=SPR0
.io_MOTOR=OUT0

; The actual code has every line with one MC14500 instruction and paramter.
IEN MASTER
OEN MASTER

LD START    ; This is an inline comment
OR RUN
ANDC STOP
STO RUN

STO MOTOR

JMP 0
````

## Transferring to the board

Identify which COM port gets assigned to the board when plugged in and then transfer the binary file.

````
flash14500.cmd examples\example3.bin COM3
````

*Note* you should always press `RST` on the board once upload is done to clear the SPR and output latches, this will 
avoid confusion that previously stored values might cause.

If you want to load programs to the board on systems other than Windows you will need to send the `.bin` file raw on a
serial port with the following settings:

````
Baud:            9600
Parity:          None
Data Bits:       8
Stop Bits:       1
Timeout:         OFF
XON/XOFF:        OFF
CTS handshaking: OFF
DSR handshaking: OFF
DSR sensitivity: OFF
DTR circuit:     OFF
RTS circuit:     OFF
````

*Note* you must ensure DTR/RTS are off. The bootloader runs on an Arduino and the Arduino will reset when these signals
are toggled (as the serial port is open). Because of the reset delay your bootloader won't have a chance to see the
bytes you are about to spit out.

To get started with programming your board and for some ideas of new programs you can try to make yourself, read the [Programmers Guide](programmers_guide.md).
