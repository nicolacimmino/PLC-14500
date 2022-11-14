import 'package:flutter/material.dart';
import 'package:simulator/logic_blocks/plc14500_board.dart';
import 'package:simulator/widgets/input_console.dart';
import 'package:simulator/widgets/output_console.dart';

class PLC14500Simulator extends StatefulWidget {
  final board = PLC14500Board();
  late List<bool> outputRegisterStatus;

  PLC14500Simulator({super.key}) {
    outputRegisterStatus = board.inputRegister.status;
  }

  @override
  State<StatefulWidget> createState() => _PLC14500SimulatorState();
}

class _PLC14500SimulatorState extends State<PLC14500Simulator> {
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
              OutputConsole(outputRegisterStatus: widget.outputRegisterStatus),
              FloatingActionButton(onPressed: _onClock)
            ],
          ),
        ));
  }

  _onClock() {
    widget.board.clock();
    setState(() {
      widget.outputRegisterStatus = widget.board.outputRegister.status;
    });
  }
}
