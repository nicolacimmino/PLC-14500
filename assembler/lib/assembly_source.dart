import 'dart:io' as io;

class AssemblySource {
  List<String> content = [];

  load(String filename) {
    if (!io.File(filename).existsSync()) {
      throw Exception("$filename not found");
    }

    content = io.File(filename).readAsLinesSync();

    _clean();
  }

  void _clean() {
    // Remove comment lines
    content.retainWhere((line) => !line.trim().startsWith(";"));

    // Remove empty lines
    content.retainWhere((line) => line.trim().isNotEmpty);

    // Remove comments from lines
    content = content
        .map((line) =>
            line.indexOf(";") > 0 ? line.substring(0, line.indexOf(";")) : line)
        .toList();

    // Trim
    content = content.map((line) => line.trim()).toList();

    // All uppercase
    content = content.map((line) => line.toUpperCase()).toList();
  }
}
