#include "assembler.h"

uint8_t processCommand()
{
  char *token;

  token = strtok(rxBuffer, " ");

  if (strncmp(token, ".x", 2) == 0)
  {
    Serial.println("Bye!");
    return RES_LEAVE_ASSEMBLER;
  }

  if (strncmp(token, ".m", 2) == 0)
  {
    int start = 0;
    int end = PROGRAM_MEMOMORY_SIZE;

    token = strtok(NULL, " ");
    if (token != NULL)
    {
      start = atoi(token);
    }

    token = strtok(NULL, " ");
    if (token != NULL)
    {
      end = atoi(token);
    }

    dumpMemory(start, end);

    return RES_OK;
  }

  Serial.println("Unknonw command.");

  return RES_ERR;
}

void dumpMemory(int start, int end)
{
  start = start - (start % 16);

  for (int ix = start; ix < end + 1; ix++)
  {
    if (ix % 16 == 0)
    {
      Serial.println("");
      Serial.print(ix);
      Serial.print("  ");
    }
    Serial.print(EEPROM.read(ix), 16);
    Serial.print(".");
  }

  Serial.println("");
}

void enterAssembler()
{
  while (!Serial.available())
  {
    uint8_t ix = 0;
    Serial.println("Assembler v0.1");

    while (true)
    {
      while (Serial.available())
      {
        rxBuffer[ix] = Serial.read();

        Serial.print((char)rxBuffer[ix]);

        if (rxBuffer[ix] == '\r')
        {
          Serial.println("");
          if (processCommand() == RES_LEAVE_ASSEMBLER)
          {
            return;
          }

          ix = 0;

          continue;
        }

        ix++;
      }
    }
  }
}
