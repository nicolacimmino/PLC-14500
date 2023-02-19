
This is all work in progress and I'm experimenting with this. However, the current iteration seemed to work well
enough so I thought I'd put it out here.

This is an alternative way of assembling programs for the PLC14500 that takes advantage of the configurability of
the cc65 assembler ( https://cc65.github.io/ ).

The magic is done mostly in `plc14500-nano-b.inc`. This file is heavily based on work by Yaroslav Veremenko
(original: https://github.com/veremenko-y/mc14500-programs/blob/main/sbc1/system.inc ). I modified the IN/OUT/SPR 
addresses to match the PLC14500 I/O layout and swapped the command/address nibbles as these are in opposite order.

`build.cmd` contains all you need to assemble a `.asm` file. Just invoke it with:

`build.cmd test.asm`

and it will produce a `.bin` file in the `.build` folder.

You need to make sure you have downloaded and installed cc65 ( https://cc65.github.io/ ) and that its `bin` folder has
been added to the `PATH`.

Also, as expected, the syntax of the assembly code will be slightly different than the one from the examples provided
in the assembler folder. I have included here `examples\example6.asm` to get you started, I'll port also the others
in due time if this seems to pan out well.



