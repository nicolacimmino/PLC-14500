
#include "messages.h"

/**********************************************************************
 * Print one of the predefined messages to the serial port.
 * This allows to include complex messages in the PROGMEM.
 */

void printMessage(uint8_t messageId)
{
    strcpy_P(printBuffer, (char *)pgm_read_word(&(messages[messageId])));
    Serial.print(printBuffer);
}

/*
 *
 ***********************************************************************/
