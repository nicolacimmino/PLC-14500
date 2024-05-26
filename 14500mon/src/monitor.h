#ifndef __ASSEMBLER_H__
#define __ASSEMBLER_H__

#include <Arduino.h>
#include <EEPROM.h>
#include <errno.h>
#include "config.h"
#include "hardware.h"
#include "messages.h"
#include "bootloader.h"
#include "mon14500.h"

#define RES_OK 0
#define RES_ERR 1
#define RES_LEAVE_MONITOR 2

#define CMD_ASSEMBLE 0
#define CMD_DISSASEMBLE 1
#define CMD_LOAD 2
#define CMD_MEMORY 3
#define CMD_HELP 4
#define CMD_TRACE 5
#define CMD_WRITE 6
#define CMD_EXIT 7
#define CMD_SAVE 8
#define CMD_MAX 9

#define TERMINAL_KEY_BACKSPACE 0x7F

#define MON_MAX_INACTIVE_MS 30000

#define MON_DUMP_PER_LINE 8

extern byte rxBuffer[];
extern unsigned long lastActive;
extern void acquireBusForRead();
extern void releaseBus();

uint8_t processCommand();
void enterMonitor();
void dumpMemory(int start, int end);
void disassemble(int start, int end);
void assemble(int address);
void writeMemory(int address);
void trace();
void printDisassemblyLine(int address, bool printNewLine = false);
void printSingleMemoryLocation(int address, bool printNewLine = false);

const char mnemonics[] = "NOP0\0LD  \0LDC \0AND \0ANDC\0OR  \0ORC \0XNOR\0STO \0STOC\0IEN \0OEN \0JMP \0RTN \0SKZ \0NOPF";
const char commands[] = "ADLMHTWXS";

#endif
