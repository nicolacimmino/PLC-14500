Status: #Accepted

## Context

Given the nature of the board (a trainer board), the onboard TMR0 range can be limited, hence simplifying the design.

## Decisions

It's been decided to have a range for TMR0 from 1s to 6s, while this would be way too short for most practical applications, it suites very well the purpose in the context of test apps for which it's not desirable to have long times to wait for an event to happen. The 1s time constant also allows for blinking of an output if desired.

## Consequences

TMR0 can be implemented with a single 555. A 10K trimmer, with a fixed 2K2 resistor will give the desired range with a 470uF cap. 
