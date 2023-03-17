
#include "hardware.h"

/**********************************************************************
 *  Acquire the PLC14500 data and address buses by setting the 
 *  program counter and RAM to High-Z outputs (WEN and PRG pin),
 *  and then setting our lines to output (avoid bus contention).
 */

void acquireBusForWrite()
{
  digitalWrite(WEN_PIN, HIGH);
  digitalWrite(PRG_PIN, HIGH);

  for (int ix = 0; ix < 8; ix++)
  {
    pinMode(addr_bus[ix], OUTPUT);
    pinMode(data_bus[ix], OUTPUT);
  }
}

void acquireBusForRead()
{
  digitalWrite(WEN_PIN, HIGH);
  digitalWrite(PRG_PIN, LOW);

  for (int ix = 0; ix < 8; ix++)
  {
    pinMode(addr_bus[ix], INPUT);
    pinMode(data_bus[ix], INPUT);
  }
}

byte readAddressFromBus()
{
  byte address = 0;

  for (int ix = 0; ix < 8; ix++)
  {
    address = address | (digitalRead(addr_bus[ix]) << ix);
  }

  return address;
}

byte readDataFromBus()
{
  byte data = 0;

  for (int ix = 0; ix < 8; ix++)
  {
    data = data | (digitalRead(data_bus[ix]) << ix);
  }

  return data;
}

/*
 **********************************************************************/

/**********************************************************************
 *  Release the PLC14500 data and address buses by setting the 
 *  program counter and RAM to active outputs (WEN and PRG pin),
 *  after setting our lines to input (avoid bus contention).
 */

void releaseBus()
{
  for (int ix = 0; ix < 8; ix++)
  {
    pinMode(addr_bus[ix], INPUT);
    pinMode(data_bus[ix], INPUT);
  }

  digitalWrite(WEN_PIN, HIGH);
  digitalWrite(PRG_PIN, LOW);
}

/*
 **********************************************************************/
