#include "bootloader.h"

/**********************************************************************
 * Bootstrap the PLC14500 program memory writing the last received
 * program stored in EEPROM.
 */

void bootstrapPLC14500Board()
{
  acquireBusForWrite();

  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE; address++)
  {
    writeProgramByte(address, EEPROM.read(address));
  }

  releaseBus();
}

/*
 **********************************************************************/

void enterBootloader()
{

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
}

/*
 **********************************************************************/
