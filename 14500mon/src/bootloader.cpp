#include "bootloader.h"

/**********************************************************************
 * Load and run a program that will reset the output latches.
 * Since we ran out of lines that can be used as outputs there was no
 *  convenient way to generate a RST pulse after every new program
 *  load. We work around this by loading in PLC14500 memory a short
 *  program that will set all output latches and SPR to 0 before loading
 *  the actual program we want.
 */

void runResetOutputLatchesProgram()
{
  // The binary below is the result of assembling this:
  //  ORC  RR
  //  IEN  RR
  //  OEN  RR
  //
  //  LD   IN0
  //  ANDC IN0
  //  STO  OUT0
  //  STO  OUT1
  //  STO  OUT2
  //  STO  OUT3
  //  STO  OUT4
  //  STO  OUT5
  //  STO  OUT6
  //
  //  STO  SPR0
  //  STO  SPR1
  //  STO  SPR2
  //  STO  SPR3
  //  STO  SPR4
  //  STO  SPR5
  //  STO  SPR6
  //  STO  SPR7
  //  JMP  0
  byte binary[] = {0x76, 0x7A, 0x7B, 0x81, 0x84, 0x88, 0x98, 0xA8, 0xB8, 0xC8, 0xD8, 0xE8,
                   0x08, 0x18, 0x28, 0x38, 0x48, 0x58, 0x68, 0x78, 0x0C, 0x00};

  acquireBusForWrite();

  int address = 0;
  while (binary[address] != 0)
  {
    writeProgramByte(address, binary[address++]);
  }

  while (address < 0x100)
  {
    writeProgramByte(address++, 0x0F); // NOPF
  }

  releaseBus();

  // Let it run for a moment so we are sure it had a chance to set outputs.
  delay(500);
}

/**********************************************************************
 * Bootstrap the PLC14500 program memory writing the last received
 * program stored in EEPROM.
 */

void loadBlockIntoProgramMemory(byte block)
{
  if (block > MAX_PROGRAM_BLOCK)
  {
    sprintf(printBuffer, "MAX BLOCK %d", MAX_PROGRAM_BLOCK);
    Serial.println(printBuffer);
    return;
  }

  Serial.print(F("LOADING"));

  runResetOutputLatchesProgram();

  acquireBusForWrite();

  uint16_t offset = block * PROGRAM_MEMOMORY_SIZE;

  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE; address++)
  {
    writeProgramByte(address, EEPROM.read(offset + address));

    if (address % 16 == 0)
    {
      Serial.print(F("."));
    }
  }

  releaseBus();

  Serial.println(F(""));
}

/*
 **********************************************************************/

/**********************************************************************
 * Persist the PLC14500 program memory to EEPROM.
 */

void savePrgoramMemoryToBlock(byte block)
{
  if (block > MAX_PROGRAM_BLOCK)
  {
    sprintf(printBuffer, "MAX BLOCK %d", MAX_PROGRAM_BLOCK);
    Serial.println(printBuffer);
    return;
  }

  Serial.print(F("SAVING"));

  uint16_t offset = block * PROGRAM_MEMOMORY_SIZE;

  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE; address++)
  {
    EEPROM.write(offset + address, programMemoryShadow[address]);

    if (address % 16 == 0)
    {
      Serial.print(F("."));
    }
  }

  Serial.println(F(""));
}

/*
 **********************************************************************/

/**********************************************************************
 * Enter the bootloader and wait for PROGRAM_MEMOMORY_SIZE. We need to
 *  store the program in RAM first as writing it to the board
 *  and local EEPROM would cause the Arduino serial RX buffer
 *  to overflow.
 * 
 * Returns:
 * 
 *  BOOT_OK: All good, new program in rxBuffer can be loaded to the 
 *            PLC14500 RAM.
 * 
 *  BOOT_TIMEOUT: Some data received but timedout before receiving a 
 *            full program. Restart bootloader.
 * 
 *  BOOT_ENTER_MONITOR: User wants to enter the interactive monitor.
 */

uint8_t enterBootloader()
{
  printMessage(MESSAGE_BOOTLOADER_BANNER_IX);

  while (!Serial.available())
    ;

  unsigned long rxStartTime = millis();
  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE;)
  {
    if (millis() - rxStartTime > RX_TIMEOUT_MS)
    {
      if (rxBuffer[0] == '\r')
      {
        return BOOT_ENTER_MONITOR;
      }

      Serial.print("BOOTLOADER TIMEOUT. RX BYYES: ");
      Serial.println(address);

      return BOOT_TIMEOUT;
    }

    if (Serial.available())
    {
      rxBuffer[address] = Serial.read();
      address++;
    }
  }

  return BOOT_OK;
}

/**********************************************************************
 * Write one byte to the PLC14500 program memory.
 * 
 * NOTE! If you opt for an EEPROM you will need to change the delay below
 *  to 15mS to give time to the EEPROM to correctly write.
 */

void writeProgramByte(byte address, byte data)
{
  digitalWrite(WEN_PIN, HIGH);

  for (int ix = 0; ix < 8; ix++)
  {
    digitalWrite(addr_bus[ix], (address >> ix) & 1);
  }

  for (int ix = 0; ix < 8; ix++)
  {
    digitalWrite(data_bus[ix], (data >> ix) & 1);
  }

  delay(1);
  digitalWrite(WEN_PIN, LOW);
  // Note: this needs to be 15mS for EEPROMs.
  delay(1);
  digitalWrite(WEN_PIN, HIGH);

  programMemoryShadow[address] = data;
}

/*
 **********************************************************************/
