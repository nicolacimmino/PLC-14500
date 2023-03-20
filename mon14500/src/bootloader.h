#include <Arduino.h>
#include <EEPROM.h>

#include "monitor.h"
#include "hardware.h"

#ifndef __BOOTLOADER_H__
#define __BOOTLOADER_H__

void bootstrapPLC14500Board();
void writeProgramByte(byte address, byte data);

#endif