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
    for (var line in source.content) {
      var tokens = line.split(' ');
      int result = _getOpCode(tokens[0]);

      if (tokens.length == 2) {
        result = result | int.parse(tokens[1]) << 4;
      }

      byteCode.content.add(result);
    }

    while (byteCode.content.length < 256) {
      byteCode.content.add(255);
    }
  }

  int _getOpCode(String mnemonic) {
    if (!_opcodes.keys.contains(mnemonic)) {
      throw Exception("invalid mnemonic: $mnemonic");
    }

    return _opcodes[mnemonic] ?? 0;
  }
}
