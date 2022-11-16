Status: #Accepted

## Context

Given the limited board space and the amount of components the silk screen for the top layer is rather cluettered. This doesnt sit well with the nature of the board which is in itself a display. The user needs to clearly identify the LEDs functions (eg address bus, inputs, outputs, SPR etc.).

## Decisions

It's been decided to keep the silk screen content unclattered and give prominence to the text relevant to the user during normal usage (as opposed to the assembly phase). This can be achieved by moving all components references under the component itself where possible, so it won't be visible after assembly. Where not possible to fit it under the component it will be hidden completely.

## Consequences

To aid the user in the kit assembly a layout of the components will need to be provided in printed form. This is available from KiCad as the `F.Fab` layer. 

