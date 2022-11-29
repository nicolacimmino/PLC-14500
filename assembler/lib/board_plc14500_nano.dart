import 'package:assembler/board.dart';

class BoardPlc14500Nano extends Board {
  @override
  validateBytecode(int bytecode) {
    if ((bytecode & 0xF) == 0xC && (bytecode & 0xF0) != 0) {
      throw Exception("PLC14500-Nano can only JMP 0");
    }
  }

  @override
  int getPaddedProgramSize() {
    return 256;
  }

  @override
  int getIOAddress(String label) {
    if (label.startsWith("IN")) {
      return 8 + int.parse(label.substring(2));
    }

    if (label.startsWith("OUT")) {
      return 8 + int.parse(label.substring(3));
    }

    if (label.startsWith("SPR")) {
      return int.parse(label.substring(3));
    }

    throw Exception("Invalid label $label");
  }
}
