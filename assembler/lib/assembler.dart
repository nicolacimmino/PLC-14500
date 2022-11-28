import 'package:assembler/assembly_source.dart';
import 'package:assembler/byte_code.dart';

class Assembler {
  AssemblySource source;
  ByteCode byteCode = ByteCode();
  final Map<String, int> _opcodes = {
    "NOPO": 0x0,
    "LD": 0x1,
    "LDC": 0x2,
    "AND": 0x3,
    "ANDC": 0x4,
    "OR": 0x5,
    "ORC": 0x6,
    "XNOR": 0x7,
    "STO": 0x8,
    "STOC": 0x9,
    "IEN": 0xA,
    "OEN": 0xB,
    "JMP": 0xC,
    "RTN": 0xD,
    "SKZ": 0xE,
    "NOPF": 0xF,
  };

  Assembler(this.source);

  void assemble() {
    var board = source.metaData["BOARD"] ?? "";

    // For now we just mandate PLC14500-NANO but it's the only one we support,
    //  helps the ASM files in the wild be ready for multiple boards.

    if (board != "PLC14500-NANO") {
      throw Exception(
          "Invalid .board $board\nPlease add a valid .board directive.");
    }

    for (var line in source.source) {
      var tokens = line.split(' ');
      int result = _getOpCode(tokens[0]);

      if (tokens.length == 2) {
        // Avoid confusion. This is to be refactored into board
        //  specific code when the time comes.
        if (result == 0xC && _argToIOAddress(tokens[1]) != 0) {
          throw Exception("PLC14500-Nano can only JMP 0");
        }

        result = result | _argToIOAddress(tokens[1]) << 4;
      }

      byteCode.content.add(result);
    }

    while (byteCode.content.length < 256) {
      byteCode.content.add(255);
    }
  }

  int _argToIOAddress(String arg) {
    // Allow IO friendly names such as:
    //  .io_door_switch=in6
    //  .io_door_light=out3
    //
    //  ld door_switch
    //  sto door_light

    if (source.metaData["IO_$arg"] != null) {
      arg = source.metaData["IO_$arg"] ?? "";
    }

    var argValue = int.tryParse(arg);

    if (argValue != null) {
      return argValue;
    }

    if (arg.startsWith("IN")) {
      return 8 + int.parse(arg.substring(2));
    }

    if (arg.startsWith("OUT")) {
      return 8 + int.parse(arg.substring(3));
    }

    if (arg.startsWith("SPR")) {
      return int.parse(arg.substring(3));
    }

    throw Exception("Invalid label $arg");
  }

  int _getOpCode(String mnemonic) {
    if (!_opcodes.keys.contains(mnemonic)) {
      throw Exception("Invalid mnemonic: $mnemonic");
    }

    return _opcodes[mnemonic] ?? 0;
  }
}
