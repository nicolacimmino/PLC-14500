import 'package:flutter/material.dart';

class OutputIndicator extends StatefulWidget {
  final bool status;

  const OutputIndicator({super.key, required this.status});

  @override
  State<StatefulWidget> createState() => _OutputIndicatorState();
}

class _OutputIndicatorState extends State<OutputIndicator> {
  @override
  Widget build(BuildContext context) {
    return Image(
        image: widget.status
            ? const AssetImage('assets/ledon.png')
            : const AssetImage('assets/ledoff.png'));
  }
}
