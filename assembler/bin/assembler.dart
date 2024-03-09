import 'package:assembler/assembler.dart';
import 'package:assembler/assembly_source.dart';

void main(List<String> arguments) {
  if (arguments.length != 1) {
    _printUsage("");

    return;
  }

  var sourceFile = arguments[0];

  if (!sourceFile.endsWith(".asm")) {
    _printUsage("Invalid input file");

    return;
  }

  var outFile = sourceFile.replaceAll(".asm", ".bin");
  var dumpFile = sourceFile.replaceAll(".asm", ".dump.txt");
  var source = AssemblySource();
  var assembler = Assembler(source);

  try {
    source.load(sourceFile);
    assembler.assemble();
    assembler.byteCode.save(outFile);
    assembler.dump.save(dumpFile);
    print("Done. Output in: $outFile");
  } catch (e) {
    print(e.toString().replaceFirst("Exception: ", ""));
  }
}

void _printUsage(String issue) {
  if (issue.isNotEmpty) {
    print(issue);
  }

  print("Usage: assembler <file.asm>");
}
