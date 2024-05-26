#include <Arduino.h>

#ifndef __HARDWARE_H__
#define __HARDWARE_H__

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
#define RST_PIN A6

extern byte data_bus[];
extern byte addr_bus[];
extern byte rxBuffer[];

void acquireBusForWrite();
void acquireBusForRead();
void releaseBus();
byte readAddressFromBus();
byte readDataFromBus();

#endif