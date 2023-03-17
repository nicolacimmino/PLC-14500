#include "assembler.h"

char printBuffer[32];

uint8_t processCommand()
{
  char *token;

  token = strtok(rxBuffer, " ");

  if (strncmp(token, ".x", 2) == 0)
  {
    Serial.println("Bye!");
    return RES_LEAVE_ASSEMBLER;
  }

  if (strncmp(token, ".h", 2) == 0)
  {
    printMessage(MESSAGE_HELP_IX);
  }

  if (strncmp(token, ".s", 2) == 0)
  {
    watchStatus();
  }

  int start = 0;
  int end = PROGRAM_MEMOMORY_SIZE - 1;

  if (strncmp(token, ".m", 2) == 0)
  {
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

  if (strncmp(token, ".d", 2) == 0)
  {
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

    disassemble(start, end);

    return RES_OK;
  }

  Serial.println("Unknonw command.");

  return RES_ERR;
}

void watchStatus()
{
  unsigned long lastChangeTime = 0;

  acquireBusForRead();

  Serial.println("ADDR  DATA  OP    ARG");

  byte lastAddress = 0;

  while (true)
  {
    byte byteCode = readDataFromBus();
    byte opcode = byteCode & 0xF;
    byte address = readAddressFromBus();

    if (opcode == 0 || opcode > 12)
    {
      sprintf(printBuffer, "%04X  %02X    %s           \r",
              address,
              byteCode,
              mnemonics + (5 * (byteCode & 0xF)));
    }
    else
    {
      sprintf(printBuffer, "%04X  %02X    %s  %01X     \r",
              address,
              byteCode,
              mnemonics + (5 * (byteCode & 0xF)),
              byteCode >> 4);
    }

    Serial.println(printBuffer);

    lastAddress = address;

    while (lastAddress == readAddressFromBus())
    {
      if (Serial.available())
      {
        while (Serial.available())
        {
          Serial.read();
        }

        return;
      }
    }

    if (millis() - lastChangeTime < 10)
    {
      Serial.println("Too fast, can't keep up. Turn clock to LO or STEP.");
      return;
    }

    lastChangeTime = millis();
  }

  releaseBus();
}

void disassemble(int start, int end)
{
  for (int ix = start; ix < end + 1; ix++)
  {
    byte byteCode = EEPROM.read(ix);
    byte opcode = byteCode & 0xF;

    sprintf(printBuffer, "%04X  %02X  %s ", ix, byteCode, mnemonics + (5 * opcode));
    Serial.print(printBuffer);

    if (opcode == 0 || opcode > 12)
    {
      Serial.println("");
      continue;
    }

    Serial.println(byteCode >> 4);
  }
}

void dumpMemory(int start, int end)
{
  for (int ix = start - (start % 16); ix < end + 1; ix++)
  {
    if (ix % 16 == 0)
    {
      sprintf(printBuffer, "\r\n%04X  ", ix);
      Serial.print(printBuffer);
    }

    if (ix < start)
    {
      Serial.print("   ");
      continue;
    }

    sprintf(printBuffer, "%02X", EEPROM.read(ix));
    Serial.print(printBuffer);

    if (ix % 16 != 15)
    {
      Serial.print(".");
    }
  }

  Serial.println("");
}

void enterAssembler()
{
  while (!Serial.available())
  {
    uint8_t ix = 0;
    Serial.println("Assembler v0.1");
    Serial.print(">");

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
          Serial.print(">");
          continue;
        }

        ix++;
      }
    }
  }
}
