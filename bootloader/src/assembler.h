#define RES_OK 0
#define RES_ERR 1
#define RES_LEAVE_ASSEMBLER 2

#include <Arduino.h>
#include <EEPROM.h>
#include "hardware.h"

#ifndef __ASSEMBLER_H__
#define __ASSEMBLER_H__

extern byte rxBuffer[];
extern void acquireBusForRead();
extern void readProgramMemory();
extern void releaseBus();

uint8_t processCommand();
void enterAssembler();
void dumpMemory(int start, int end);

#endif
