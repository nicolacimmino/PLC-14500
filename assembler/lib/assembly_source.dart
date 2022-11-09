import 'dart:io' as io;

import 'package:assembler/assembly_source_cleaner.dart';

class AssemblySource {
  List<String> content = [];

  load(String filename) {
    if (!io.File(filename).existsSync()) {
      throw Exception("$filename not found");
    }

    content = io.File(filename).readAsLinesSync();

    AssemblySourceCleaner(this).process();
  }
}
