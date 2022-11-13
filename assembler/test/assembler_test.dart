import 'dart:io' as io;

import 'package:assembler/assembler.dart';
import 'package:assembler/assembly_source.dart';
import 'package:test/test.dart';

void main() {
  group("Assembler", () {
    test('assemble produces expected bytecode', () {
      var sourceCode = AssemblySource();
      var assembler = Assembler(sourceCode);
      var expectedByteCode = io.File("test/data/test1.bin").readAsBytesSync();

      sourceCode.load("test/data/test1.asm");
      assembler.assemble();

      expect(assembler.byteCode.content.length, expectedByteCode.length);
      for (var ix = 0; ix < expectedByteCode.length; ix++) {
        expect(assembler.byteCode.content[ix], expectedByteCode[ix],
            reason: "byte at $ix");
      }
    });
  });
}
