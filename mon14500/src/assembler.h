#define RES_OK 0
#define RES_ERR 1
#define RES_LEAVE_ASSEMBLER 2

#include <Arduino.h>
#include <EEPROM.h>
#include "hardware.h"
#include "messages.h"

#ifndef __ASSEMBLER_H__
#define __ASSEMBLER_H__

extern byte rxBuffer[];
extern void acquireBusForRead();
extern void releaseBus();

uint8_t processCommand();
void enterAssembler();
void dumpMemory(int start, int end);
void disassemble(int start, int end);
void assemble(int address);
void watchStatus();

const char mnemonics[] = "NOP0\0LD  \0LDC \0AND \0ANDC\0OR  \0ORC \0XNOR\0STO \0STOC\0IEN \0OEN \0JMP \0RTN \0SKZ \0NOPF";

#endif
