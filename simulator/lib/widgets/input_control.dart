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
    precacheImage(const AssetImage('assets/switchon.png'), context);
    return Column(children: [
      GestureDetector(
        child: const Image(image: AssetImage('assets/button.png')),
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
      ),
      GestureDetector(
        child: Image(
            image: _status
                ? const AssetImage('assets/switchon.png')
                : const AssetImage('assets/switchoff.png')),
        onTapDown: (details) {
          setState(() {
            _status = !_status;
            widget.onToggle(widget._inputNumber, _status);
          });
        },
      ),
      // ElevatedButton(
      //   onPressed: () {
      //     setState(() {
      //       _status = !_status;
      //     });
      //     widget.onToggle(widget._inputNumber, _status);
      //   },
      //   child: Image(
      //       image: _status
      //           ? const AssetImage('assets/switchon.png')
      //           : const AssetImage('assets/switchoff.png')),
      // )
    ]);
  }
}
