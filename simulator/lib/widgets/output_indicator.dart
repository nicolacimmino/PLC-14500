import 'package:flutter/material.dart';

class OutputIndicator extends StatefulWidget {
  final bool status;
  final double? ledRadius;

  const OutputIndicator({super.key, required this.status, this.ledRadius = 20});

  @override
  State<StatefulWidget> createState() => _OutputIndicatorState();
}

class _OutputIndicatorState extends State<OutputIndicator> {
  @override
  Widget build(BuildContext context) {
    return Image(
        width: widget.ledRadius,
        image: widget.status
            ? const AssetImage('assets/led_on.png')
            : const AssetImage('assets/led_off.png'));
  }
}
