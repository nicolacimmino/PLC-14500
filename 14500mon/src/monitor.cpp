#include "monitor.h"

unsigned long lastActive;

/**********************************************************************
 * Enter the interactive monitor. 
 * This function will return either after MON_MAX_INACTIVE_MS, if no
 * activity, or when the user exits with "X".
 * 
 */

void enterMonitor()
{
  uint8_t ix = 0;

  printMessage(MESSAGE_MONITOR_BANNER_IX);

  lastActive = millis();

  while (true)
  {
    if (millis() - lastActive > MON_MAX_INACTIVE_MS)
    {
      Serial.println("");
      return;
    }

    while (Serial.available())
    {
      lastActive = millis();
      rxBuffer[ix] = toupper(Serial.read());

      Serial.print((char)rxBuffer[ix]);

      if (rxBuffer[ix] == TERMINAL_KEY_BACKSPACE && ix > 0)
      {
        ix--;
        continue;
      }

      if (rxBuffer[ix] == '\r')
      {
        Serial.println(F(""));
        if (processCommand() == RES_LEAVE_MONITOR)
        {
          return;
        }

        ix = 0;
        Serial.print(F("\r\n" MONITOR_PROMPT));
        continue;
      }

      if (ix < RX_BUFFER_SIZE)
      {
        ix++;
      }
    }
  }
}

/*
 **********************************************************************/

/**********************************************************************
 * Process the user command.
 * 
 * Returns:
 *  RES_OK              Command processed successfully.
 *  RES_ERR             Error while processing command.
 *  RES_LEAVE_MONITOR   User wants to leave the monitor.
 */

uint8_t processCommand()
{
  char *token = strtok(rxBuffer, " ");

  byte command = CMD_MAX;
  for (byte ix = 0; ix < CMD_MAX; ix++)
  {
    if (strncmp(token, commands + ix, 1) == 0)
    {
      command = ix;
      break;
    }
  }

  int p0 = 0;
  int p1 = PROGRAM_MEMOMORY_SIZE - 1;

  token = strtok(NULL, " ");
  if (token != NULL)
  {
    p0 = strtoul(token, NULL, 16);
  }

  token = strtok(NULL, " ");
  if (token != NULL)
  {
    p1 = strtoul(token, NULL, 16);
  }

  if (command == CMD_ASSEMBLE || command == CMD_WRITE)
  {
    acquireBusForWrite();
  }

  switch (command)
  {
  case CMD_ASSEMBLE:
    assemble(p0);
    break;
  case CMD_DISSASEMBLE:
    disassemble(p0, p1);
    break;
  case CMD_LOAD:
    loadBlockIntoProgramMemory(p0);
    break;
  case CMD_SAVE:
    savePrgoramMemoryToBlock(p0);
    break;
  case CMD_MEMORY:
    dumpMemory(p0, p1);
    break;
  case CMD_HELP:
    printMessage(MESSAGE_HELP_IX);
    break;
  case CMD_TRACE:
    trace();
    break;
  case CMD_WRITE:
    writeMemory(p0);
    break;
  case CMD_EXIT:
    Serial.println(F("BYE!"));
    return RES_LEAVE_MONITOR;
    break;
  default:
    Serial.println(F("UNKNOWN COMMAND."));
    return RES_ERR;
  }

  if (command == CMD_ASSEMBLE || command == CMD_WRITE)
  {
    releaseBus();
  }

  return RES_OK;
}

/*
 **********************************************************************/

/**********************************************************************
 * Assemble user input to bytecode.
 * 
 * NOTE: this writes the Arduino EEPROM section that acts as a hardcopy
 *  of the program and not directly to the PLC14500 RAM. The changes
 *  will not be reflected in the PLC14500 RAM until the board is 
 *  bootstrapped.
 */

