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

#include <EEPROM.h>

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

void setup()
{

  Serial.begin(9600);
}

void loop()
{
  for (uint8_t ix = 0; ix < 255; ix++)
  {
    Serial.print(EEPROM.read(ix), 16);
    Serial.print(",");
  }

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

  pinMode(WEN_PIN, OUTPUT);
  digitalWrite(WEN_PIN, HIGH);

  // Enter programming mode.
  // The board will release the buses.
  pinMode(PRG_PIN, OUTPUT);
  digitalWrite(PRG_PIN, HIGH);

  // Take ownership of the buses setting all
  // data and address pins as outputs.
  for (int ix = 0; ix < 8; ix++)
  {
    pinMode(addr_bus[ix], OUTPUT);
    pinMode(data_bus[ix], OUTPUT);
  }

  for (int address = 0; address < 256; address++)
  {
    writeProgramByte(address, rxBuffer[address]);
  }

  // Release the buses settings pins as inputs.
  for (int ix = 0; ix < 8; ix++)
  {
    pinMode(addr_bus[ix], INPUT);
    pinMode(data_bus[ix], INPUT);
  }

  // Exit progriamming mode the board will
  // take back control of the buses.
  digitalWrite(PRG_PIN, LOW);

  pinMode(WEN_PIN, INPUT);
  pinMode(PRG_PIN, INPUT);
}

void writeProgramByte(byte address, byte data)
{
  pinMode(WEN_PIN, OUTPUT);
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
  delay(15);
  digitalWrite(WEN_PIN, HIGH);

  EEPROM.write(address, data);
}
