
#ifndef __MESSAGES_H__
#define __MESSAGES_H__

#include <Arduino.h>

const char messageHelp[] PROGMEM =
    ".d Disassemble\r\n"
    ".m Dump Memory\r\n"
    ".x Exit\r\n";

const char *const messages[] PROGMEM = {messageHelp};

#define MESSAGE_HELP_IX 0

void printMessage(uint8_t messageId);

#endif