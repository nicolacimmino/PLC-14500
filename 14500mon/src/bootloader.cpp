#include "bootloader.h"

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
