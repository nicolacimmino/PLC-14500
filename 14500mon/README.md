# 14500MON (PLC14500 Assembler and Monitor)

Your PLC14500 comes preloaded with the 14500MON. This interactive assembler/monitor is an homage, both in the name and
in the syntax, to the classic C64 monitor 64Mon and other similar implementations.

**Note:** while 14500MON is compatible with ALL revisions of the board, early REV.B and a batch of REV.C boards were shipped
without it (the regular bootloader only was provided). You can just use an Arduino IDE to load the sketch on your PLC14500 (Choose Arduino Nano under AVR Boards
and make sure you choose the "Old Bootloader" variant).

To verify if you have the 14500MON already installed, open a terminal program (e.g. PuTTY) and connect to the PLC14500
serial port (9600 BAUD, no parity, 8bits, 1 stop bit). After a few seconds you should receive the prompt:

````
PLC14500-NANO
BOOTLOADER V0.2
WAITING FOR 256BYTES OF PROGRAM
PRESS ENTER FOR INTERACTIVE MONITOR.
````

Press enter and you will be in the monitor. The monitor will exit automatically after 30s of inactivity, or you can exit
by giving the “X” command.

**Note:** while the monitor is active, even if you disconnect the serial port, the bootloader won’t be running and you
will
not be able to flash new programs until it exits.

**Warning:** Depending on the settings used on your terminal app, the first usage of “flash14500.cmd” after exiting the
monitor might not transfer the program correctly. This is because “flash14500.cmd” might end up toggling the serial port
control lines causing the Arduino to reset. This introduces a delay that will make it miss the payload. Any further
flashing after the first will work as expected.

# Commands

The following commands are available in 14500MON and can be listed at any moment by using the “H” command. Just type “H”
at the prompt and press enter.

````
.H
A [START]       ASSEMBLE
D [START] [END] DISASSEMBLE
L [BLOCK]       LOAD
M [START] [END] DUMP MEMORY
S [BLOCK]       SAVE
T TRACE
W [START]       WRITE MEMORY
X EXIT
````

## Assemble

The built-in assembler is a great way to try small programs and see them immediately running on the board. It also gives
you a more down to the machine view of how assembly language is converted to bytecode.

To assemble interactively simply use the “A” command followed by the start address and press enter:

````
.A 0
````

The assembler will reply with something like:

````
.A 0
0000 68 STO 06 .
````

The first four digits are the address and the following number is the memory content at that location. This is followed
by a disassembly of the instruction at that address and the “.” prompt. We can now type a new instruction to be
assembled at this location, for instance “LD 6” and press enter. The instruction will be assembled, written to memory,
and the assembler will move to the next location.

````
.A 0
0000 68 STO 06 .LD 6
0001 76 ORC 07 .
````

We can continue in this way to assemble our program. If we leave a line empty and just press enter the assembler will
move to the next memory location and leave the current one untouched. This is useful for instance to revise the current
program and fix only some instructions if a bug is found.

````
.A 0
0000 68 STO 06 .LD 6
0001 76 ORC 07 .LD 7
0002 7A IEN 07 .
````

Once we are done we can exit the assembler with the “X” command.

````
.A 0
0000 68 STO 06 .LD 6
0001 76 ORC 07 .LD 7
0002 7A IEN 07 .
0003 7B OEN 07 .X
````

**Note:** while you are in the "assemble" command, the board stops executing code. Normal execution will resume once you
exit the assembler. This prevents inconsistencies that could be caused by non-complete code being executed.

**Note:** the program you are assembling is stored in the PLC14500-Nano onboard RAM but is not persisted in the
bootloader storage. If you power cycle the board, the old program will be re-loaded. To persist your changes for the
next boot see the “SAVE” command.

Remember to always press “RST” after modifying the code to ensure your I/O latches start from a clean state.

## Load

The “LOAD” command, invoked with “L”, will cause a program currently in the bootloader EEPROM to be loaded into the
PLC14500-Nano onboard RAM for immediate execution.

The bootloader has four separate blocks of storage that can store one program each. Block 0 is the one loaded by the
bootloader when the board is powered up. The programs in the other three blocks can be loaded only with the “LOAD”
command.

The “L” command takes one argument, that is the block number to be loaded. Block numbers above 3 will cause an error.

````
.L 1
LOADING................
````

**Note:** Remember to always press “RST” after modifying the code to ensure your I/O latches start from a clean state.

## Save

The “SAVE” command, invoked with “S”, will cause the program currently in the PLC14500-Nano onboard RAM to be persisted
in a bootloader EEPROM block for later retrieval.

