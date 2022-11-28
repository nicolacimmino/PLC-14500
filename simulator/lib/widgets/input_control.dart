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
  bool _toggleStatus = false;
  bool _buttonStatus = false;

  @override
  void initState() {
    super.initState();
  }

  _reportChange() {
    widget.onToggle(widget._inputNumber, _buttonStatus ? !_toggleStatus : _toggleStatus);
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage('assets/switch_on.png'), context);
    return Column(children: [
      GestureDetector(
        child: const Image(image: AssetImage('assets/button.png')),
        onTapDown: (details) {
          setState(() {
            _buttonStatus = true;
            _reportChange();
          });
        },
        onTapUp: (details) {
          setState(() {
            _buttonStatus = false;
            _reportChange();
          });
        },
      ),
      GestureDetector(
        child: Image(
            image: _toggleStatus
                ? const AssetImage('assets/switch_on.png')
                : const AssetImage('assets/switch_off.png')),
        onTapDown: (details) {
          setState(() {
            _toggleStatus = !_toggleStatus;
            _reportChange();
          });
        },
      ),
    ]);
  }
}
