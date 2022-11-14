import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simulator/logic_blocks/plc14500_board.dart';
import 'package:simulator/widgets/input_console.dart';
import 'package:simulator/widgets/output_console.dart';

class PLC14500Simulator extends StatefulWidget {
  final board = PLC14500Board();

  PLC14500Simulator({super.key});

  @override
  State<StatefulWidget> createState() => _PLC14500SimulatorState();
}

class _PLC14500SimulatorState extends State<PLC14500Simulator> {
  late final Timer clockTimer;

  _PLC14500SimulatorState() {
    clockTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      _onClock();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PLC-14500 Simulator',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('PLC14500 Simulator'),
          ),
          body: Row(
            children: [
              InputConsole(inputRegister: widget.board.inputRegister),
              OutputConsole(outputRegister: widget.board.outputRegister),
              FloatingActionButton(onPressed: _onClock, child: const Text('CLK')),
            ],
          ),
        ));
  }

  _onClock() {
    widget.board.clock();
    setState(() {
      widget.board.outputRegister = widget.board.outputRegister;
    });
  }
}
