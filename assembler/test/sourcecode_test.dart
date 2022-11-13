import 'package:assembler/assembly_source.dart';
import 'package:test/test.dart';

void main() {
  group("Source Code", () {
    test('load cleans out comments', () {
      var sourceCode = AssemblySource();

      sourceCode.load("test/data/test1.asm");

      expect(sourceCode.content.length, 15);
    });
  });
}
