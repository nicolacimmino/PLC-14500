import 'package:assembler/assembly_source_processor.dart';

class AssemblySourceCleaner extends AssemblySourceProcessor {
  AssemblySourceCleaner(super.source);

  @override
  void process() {
    // Remove comment lines
    source.content.retainWhere((line) => !line.trim().startsWith(";"));

    // Remove comments from lines
    source.content = source.content
        .map((line) =>
            line.indexOf(";") > 0 ? line.substring(0, line.indexOf(";")) : line)
        .toList();

    // All uppercase
    source.content = source.content.map((line) => line.toUpperCase()).toList();
  }
}
