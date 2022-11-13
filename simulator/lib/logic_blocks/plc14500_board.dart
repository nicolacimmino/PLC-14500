import 'package:simulator/logic_blocks/register.dart';

class PLC14500Board {
  Register inputRegister = Register(size: 8);
  Register outputRegister = Register(size: 8);

  PLC14500Board() {
    inputRegister.onChange =
        (index, status) => {outputRegister.setStatus(index, status)};
  }
}
