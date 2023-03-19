// Assembler Monitor for PLC14500-Nano board.
//  Copyright (C) 2023 Nicola Cimmino
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

#define RX_TIMEOUT_MS 1000

#include <EEPROM.h>
#include "src/messages.h"
#include "src/hardware.h"
#include "src/monitor.h"
#include "src/bootloader.h"

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

void setup()
{
  pinMode(WEN_PIN, OUTPUT);
  pinMode(PRG_PIN, OUTPUT);

  bootstrapPLC14500Board();

  Serial.begin(9600);

  printMessage(MESSAGE_BANNER_IX);
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
      if (rxBuffer[0] == '\r')
      {
        enterAssembler();
        printMessage(MESSAGE_BANNER_IX);
      }
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
