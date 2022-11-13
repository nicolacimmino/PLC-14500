import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulator/logic_blocks/register.dart';
import 'package:simulator/widgets/input_control.dart';

class InputConsole extends StatefulWidget {
  InputConsole({super.key, required this.inputRegister});

  Register inputRegister;

  @override
  State<StatefulWidget> createState() => _InputConsoleState();
}

class _InputConsoleState extends State<InputConsole> {
  @override
  Widget build(BuildContext context) {
    return Row(children: _getInputControls());
  }

  List<Widget> _getInputControls() {
    return List<Widget>.generate(widget.inputRegister.getSize(),
        (index) => InputControl(inputNumber: index, onToggle: onToggle));
  }

  void onToggle(int input_number, bool status) {
    print('$input_number $status');
    widget.inputRegister.setStatus(input_number, status);
  }
}
