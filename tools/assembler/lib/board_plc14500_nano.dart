import 'package:assembler/board.dart';

class BoardPlc14500Nano extends Board {
  final Map<String, String> _ioAliases = {
    "TMR0-TRIG": "OUT7",
    "TMR0-OUT": "IN7",
    "RR": "SPR7" // Starting from REV.C RR is wired to SPR7
  };

  @override
  validateBytecode(int bytecode) {
    if ((bytecode & 0xF) == 0xC && (bytecode & 0xF0) != 0) {
      print("Warning: PLC14500-Nano can only JMP 0, operand value has no effect.");
    }
  }

  @override
  int getPaddedProgramSize() {
    return 256;
  }

  @override
  int getIOAddress(String label) {
    if (_ioAliases.containsKey(label)) {
      label = _ioAliases[label]!;
    }

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
