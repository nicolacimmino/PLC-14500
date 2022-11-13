import 'package:flutter/material.dart';

class InputControl extends StatefulWidget {
  final Function(int inputNumber, bool status) onToggle;
  late int _inputNumber;

  InputControl({super.key, required this.onToggle, required int inputNumber}) {
    _inputNumber = inputNumber;
  }

  @override
  State<StatefulWidget> createState() => _InputControlState();
}

class _InputControlState extends State<InputControl> {
  bool _status = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _status = !_status;
        });
        widget.onToggle(widget._inputNumber, _status);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: _status ? Colors.red : Colors.blue),
      child: Text('IN'),
    );
  }
}
