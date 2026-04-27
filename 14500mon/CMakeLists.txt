cmake_minimum_required(VERSION 4.1)
project(14500mon)

set(CMAKE_CXX_STANDARD 14)

include_directories(.)
include_directories(src)

add_executable(14500mon
        src/bootloader.cpp
        src/bootloader.h
        src/config.h
        src/hardware.cpp
        src/hardware.h
        src/messages.cpp
        src/messages.h
        src/mon14500.cpp
        src/mon14500.h
        src/monitor.cpp
        src/monitor.h
        14500mon.ino)
