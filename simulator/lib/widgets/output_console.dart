import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simulator/logic_blocks/register.dart';
import 'package:simulator/widgets/output_indicator.dart';

class OutputConsole extends StatefulWidget {
  final Register outputRegister;
  final String label;
  final double? ledRadius;

  const OutputConsole(
      {super.key,
      required this.outputRegister,
      required this.label,
      this.ledRadius = 20});

  @override
  State<StatefulWidget> createState() => _OutputConsoleState();
}

class _OutputConsoleState extends State<OutputConsole> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      for (var ix = 0; ix < widget.outputRegister.getSize(); ix++)
        OutputIndicator(
          status: widget.outputRegister.getBit(ix),
          ledRadius: widget.ledRadius,
        ),
      for (var ix = widget.outputRegister.getSize(); ix < 8; ix++)
        Image(
            width: widget.ledRadius,
            image: const AssetImage('assets/led_placeholder.png')),
      Text(widget.label)
    ]);
  }
}
