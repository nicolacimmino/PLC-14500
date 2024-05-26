import 'package:assembler/assembly_source.dart';
import 'package:assembler/board.dart';
import 'package:assembler/byte_code.dart';

class Assembler {
  AssemblySource source;
  ByteCode byteCode = ByteCode();
  late Board _board;

  final Map<String, int> _opcodes = {
    'NOPO': 0x0,
    'LD': 0x1,
    'LDC': 0x2,
    'AND': 0x3,
    'ANDC': 0x4,
    'OR': 0x5,
    'ORC': 0x6,
    'XNOR': 0x7,
    'STO': 0x8,
    'STOC': 0x9,
    'IEN': 0xA,
    'OEN': 0xB,
    'JMP': 0xC,
    'RTN': 0xD,
    'SKZ': 0xE,
    'NOPF': 0xF,
  };

  Assembler(this.source);

  void assemble() {
    _board = Board.fromName(source.metaData['BOARD'] ?? '');

    for (var line in source.source) {
      var tokens = line.split(' ');
      int result = _getOpCode(tokens[0]);

      if (tokens.length == 2) {
        result = result | _argToIOAddress(tokens[1]) << 4;
      }

      _board.validateBytecode(result);

      byteCode.content.add(result);

      if (byteCode.content.length > _board.getPaddedProgramSize()) {
        throw Exception(
            "Program too long, max ${_board.getPaddedProgramSize()} bytes");
      }
    }

    if (byteCode.content.length < _board.getPaddedProgramSize()) {
      byteCode.content.addAll(List.generate(
          _board.getPaddedProgramSize() - byteCode.content.length,
          (index) => _opcodes['NOPF']!));
    }
  }

  int _argToIOAddress(String label) {
    // Allow IO friendly names such as:
    //  .io_door_switch=in6
    //  .io_door_light=out3
    //
    //  ld door_switch
    //  sto door_light

    if (source.metaData["IO_$label"] != null) {
      label = source.metaData["IO_$label"] ?? "";
    }

    var argValue = int.tryParse(label);

    if (argValue != null) {
      return argValue;
    }

    return _board.getIOAddress(label);
  }

  int _getOpCode(String mnemonic) {
    if (!_opcodes.keys.contains(mnemonic)) {
      throw Exception("Invalid mnemonic: $mnemonic");
    }

    return _opcodes[mnemonic] ?? 0;
  }
}
