
#ifndef __MESSAGES_H__
#define __MESSAGES_H__

#include <Arduino.h>

const char messageHelp[] PROGMEM =
    "A [START]       ASSEMBLE\r\n"
    "B               BOOTSTRAP\r\n"
    "D [START] [END] DISASSEMBLE\r\n"
    "M [START] [END] DUMP MEMORY\r\n"
    "T               TRACE\r\n"
    "W [START]       WRITE MEMORY\r\n"
    "X               EXIT\r\n";

const char messageBanner[] PROGMEM =
    "PLC14500-NANO\r\n"
    "BOOTLOADER V0.2\r\n"
    "WAITING FOR 256BYTES OF PROGRAM\r\n"
    "PRESS ENTER FOR INTERACTIVE MONITOR.\r\n";

const char *const messages[] PROGMEM = {messageHelp, messageBanner};

#define MESSAGE_HELP_IX 0
#define MESSAGE_BANNER_IX 1

void printMessage(uint8_t messageId);

#endif