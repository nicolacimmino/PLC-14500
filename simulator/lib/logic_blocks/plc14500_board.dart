import 'package:flutter/services.dart';
import 'package:simulator/logic_blocks/counter.dart';
import 'package:simulator/logic_blocks/mc14500.dart';
import 'package:simulator/logic_blocks/ram.dart';
import 'package:simulator/logic_blocks/register.dart';
import 'package:simulator/logic_blocks/timer.dart';

class PLC14500Board {
  Register inputRegister = Register(size: 7);
  Register outputRegister = Register(size: 8);
  Register scratchpadRAM = Register(size: 8);
  Counter programCounter = Counter(size: 8);
  Timer tmr0 = Timer();
  Ram ram = Ram(size: 256);
  MC14500 mc14500 = MC14500();
  bool _clockPhase = false;

  load(Uint8List data) {
    ram.writeBulk(data);
  }

  void clock() {
    ram.address = programCounter.getValue();

    if (!mc14500.w) {
      _doReadCycle();
    }

    mc14500.i.setValue(ram.read() & 0xF);
    mc14500.clock(_clockPhase);

    if (mc14500.w) {
      _doWriteCycle();
    }

    if (_clockPhase == true) {
      programCounter.increment();

      if (mc14500.jmp) {
        programCounter.reset();
      }
    }

    _clockPhase = !_clockPhase;
  }

  void _doReadCycle() {
    var readAddress = (ram.read() & 0xF0) >> 4;

    if (readAddress == 7) {
      mc14500.d = tmr0.read();
      return;
    }

    if (readAddress < 7) {
      mc14500.d = inputRegister.getBit(readAddress);
      return;
    }

    mc14500.d = scratchpadRAM.getBit(readAddress - 8);
  }

  void _doWriteCycle() {
    var writeAddress = (ram.read() & 0xF0) >> 4;

    if (writeAddress < 8) {
      outputRegister.setBit(writeAddress, mc14500.d);
      if (writeAddress == 7) {
        tmr0.setTrigger(mc14500.d);
      }
      return;
    }

    scratchpadRAM.setBit(writeAddress - 8, mc14500.d);
  }
}
