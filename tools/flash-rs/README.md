# flash-rs (PLC14500 Program Flasher and Interactive Monitor Terminal Emulator)
flash-rs will upload a program to the PLC14500 and then provide access to the interactive monitor.

## Use
First install a Rust compiler.  You can find one [here](https://www.rust-lang.org/tools/install).  Then, build the flash-rs for your machine by running the following command anywhere within the flash-rs project  
`cargo build`  

An executable will now be present in the target directory, and you can run the executable directly or use  
`cargo run`

## Syntax
`./flash-rs <program filepath> <serial port interface>`  
Example:  
`./flash-rs example.bin /dev/ttyUSB0`

There's a number of different ways to produce a program.  See the [Getting Started of this repository](https://github.com/nicolacimmino/PLC-14500/blob/master/README.md) as well as the [Assembler Repository](https://github.com/nicolacimmino/plc-14500-assembler).

## Known issues
* When using the trace feature, you cannot exit the trace by pressing X.  You can get out by setting the speed switch to HI to cause an error or by pressing the reset switch on the Arduino.