void assemble(int address)
{
  char *token;
  byte rxBufferIx = 0;

  while (true)
  {
    printDisassemblyLine(address);
    Serial.print(MONITOR_PROMPT);

    while (true)
    {
      while (Serial.available())
      {
        lastActive = millis();

        rxBuffer[rxBufferIx] = toupper(Serial.read());

        if (rxBuffer[rxBufferIx] == TERMINAL_KEY_BACKSPACE && rxBufferIx > 0)
        {
          rxBufferIx--;
          Serial.print((char)TERMINAL_KEY_BACKSPACE);
          continue;
        }

        Serial.print((char)rxBuffer[rxBufferIx]);

        if (rxBuffer[rxBufferIx] == '\r')
        {
          token = strtok(rxBuffer, " ");

          if (strncmp(token, "X", 1) == 0)
          {
            Serial.println("");

            return;
          }

          bool success = false;
          for (byte opcode = 0; opcode < 16; opcode++)
          {
            if (strncmp(token, mnemonics + (5 * opcode), strlen(token)) == 0)
            {
              byte arg = 0;
              token = strtok(NULL, " ");
              if (token != NULL)
              {
                errno = 0;
                if (strncmp("IN", token, 2) == 0)
                {
                  arg = 8 + strtoul(token + 2, NULL, 10);
                }
                else if (strncmp("OUT", token, 3) == 0)
                {
                  arg = 8 + strtoul(token + 3, NULL, 10);
                }
                else if (strncmp("SPR", token, 3) == 0)
                {
                  arg = strtoul(token + 3, NULL, 10);
                }
                else if (strncmp("RR", token, 2) == 0)
                {
                  arg = 7;
                }
                else if (strncmp("TMR0-TRIG", token, 9) == 0)
                {
                  arg = 15;
                }
                else if (strncmp("TMR0-OUT", token, 8) == 0)
                {
                  arg = 15;
                }
                else
                {
                  arg = strtoul(token, NULL, 16);
                }
              }

              if (errno != 0)
              {
                Serial.println("\r\nERROR");
                break;
              }

              writeProgramByte(address, opcode | (arg << 4));

              success = true;
              break;
            }
          }

          rxBufferIx = 0;

          if (rxBuffer[rxBufferIx] == '\r')
          {
            success = true;
          }

          if (success)
          {
            address = (address + 1) % PROGRAM_MEMOMORY_SIZE;
            Serial.println("");
          }
          else
          {
            Serial.println("\r\nERROR");
          }
          printDisassemblyLine(address);
          Serial.print(MONITOR_PROMPT);

          break;
        }

        rxBufferIx++;
      }
    }
  }
}

/*
 **********************************************************************/

/**********************************************************************
 * Write the program memory.
 * 
 * NOTE: this writes the Arduino EEPROM section that acts as a hardcopy
 *  of the program and not directly to the PLC14500 RAM. The changes
 *  will not be reflected in the PLC14500 RAM until the board is 
 *  bootstrapped.
 */

void writeMemory(int address)
{
  byte rxBufferIx = 0;
  char *token;

  printSingleMemoryLocation(address);

  while (true)
  {

    while (Serial.available())
    {
      lastActive = millis();

      rxBuffer[rxBufferIx] = toupper(Serial.read());

      Serial.print((char)rxBuffer[rxBufferIx]);

      if (rxBuffer[rxBufferIx] == TERMINAL_KEY_BACKSPACE && rxBufferIx == 0)
      {
        continue;
      }

      if (rxBuffer[rxBufferIx] == TERMINAL_KEY_BACKSPACE && rxBufferIx > 0)
      {
        rxBufferIx--;
        continue;
      }

      if (rxBuffer[rxBufferIx] == '\r')
      {
        Serial.println(F(""));

        token = strtok(rxBuffer, " ");

        if (strncmp(token, "X", 1) == 0)
        {
          return;
        }

        if (rxBufferIx > 0)
        {
          writeProgramByte(address, strtoul(token, NULL, 16));
        }

        rxBufferIx = 0;

        address = (address + 1) % PROGRAM_MEMOMORY_SIZE;

        printSingleMemoryLocation(address);

        continue;
      }

      if (rxBufferIx < RX_BUFFER_SIZE)
      {
        rxBufferIx++;
      }
    }
  }
}

/*
 **********************************************************************/

/**********************************************************************
 * Dump program memory MON_DUMP_PER_LINE bytes per line.
 * 
 */

