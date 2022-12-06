
## REV_A -> REV_B

- Moved LED labelled HI to the left of LO (to match switch direction)

- Added 47K in series to U2 Pin3 OUT (to remove gosthing of outputs on inputs LEDs due to MC14500 W line timing)

- Passed OUT7 through a NOT before triggering TMR0, left LED direct to OUT7 (NE555 triggers on low which makes it hakward without negation as the monostable triggers always once on reset)

- Swapped RV1 Pin3 and Pin1 (so clockwise rotation increases time)

## REV_B Artifacts

![Silk](/documentation/rev_b-silk.svg)
Silk


![Assembly](/documentation/rev_b-assembly.svg)
Assembly


![TopCopper](/documentation/rev_b-top.svg)
Top


![BottomCopper](/documentation/rev_b-bottom.svg)
Bottom


## REV_A Artifacts

![Silk](/documentation/rev_a-silk.svg)
Silk


![Assembly](/documentation/rev_a-assembly.svg)
Assembly


![TopCopper](/documentation/rev_a-top.svg)
Top


![BottomCopper](/documentation/rev_a-bottom.svg)
Bottom
