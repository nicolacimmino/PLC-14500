import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulator/widgets/output_indicator.dart';

class OutputConsole extends StatefulWidget {
  final List<bool> outputRegisterStatus;

  const OutputConsole({super.key, required this.outputRegisterStatus});

  @override
  State<StatefulWidget> createState() => _OutputConsoleState();
}

class _OutputConsoleState extends State<OutputConsole> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (var ix = 0; ix < widget.outputRegisterStatus.length; ix++)
        OutputIndicator(status: widget.outputRegisterStatus[ix])
    ]);
  }
}
