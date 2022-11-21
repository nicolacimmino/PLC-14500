import 'package:assembler/assembler.dart';
import 'package:assembler/assembly_source.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    _printUsage();

    return;
  }

  var sourceFile = arguments[0];

  if (!sourceFile.contains(".asm")) {
    _printUsage();

    return;
  }

  var outFile = sourceFile.replaceAll(".asm", ".bin");
  var source = AssemblySource();
  var assembler = Assembler(source);

  source.load(sourceFile);
  assembler.assemble();
  assembler.byteCode.save(outFile);
}

void _printUsage() {
  print("Usage: assembler <file.asm>");
}
