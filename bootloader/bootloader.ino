// Bootloader for PLC14500-Nano board.
//  Copyright (C) 2022 Nicola Cimmino
//
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//   This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see http://www.gnu.org/licenses/.
//
//

#define D0_PIN 2
#define D1_PIN 3
#define D2_PIN 4
#define D3_PIN 5
#define D4_PIN 6
#define D5_PIN 7
#define D6_PIN 8
#define D7_PIN 9

#define A0_PIN 10
#define A1_PIN 11
#define A2_PIN 12
#define A3_PIN 13
#define A4_PIN A0
#define A5_PIN A1
#define A6_PIN A2
#define A7_PIN A3

#define PRG_PIN A4
#define WEN_PIN A5

#define PROGRAM_MEMOMORY_SIZE 256

#define RX_TIMEOUT_MS 1000

#include "EEPROM.h"

byte data_bus[] = {
    D0_PIN,
    D1_PIN,
    D2_PIN,
    D3_PIN,
    D4_PIN,
    D5_PIN,
    D6_PIN,
    D7_PIN};

byte addr_bus[] = {
    A0_PIN,
    A1_PIN,
    A2_PIN,
    A3_PIN,
    A4_PIN,
    A5_PIN,
    A6_PIN,
    A7_PIN};

byte rxBuffer[PROGRAM_MEMOMORY_SIZE];

/**********************************************************************
 *  Acquire the PLC14500 data and address buses by setting the 
 *  program counter and RAM to High-Z outputs (WEN and PRG pin),
 *  and then setting our lines to output (avoid bus contention).
 */

void acquireBus()
{
  digitalWrite(WEN_PIN, HIGH);
  digitalWrite(PRG_PIN, HIGH);

  for (int ix = 0; ix < 8; ix++)
  {
    pinMode(addr_bus[ix], OUTPUT);
    pinMode(data_bus[ix], OUTPUT);
  }
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

/**********************************************************************
 * Bootstrap the PLC14500 program memory writing the last received
 * program stored in EEPROM.
 */

void bootstrapPLC14500Board()
{
  acquireBus();

  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE; address++)
  {
    writeProgramByte(address, EEPROM.read(address));
  }

  releaseBus();
}

/*
 **********************************************************************/

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

void setup()
{
  pinMode(WEN_PIN, OUTPUT);
  pinMode(PRG_PIN, OUTPUT);

  bootstrapPLC14500Board();

  Serial.begin(9600);
}

void loop()
{
  while (!Serial.available())
  {
  }

  // Wait for PROGRAM_MEMOMORY_SIZE (or timeout). We need to
  //  store the program in RAM first as writing it to the board
  //  and local EEPROM would cause the Arduino serial RX buffer
  //  to overflow.

  unsigned long rxStartTime = millis();
  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE;)
  {
    if (millis() - rxStartTime > RX_TIMEOUT_MS)
    {      
      return;
    }

    if (Serial.available())
    {
      rxBuffer[address] = Serial.read();
      address++;
    }
  }

  // Persist the program to the arduino EEPROM so we can bootstrap the board on powerup.
  for (int address = 0; address < PROGRAM_MEMOMORY_SIZE; address++)
  {
    EEPROM.write(address, rxBuffer[address]);
  }

  bootstrapPLC14500Board();
}

