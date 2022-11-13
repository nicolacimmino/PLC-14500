import 'package:flutter/material.dart';

class OutputIndicator extends StatefulWidget {
  OutputIndicator({super.key});

  @override
  State<StatefulWidget> createState() => _OutputIndicatorState();
}

class _OutputIndicatorState extends State<OutputIndicator> {
  bool _status = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text("X",
        style: TextStyle(backgroundColor: _status ? Colors.red : Colors.blue));
  }

  void setStatus(bool status) {
    setState(() {
      _status = status;
    });
  }
}
