import 'package:flutter/material.dart';

class InputControl extends StatefulWidget {
  final Function(int inputNumber, bool status) onToggle;
  late final int _inputNumber;

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
    return Column(children: [
      Container(
          height: 50,
          width: 50,
          color: Colors.black,
          child: GestureDetector(
            onTapDown: (details) {
              setState(() {
                _status = true;
                widget.onToggle(widget._inputNumber, _status);
              });
            },
            onTapUp: (details) {
              setState(() {
                _status = false;
                widget.onToggle(widget._inputNumber, _status);
              });
            },
          )),
      ElevatedButton(
        onPressed: () {
          setState(() {
            _status = !_status;
          });
          widget.onToggle(widget._inputNumber, _status);
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: _status ? Colors.red : Colors.blue),
        child: const Text('IN'),
      )
    ]);
  }
}
