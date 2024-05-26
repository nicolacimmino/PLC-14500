
#ifndef __CONFIG_H__
#define __CONFIG_H__

#define STR_HELPER(x) #x
#define STR(x) STR_HELPER(x)

#define __MONITOR_VERSION_MAJOR__ 1
#define __MONITOR_VERSION_MINOR__ 0

#define __BOOTLOADER_VERSION_MAJOR__ 1
#define __BOOTLOADER_VERSION_MINOR__ 2

#define PROGRAM_MEMOMORY_SIZE 256
#define RX_BUFFER_SIZE 256

#define MAX_PROGRAM_BLOCK 3

#endif
