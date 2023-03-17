Status: #Accepted

## Context

The original design of the board doesn't map the MC14500 RR output to the I/O bus. This means that
the OEN instruction cannot be used to its full power to create conditional IF/ELSE blocks.

## Decisions

Reduce SPR size to 7 bits and use SPR7 as an input wired directly to the MC14500 RR pin.

## Consequences

Board needs to be adapted and bumped to REV.C
Assembler needs to be updated to define a RR label.
SPR7 won't be anymore usable for write and reading it will always return RR.