The bootloader has four separate blocks of storage that can store one program each. Block 0 is the one loaded by the
bootloader when the board is powered up. The programs in the other three blocks can be loaded only with the “LOAD”
command.

The “S” command takes one argument, that is the block number to be loaded. Block numbers above 3 will cause an error.

````
.S 1
SAVING................
````

**Note:** only block 0 can be written from the USB through the bootloader. The other three blocks are meant to be used
by the interactive monitor with the “SAVE” and “LOAD” commands. You can save on block 0, this program will be
automatically loaded next time you boot the board. However, keep in mind if you transfer a program from the USB port
this block will be overridden.

## Disassemble

The disassemble command can be invoked with “D” followed by a start and end address (in hexadecimal). The start address
is optional and, if omitted, 0 will be assumed. The end address is also optional and, if omitted, the program will be
disassembled till the end of program memory.

````
.D 0 5
0000 68 STO 06
0001 76 ORC 07
0002 7A IEN 07
0003 7B OEN 07
0004 61 LD 06
0005 72 LDC 07
````

Each line of the disassembly shows the address, the numeric content of the memory location, and the mnemonic and operand
this translates to. Because the MC14500 has 16 instructions and 4-bit wide instruction bus there are no illegal opcodes,
so any memory content will always produce a valid disassembly.

## Dump Memory

The dump memory command can be invoked with “M” followed by the start and end address (in hexadecimal). The start
address is optional and, if omitted, 0 will be assumed. The end address is also optional and, if omitted, the memory
will be dumped till the end of program memory.

````
.M 0 1F
0000 68.76.7A.7B.61.72.0E.08
0008 81.07.09.89.81.0E.0C.F2
0010 7B.F8.F9.51.68.41.58.31
0018 48.21.38.11.28.01.18.61
````

Each line shows the address of the first byte, followed by the values of the memory content for the following eight
memory locations.

**Note:** if the selected start doesn’t align to an eight byte boundary, values will still be printed in blocks aligned
to the boundary, just with the unwanted values missing. This can be seen in the example below:

````
.M 3 1B
0000 7B.61.72.0E.08
0008 81.07.09.89.81.0E.0C.F2
0010 7B.F8.F9.51.68.41.58.31
0018 48.21.38.11.
````

## Write Memory

The "write memory" command can be invoked with “W” followed by the start address. The start address is optional and, if
omitted, 0 will be assumed. The monitor will show the first address, followed by the current content of that memory
location . A new value can be entered and will be stored in memory when enter is pressed. It’s possible to leave the
line empty and just press enter to skip that memory location without changing its contents.

````
.W A3
00A3 0F .12
00A4 0F .F0
00A5 0F .
00A6 0F .
00A7 0F .X
.
````

**Note:** the program you are entering in this way is stored in the PLC14500-Nano onboard RAM but is not persisted in
the bootloader storage. If you power cycle the board, the old program will be re-loaded. To persist your changes for the
next boot see the “SAVE” command.

Remember to always press “RST” after editing the program to ensure your I/O latches start from a clean state.

## Trace Program Execution

The “Trace Program” mode can be entered using the “T” command. In this mode the monitor will keep outputting the current
instruction being executed.

````
.T
ADDR DATA OP ARG
001B 18 STO 01
001C 61 LD 06
001D 08 STO 00
001E 01 LD 00
001F 88 STO 08
.
````

The output shows the current memory address at which the Program Counter is at, the data in memory at that location and
a disassembly of the instruction. The trace mode will continue until you press a key.

This command is extremely useful when combined with the single step clock as it allows to see the exact instruction
being executed in a more direct way than analysing the LEDs on the board.

**Note:** due to the nature of the PLC14500-Nano bus control, the monitor is not able to keep up with the program being
run at full clock speed (and neither would your eyes). If the trace mode is running with the clock running at full speed
the following error will be displayed:

````
.T
ADDR DATA OP ARG
0004 61 LD 06
0006 0E SKZ
TOO FAST, CAN’T KEEP UP. TURN CLOCK TO LO OR STEP.
````

Changing the clock to LO or STEP will resume the trace at the next clock cycle.

**Note:** there’s no timeout for the trace command. If you leave your board in trace mode the bootloader will not be
able to
receive new programs. If this happens, reconnect to the serial port, press any key and exit the monitor with “X”.
Alternatively you can just unplug and replug the USB cable or reset the Arduino (the RST button on the board itself will
NOT affect the bootloader, just the board PC and I/O latches).
