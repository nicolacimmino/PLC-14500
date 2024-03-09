import 'dart:io' as io;

class Dump {
  List<String> content = [];

  save(String filename) {
    io.File(filename).writeAsString(content.join("\r\n"));
  }
}
