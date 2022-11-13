import 'package:flutter/material.dart';

class OutputIndicator extends StatefulWidget {
  final bool status;

  const OutputIndicator({super.key, required this.status});

  @override
  State<StatefulWidget> createState() => _OutputIndicatorState();
}

class _OutputIndicatorState extends State<OutputIndicator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("X",
        style: TextStyle(
            backgroundColor: widget.status ? Colors.red : Colors.blue));
  }
}
