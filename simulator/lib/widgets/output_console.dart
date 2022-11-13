import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulator/logic_blocks/register.dart';
import 'package:simulator/widgets/output_indicator.dart';

class OutputConsole extends StatefulWidget {
  OutputConsole({super.key, required this.outputRegister});

  Register outputRegister;

  @override
  State<StatefulWidget> createState() => _OutputConsoleState();
}

class _OutputConsoleState extends State<OutputConsole> {
  @override
  Widget build(BuildContext context) {
    return Row(children: _getInputControls());
  }

  List<Widget> _getInputControls() {
    return List<Widget>.generate(
        widget.outputRegister.getSize(), (index) => OutputIndicator());
  }
}
