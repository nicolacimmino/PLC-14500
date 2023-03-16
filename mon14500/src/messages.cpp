
#include "messages.h"

void printMessage(uint8_t messageId)
{
    char buffer[512];
    strcpy_P(buffer, (char *)pgm_read_word(&(messages[messageId])));
    Serial.print(buffer);
}
