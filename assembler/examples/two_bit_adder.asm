;
; 2-Bit Adder
; Example of bit slicing where the single bit data path is used to compute
;   the sum of two 2-Bit numbers (A1-A0 and B1-B0) resulting in a 3-Bit result
;   (R3-R0).

.board=PLC14500-Nano

; First Operand (A)
.io_A1=IN0
.io_A0=IN1

; Second Operand (B)
.io_B1=IN2
.io_B0=IN3

; Result (R)
.io_R0=OUT0
.io_R1=OUT1
.io_R2=OUT2

; Temporary storage
.io_C0=SPR0
.io_T0=SPR1

ORC     RR          ; RR=RR|!RR (always 1)
IEN     RR          ; Enable inputs
OEN     RR          ; Enable outputs

; Half adder A0+B0 => R0, carry in C0

LD      A0          ; Perform an XOR of A0 and B0
XNOR    B0          ;
STOC    R0          ;

LD      A0          ; Compute the carry (C0)
AND     B0	        ;
STO     C0          ;

; Full adder A1+B1+C0 => R1

LD      A1          ; XOR A1 and B1
XNOR 	B1	        ;
LDC     RR          ;
STO     T0          ; Store the intermediate result for later usage.
XNOR    C0          ; XOR with C0 to get R1
STOC    R1          ;

; C1 to R2

LD      T0          ; Compute the carry of A1+B1+C0 which
AND     C0          ;  which is in fact our last output bit R2.
STO     T0          ;
LD      A1          ;
AND     B1          ;
OR      T0          ;
STO     R2          ;

JMP 0
