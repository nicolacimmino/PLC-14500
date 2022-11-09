import 'package:assembler/assembly_source.dart';
import 'package:assembler/byte_code.dart';

class Assembler {
  AssemblySource source;
  ByteCode byteCode = ByteCode();

  Assembler(this.source);
}
