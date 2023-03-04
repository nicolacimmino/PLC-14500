
## REV_A -> REV_B

- Moved LED labelled HI to the left of LO (to match switch direction)

- Added 47K in series to U2 Pin3 OUT (to remove gosthing of outputs on inputs LEDs due to MC14500 W line timing)

- Passed OUT7 through a NOT before triggering TMR0, left LED direct to OUT7 (NE555 triggers on low which makes it hakward without negation as the monostable triggers always once on reset)

- Swapped RV1 Pin3 and Pin1 (so clockwise rotation increases time)


*NOTE* REV.A was never on sale, it was a pre-production proto. If you have got a REV.A you either got a
knockoff by someone who got the gerbers in the early days or somehow you got hold of a display unit
from a museum.

## REV_B -> REV_C

- Replaced SPR7 with RR so that RR can be read at IO $7 

If you have a REV.B and you are interested in experimenting with the ION/OEN driven if/else structures
described in the Motorola's own MC14500 Handbook, you will need a tiny modification to the board. This
will replace SPR7 input signal with RR so that you can control IEN/OEN registers fully.

- Cut pin 1 of U13 (isolates the Q7 output of the CD4099, leaving what used to be SPR7 floating )
- Connect the **pad** of pin 1 of U13 to pin 15 of U10 (thus connecting the MC14500 RR to what used to be SPR7 input)
- If having the SPR7 LED confuses you, cut LED D50

## REV_C Artifacts

![Silk](/documentation/rev_c-silk.svg)
Silk


![Assembly](/documentation/rev_c-assembly.svg)
Assembly


![TopCopper](/documentation/rev_c-top.svg)
Top


![BottomCopper](/documentation/rev_c-bottom.svg)
Bottom



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
