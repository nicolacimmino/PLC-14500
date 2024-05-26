import 'dart:io' as io;

class ByteCode {
  List<int> content = [];

  save(String filename) {
    io.File(filename).writeAsBytes(content);
  }
}