void dumpMemory(int start, int end)
{
  for (int address = start - (start % MON_DUMP_PER_LINE); address < end + 1; address++)
  {
    if (address % MON_DUMP_PER_LINE == 0)
    {
      sprintf(printBuffer, "%04X  ", address);
      Serial.print(printBuffer);
    }

    if (address < start)
    {
      Serial.print("   ");
      continue;
    }

    sprintf(printBuffer,
            "%02X%s",
            programMemoryShadow[address],
            ((address % MON_DUMP_PER_LINE) != (MON_DUMP_PER_LINE - 1)) ? "." : "\r\n");
    Serial.print(printBuffer);
  }

  if (end % MON_DUMP_PER_LINE != (MON_DUMP_PER_LINE - 1))
  {
    Serial.println("");
  }
}

/*
 **********************************************************************/

/**********************************************************************
 * Dump the program being executed in real time.
 * 
 */

void trace()
{
  unsigned long lastChangeTime = 0;
  bool inTooFastAlarm = false;

  acquireBusForRead();

  Serial.println(F("ADDR  DATA  OP   ARG"));

  byte lastAddress = 0;

  while (true)
  {
    byte address = readAddressFromBus();

    if (!inTooFastAlarm)
    {
      printDisassemblyLine(address, true);
    }

    lastAddress = address;

    while (lastAddress == readAddressFromBus())
    {
      if (Serial.available())
      {
        while (Serial.available())
        {
          Serial.read();
        }

        lastActive = millis();

        return;
      }
    }

    if (millis() - lastChangeTime < 100)
    {
      if (!inTooFastAlarm)
      {
        Serial.println(F("TOO FAST, CAN’T KEEP UP. TURN CLOCK TO LO OR STEP."));
        inTooFastAlarm = true;
      }
    }
    else
    {
      inTooFastAlarm = false;
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

/*
 **********************************************************************/

/**********************************************************************
 * Helper to print a single memory location formatted.
 * 
 */

void printSingleMemoryLocation(int address, bool printNewLine = false)
{
  sprintf(printBuffer, "%04X  %02X .", address, programMemoryShadow[address]);
  Serial.print(printBuffer);

  if (printNewLine)
  {
    Serial.println(F(""));
  }
}

/*
 **********************************************************************/

/**********************************************************************
 * Helper to print a single memory location with raw content and
 *  dissassembled code.
 * 
 */

void printDisassemblyLine(int address, bool printNewLine = false)
{
  byte byteCode = programMemoryShadow[address];
  byte opcode = byteCode & 0xF;

  sprintf(printBuffer, "%04X  %02X    %s", address, byteCode, mnemonics + (5 * opcode));
  Serial.print(printBuffer);

  // NOPO and all instructions after JMP take no argument.
  if (opcode == 0 || opcode > 12)
  {
    Serial.print(printNewLine ? "    \r\n" : "    ");

    return;
  }

  if (opcode == 12)
  {
    // JMP doesn't address I/O.
    sprintf(printBuffer, " %02X%s", byteCode >> 4, (printNewLine ? " \r\n" : " "));
  }
  else
  {
    // Print readable label.
    uint8_t op = byteCode >> 4;

    if (op < 7)
    {
      sprintf(printBuffer, " %s%01X%s", "SPR", op, (printNewLine ? " \r\n" : " "));
    }
    else if (op == 7)
    {
      sprintf(printBuffer, " %s%s", "RR", (printNewLine ? " \r\n" : " "));
    }
    else if (op > 7 && op < 15)
    {
      // STO/STOC are the only write operations. A write always writes to the output block
      // which is shadowed at the same addresses of read.
      if (opcode == 8 || opcode == 9)
      {
        sprintf(printBuffer, " %s%01X%s", "OUT", op - 8, (printNewLine ? " \r\n" : " "));
      }
      else
      {
        sprintf(printBuffer, " %s%01X%s", "IN", op - 8, (printNewLine ? " \r\n" : " "));
      }
    }
    else if (op == 15)
    {
      // STO/STOC are the only write operations. A write always writes to the timer trigger
      // which is shadowed at the same addresses of the timer output.
      if (opcode == 8 || opcode == 9)
      {
        sprintf(printBuffer, " %s%s", "TMR0-TRIG", (printNewLine ? " \r\n" : " "));
      }
      else
      {
        sprintf(printBuffer, " %s%s", "TMR0-OUT", (printNewLine ? " \r\n" : " "));
      }
    }
    else
    {
      sprintf(printBuffer, " %01X%s", op, (printNewLine ? " \r\n" : " "));
    }
  }

  Serial.print(printBuffer);
}

/*
 **********************************************************************/
