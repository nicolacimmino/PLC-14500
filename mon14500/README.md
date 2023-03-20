# MON14500

PLC14500 Assembler and Monitor

This is heavily work in progress. Replaces the regular bootloader and offers an interactive interface to play with
the board from a serial terminal.

This is not part of the current release, mostly because I didn't come around to test it fully. If you feel adventurous
you can try to load this, using an Arduino IDE on your board. It will replace the bootloader (which works as before),
and provide an interactive monitor/assembler.

No documentation yet, this is all you get: connect with a terminal to the serial port (9600,n,8,1), wait for a banner
and press enter. You will be greeted by a prompt (a single `.`). Type "H" and enter and see a list of commands for
yourself.

If you encounter any issues and wish to revert back to the regular, and tested, bootloader you will find it in the 
`bootloader` folder in this repo, just transfer the sketch to the board with an Arduino IDE.

Comments and suggestions welcome, please use GitHub Discussions section.




