
Many years ago I came across an article on an electronics magazine that presented a little circuit based on the Motorola MC14500 1-bit ICU (Industrial Control Unit). The circuit was very simple and allowed to control the ICU manually through a set of dip-switches and buttons. I never bothered to build it, though I got fascinated by the simplicity of the ICU and the 1-bit idea. The simple circuit though didn't convince me as it didn't sound much fun to give the instructions one by one everytime you wanted to execute a program. Reading more about the MC14500 I started to think it would have been cool to make a simple PLC based on it. Since then I never really got around doing it but the schematic somehow came clear in my head, yes I do see things sometimes :) Till this weekend I finally set down to actually wire wrap it.

![Board](documentation/board.jpg)

The board is now fully functional, after spending few hours to find a glitch and a couple of shorts and broken connections fixed. The glitch was on the control logic of the ouput latch and it quite surprised me since I have layed out this part exactly as it appears in many application notes of the time. More info about this below.

I am in the process of creating the schematic, for now just know that there is fundametally an 8 bit counter working as Program Counter (PC), a 2K EEPROM with the higher 3 address bits controlled by a DIP-switch to allow 8 different programs, the actual MC14500 ICU, a CD4099 as output latch and a CD4051 as input selector. The rest is glue logic and some optocouples and transistors to drive the realys.

I am clocking the board at the moment at few hundred hertz, which gives reasonable response time as the programs are naturally short. There is DIP-switch allowing to running to few hertz so you can see the lights on the buses and control lines moving.

EEPROM programming happens through the 20 pins header where all data and address lines, along with write enable and programming signals are available. 

