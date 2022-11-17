import 'package:flutter/services.dart';
import 'package:simulator/logic_blocks/counter.dart';
import 'package:simulator/logic_blocks/mc14500.dart';
import 'package:simulator/logic_blocks/ram.dart';
import 'package:simulator/logic_blocks/register.dart';

class PLC14500Board {
  Register inputRegister = Register(size: 8);
  Register outputRegister = Register(size: 8);
  Register scratchpadRAM = Register(size: 8);
  Counter programCounter = Counter(size: 8);

  Ram ram = Ram(size: 256);
  MC14500 mc14500 = MC14500();
  bool _clockPhase = false;

  load(Uint8List data) {
    for (int ix = 0; ix < data.length; ix++) {
      ram.address = ix;
      ram.write(data[ix]);
    }
  }

  void clock() {
    ram.address = programCounter.getValue();

    if (!mc14500.w) {
      mc14500.d = inputRegister.getBit((ram.read() & 0xF0) >> 4);
    }

    mc14500.i.setValue(ram.read() & 0xF);
    mc14500.clock(_clockPhase);

    if (mc14500.w) {
      outputRegister.setBit((ram.read() & 0xF0) >> 4, mc14500.d);
    }

    if (_clockPhase == true) {
      programCounter.increment();

      if (mc14500.jmp) {
        programCounter.reset();
      }
    }

    _clockPhase = !_clockPhase;
  }
}
