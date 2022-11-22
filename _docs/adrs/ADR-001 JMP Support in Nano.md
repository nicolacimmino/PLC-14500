Status: #Accepted

## Context

Given the lack of an interanal Program Counter (PC) in the MC14500 eventual support for JMP instructions needs to be provided externally. This means a different PC with a preset facility and, short of a cumbersome paging system, a larger Program Memory data path (4 bits are for the instruction, so only 4 are left for the operand).

## Decisions

To keep be BOM low and simplify the board programmers model for the Nano version, it's been decided to not provide JMP capability. The JMP flag though has been connected to the PC reset de -facto hardcoding the JMP instruction to `JMP 0`. The rational behind this is that, while the program space is not too large (256 bytes) and it could be filled with `NOPO`/`NOPF`  (so the program loops around) there are two drawbacks of not supporting `JMP 0`:

- Cumbersome when stepping the program
- Would allow only programs that run a single loop

## Consequences

The chosen approach allows to implement conditionals mixing the `SKZ` and `JMP 0` , which is desirable to have multiple code exectution paths.

The assembler will need to have code preventing assembling any other address than `0` for the `JMP` to avoid confusion for the user. This should be conditional for the Nano.

