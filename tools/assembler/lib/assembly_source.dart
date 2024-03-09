import 'dart:io' as io;

import 'package:path/path.dart';

class AssemblySource {
  List<String> content = [];
  List<String> source = [];
  Map<String, String> metaData = {};
  String filename = "";

  load(String filePath) {
    if (!io.File(filePath).existsSync()) {
      throw Exception("$filePath not found");
    }

    filename = basename(filePath);

    content = io.File(filePath).readAsLinesSync();

    _extractSource();
    _extractMetadata();
  }

  void _extractMetadata() {
    var metaDataLines = content.map((item) => item.toString()).toList();

    // Keep only .xxxx
    metaDataLines.retainWhere((line) => line.trim().startsWith("."));

    // Remove comments from lines
    metaDataLines = metaDataLines
        .map((line) =>
            line.indexOf(";") > 0 ? line.substring(0, line.indexOf(";")) : line)
        .toList();

    // Trim
    metaDataLines = metaDataLines.map((line) => line.trim()).toList();

    for (var metadataLine in metaDataLines) {
      var tokens = metadataLine.split("=");

      if (tokens.length != 2) {
        throw Exception("invalid meta content: $metadataLine");
      }

      metaData[tokens[0].replaceFirst(".", "").trim().toUpperCase()] =
          tokens[1].trim().toUpperCase();
    }
  }

  void _extractSource() {
    source = content.map((item) => item.toString()).toList();

    // Remove lines not starting with A-z
    source.retainWhere((line) => line.trim().startsWith(RegExp("[a-zA-Z]")));

    // Remove comments from lines
    source = source
        .map((line) =>
            line.indexOf(";") > 0 ? line.substring(0, line.indexOf(";")) : line)
        .toList();

    // Trim
    source = source.map((line) => line.trim()).toList();

    // Get rid of multiple spaces
    source =
        source.map((line) => line.replaceAll(RegExp(r"\s+"), " ")).toList();

    // All uppercase
    source = source.map((line) => line.toUpperCase()).toList();
  }
}
