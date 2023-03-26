
#ifndef __BOOTLOADER_H__
#define __BOOTLOADER_H__

#include <Arduino.h>
#include <EEPROM.h>
#include "monitor.h"
#include "hardware.h"

#define RX_TIMEOUT_MS 1000

#define BOOT_ENTER_MONITOR 1
#define BOOT_TIMEOUT 2
#define BOOT_OK 3

void bootstrapPLC14500Board();
uint8_t enterBootloader();
void writeProgramByte(byte address, byte data);

#endif