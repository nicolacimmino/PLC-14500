
#ifndef __MESSAGES_H__
#define __MESSAGES_H__

#include <Arduino.h>
#include "config.h"
#include "mon14500.h"

#define MESSAGE_HELP_IX 0
#define MESSAGE_BOOTLOADER_BANNER_IX 1
#define MESSAGE_MONITOR_BANNER_IX 2

#define MONITOR_PROMPT "."

const char messageHelp[] PROGMEM =
    "A [START]       ASSEMBLE\r\n"    
    "D [START] [END] DISASSEMBLE\r\n"
    "L [BLOCK]       LOAD\r\n"
    "M [START] [END] DUMP MEMORY\r\n"
    "S [BLOCK]       SAVE\r\n"
    "T               TRACE\r\n"
    "W [START]       WRITE MEMORY\r\n"
    "X               EXIT\r\n";

const char bootloaderBanner[] PROGMEM =
    "PLC14500-NANO\r\n"
    "BOOTLOADER V" STR(__BOOTLOADER_VERSION_MAJOR__) "." STR(__BOOTLOADER_VERSION_MINOR__) "\r\n"
    "WAITING FOR " STR(PROGRAM_MEMOMORY_SIZE) " BYTES OF PROGRAM\r\n"
    "PRESS ENTER FOR INTERACTIVE MONITOR.\r\n";
    
const char monitorBanner[] PROGMEM =
    "14500MON V" STR(__MONITOR_VERSION_MAJOR__) "." STR(__MONITOR_VERSION_MINOR__) "\r\n" MONITOR_PROMPT;

const char *const messages[] PROGMEM = {messageHelp, bootloaderBanner, monitorBanner};

void printMessage(uint8_t messageId);

#endif