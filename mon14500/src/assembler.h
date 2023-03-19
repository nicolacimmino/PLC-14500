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
void printDisassemblyLine(int address, bool printNewLine = false);

const char mnemonics[] = "NOP0\0LD  \0LDC \0AND \0ANDC\0OR  \0ORC \0XNOR\0STO \0STOC\0IEN \0OEN \0JMP \0RTN \0SKZ \0NOPF";
const char commands[] = "ADMHOX";

#define CMD_ASSEMBLE 0
#define CMD_DISSASEMBLE 1
#define CMD_MEMORY 2
#define CMD_HELP 3
#define CMD_OBSERVE 4
#define CMD_EXIT 5
#define CMD_MAX 6

#define TERMINAL_KEY_BACKSPACE 0x7F

#endif
