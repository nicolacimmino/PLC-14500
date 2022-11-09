import 'dart:io' as io;

class AssemblySource {
  List<String> content = [];

  load(String filename) {
    if (!io.File(filename).existsSync()) {
      throw Exception("$filename not found");
    }

    content = io.File(filename).readAsLinesSync();
  }
}
