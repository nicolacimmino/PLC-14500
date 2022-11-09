import 'assembly_source.dart';

abstract class AssemblySourceProcessor {
  AssemblySource source;

  AssemblySourceProcessor(this.source);

  void process();
}
