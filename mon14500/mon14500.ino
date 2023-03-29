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

#include <EEPROM.h>

#include "src/config.h"
#include "src/hardware.h"
#include "src/monitor.h"
#include "src/bootloader.h"
#include "src/messages.h"

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

byte rxBuffer[RX_BUFFER_SIZE];

void setup()
{
  pinMode(WEN_PIN, OUTPUT);
  pinMode(PRG_PIN, OUTPUT);

  bootstrapPLC14500Board();

  Serial.begin(9600);
}

void loop()
{
  byte result = enterBootloader();

  if (result == BOOT_ENTER_MONITOR)
  {
    enterMonitor();
  }

  if (result == BOOT_OK)
  {
    // Persist the program to the arduino EEPROM so we can bootstrap the board on powerup.
    for (int address = 0; address < PROGRAM_MEMOMORY_SIZE; address++)
    {
      EEPROM.write(address, rxBuffer[address]);
    }

    bootstrapPLC14500Board();
  }
}
