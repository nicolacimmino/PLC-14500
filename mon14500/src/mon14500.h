
#ifndef __MON14500_H__
#define __MON14500_H__

#include "config.h"

#define PRINT_BUFFER_SIZE 256

/**********************************************************************
 * Common print buffer for all sprintf needs, avoids allocating and 
 * de-allocating memory which could cause fragmentation.
 */

extern char printBuffer[PRINT_BUFFER_SIZE];

/*
 *********************************************************************/

/**********************************************************************
 * This is a shadow of the contents of the PLC14500 onboard program 
 * RAM. This is needed to write/dump consistently the contents of the 
 * PLC14500 memory. Due to a limitation in the hardware (a single PRG
 * line both acquires the bus AND disables the RAM outputs) we are not
 * able to read back the onboard RAM. We use programMemoryShadow to 
 * keep an always up to date local copy in sync with any changes we 
 * write.
 */

extern char programMemoryShadow[PROGRAM_MEMOMORY_SIZE];

/*
 *********************************************************************/

int getFreeRamBytes();

#endif