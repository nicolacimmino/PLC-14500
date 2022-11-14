import 'package:simulator/logic_blocks/register.dart';

class PLC14500Board {
  Register inputRegister = Register(size: 8);
  Register outputRegister = Register(size: 8);
  Register scratchpadRAM = Register(size: 8);

  void clock() {
    for (int ix = 0; ix < inputRegister.getSize(); ix++) {
      outputRegister.setBit(ix, inputRegister.getBit(ix));
    }
  }
}
