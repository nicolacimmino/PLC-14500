import 'package:assembler/board_plc14500_nano.dart';

abstract class Board {
  validateBytecode(int bytecode);

  int getPaddedProgramSize();

  int getIOAddress(String label);

  Board();

  factory Board.fromName(String name) {
    if (name == "PLC14500-NANO") {
      return BoardPlc14500Nano();
    }

    throw Exception("Unknown board type $name");
  }
}
