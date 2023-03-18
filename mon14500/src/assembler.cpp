#include "assembler.h"

char printBuffer[32];

uint8_t processCommand()
{
  char *token = strtok(rxBuffer, " ");

  byte command = CMD_MAX;
  for (byte ix = 0; ix < CMD_MAX; ix++)
  {
    if (strncmp(token, commands + (2 * ix), 2) == 0)
    {
      command = ix;
      break;
    }
  }

  int start = 0;
  int end = PROGRAM_MEMOMORY_SIZE - 1;

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

  switch(command)
  {
  case CMD_ASSEMBLE:
    assemble(start);
    break;
  case CMD_DISSASEMBLE:
    disassemble(start, end);
    break;
  case CMD_MEMORY:
    dumpMemory(start, end);
    break;
  case CMD_HELP:
    printMessage(MESSAGE_HELP_IX);
    break;
  case CMD_OBSERVE:
    watchStatus();
    break;
  case CMD_EXIT:
    Serial.println("Bye!");
    return RES_LEAVE_ASSEMBLER;
    break;
  default:
    Serial.println("Unknonw command.");
    return RES_ERR;
  }

  return RES_OK;
}

void watchStatus()
{
  unsigned long lastChangeTime = 0;

  acquireBusForRead();

  Serial.println("ADDR  DATA  OP    ARG");

  byte lastAddress = 0;

  while (true)
  {
    byte address = readAddressFromBus();

    printDisassemblyLine(address, true);

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

    if (millis() - lastChangeTime < 100)
    {
      Serial.println("Too fast, can't keep up. Turn clock to LO or STEP.");
      return;
    }

    lastChangeTime = millis();
  }

  releaseBus();
}

void disassemble(int address, int end)
{
  for (; address < end + 1; address++)
  {
    printDisassemblyLine(address, true);
  }
}

void printDisassemblyLine(int address, bool printNewLine = false)
{
  byte byteCode = EEPROM.read(address);
  byte opcode = byteCode & 0xF;

  sprintf(printBuffer, "%04X  %02X    %s", address, byteCode, mnemonics + (5 * opcode));
  Serial.print(printBuffer);

  if (opcode == 0 || opcode > 12)
  {
    Serial.print(printNewLine ? "   \r\n" : "   ");

    return;
  }

  sprintf(printBuffer, " %02X%s", byteCode >> 4, (printNewLine ? "   \r\n" : "   "));
  Serial.print(printBuffer);
}

void assemble(int address)
{
  char *token;
  byte rxBufferIx = 0;

  while (true)
  {
    printDisassemblyLine(address);
    Serial.print(">");

    while (true)
    {

      while (Serial.available())
      {
        rxBuffer[rxBufferIx] = toupper(Serial.read());

        Serial.print((char)rxBuffer[rxBufferIx]);

        if (rxBuffer[rxBufferIx] == '\r')
        {
          token = strtok(rxBuffer, " ");

          if (strncmp(token, ".X", 2) == 0)
          {
            Serial.println("");

            return;
          }

          for (byte opcode = 0; opcode < 16; opcode++)
          {
            if (strncmp(token, mnemonics + (5 * opcode), strlen(token)) == 0)
            {
              byte arg = 0;
              token = strtok(NULL, " ");
              if (token != NULL)
              {
                arg = atoi(token);
              }

              EEPROM.write(address, opcode | (arg << 4));

              break;
            }
          }

          rxBufferIx = 0;
          address = (address + 1) % PROGRAM_MEMOMORY_SIZE;

          Serial.println("");
          printDisassemblyLine(address);
          Serial.print(">");

          break;
        }

        rxBufferIx++;
      }
    }
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
        rxBuffer[ix] = toupper(Serial.read());

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
