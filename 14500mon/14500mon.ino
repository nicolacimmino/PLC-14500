/**********************************************************************
 * Assembler Monitor for PLC14500-Nano board.
 *  Copyright (C) 2023 Nicola Cimmino
 * 
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see http://www.gnu.org/licenses/.
 *
 */

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

uint8_t bootConfig = 0;

void bootloaderSetup()
{
  unsigned long lastResetPress = millis();

  acquireBusForWrite();
  while (true)
  {
    if (analogRead(RST_PIN) < RST_BUTTON_LOW_THRESHOLD)
    {
      bootConfig = (bootConfig + 1) % 8;
      Serial.print("BOOT CONFIG ");
      Serial.println(bootConfig);
      lastResetPress = millis();

      for (int ix = 0; ix < 8; ix++)
      {
        digitalWrite(addr_bus[ix], (bootConfig >> ix) & 1);
      }
    }

    digitalWrite(data_bus[0], (millis() % 600) < 200);

    while (analogRead(RST_PIN) < RST_BUTTON_LOW_THRESHOLD)
    {
      digitalWrite(data_bus[0], (millis() % 600) < 200);
      if (millis() - lastResetPress > BOOT_CONFIG_TIMEOUT_MS)
      {
        releaseBus();
        return;
      }
    }
  }
}

void setup()
{
  pinMode(WEN_PIN, OUTPUT);
  pinMode(PRG_PIN, OUTPUT);

  Serial.begin(9600);

  pinMode(RST_PIN, INPUT);
  if (analogRead(RST_PIN) > RST_BUTTON_LOW_THRESHOLD)
  {
    bootloaderSetup();
  }

  loadBlockIntoProgramMemory(bootConfig & 0b00000011);
}

void loop()
{
  // Demo mode if anything is set in BIT2
  if (bootConfig & 0b00000100)
  {
    static unsigned long lastProgramChange = 0;
    static uint8_t demoIndex = 0;
    if (millis() - lastProgramChange > 3000)
    {
      // BIT0 and BIT1 are the amount of programs in demo mode.
      demoIndex = (demoIndex + 1) % (bootConfig & 0b00000011);
      loadBlockIntoProgramMemory(demoIndex);
      lastProgramChange = millis();
    }

    return;
  }

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

    // Here we always enter program 0 because we just came out of a successful upload.
    loadBlockIntoProgramMemory(0);
  }
}
