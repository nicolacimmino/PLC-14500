import 'package:flutter/material.dart';
import 'package:simulator/logic_blocks/plc14500_board.dart';
import 'package:simulator/widgets/input_console.dart';
import 'package:simulator/widgets/output_console.dart';

class PLC14500Emulator extends StatefulWidget {
  var board = PLC14500Board();

  PLC14500Emulator({super.key});

  @override
  State<StatefulWidget> createState() => _PLC14500EmulatorState();
}

class _PLC14500EmulatorState extends State<PLC14500Emulator> {
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
              OutputConsole(outputRegister: widget.board.outputRegister)
            ],
          ),
        ));
  }
}
