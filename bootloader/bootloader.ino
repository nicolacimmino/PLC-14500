// Bootloader PLC14500-Nano board.
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

byte rxBuffer[256];

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

void setup()
{
  pinMode(WEN_PIN, OUTPUT);
  pinMode(PRG_PIN, OUTPUT);
  
  releaseBus();

  Serial.begin(9600);
}

void loop()
{

  acquireBus();

  for (int address = 0; address < 256; address++)
  {
    writeProgramByte(address, EEPROM.read(address));
    Serial.print(EEPROM.read(address), 16);
    
    if(address % 16 == 15) {
      Serial.println("");
    } else {
      Serial.print(".");
    }
  }

  releaseBus();

  while (!Serial.available())
  {
  }

  // We need to first take the all input data in memory
  // since the writing to the target takes 10mS we would
  // overrun the buffer if we attempted to write directly.
  for (int address = 0; address < 256;)
  {
    if (Serial.available())
    {
      rxBuffer[address] = Serial.read();
      address++;
    }
  }

  acquireBus();

  for (int address = 0; address < 256; address++)
  {
    writeProgramByte(address, rxBuffer[address]);
  }

  releaseBus();
}

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
  // Note this needs to be 15mS for EEPROMs.
  // One possibility would be to have a flag over the wire to indicate RAM/EEPROM
  delay(1);
  digitalWrite(WEN_PIN, HIGH);

  EEPROM.write(address,data);
}
