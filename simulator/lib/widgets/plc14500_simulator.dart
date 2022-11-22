import 'dart:async';

import 'package:file_picker/file_picker.dart';
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
              actions: <Widget>[
                IconButton(
                    icon: const Icon(Icons.file_open),
                    tooltip: 'Load',
                    onPressed: _load)
              ]),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              InputConsole(inputRegister: widget.board.inputRegister),
              OutputConsole(
                  label: "IN", outputRegister: widget.board.inputRegister),
              OutputConsole(
                  label: "SPR", outputRegister: widget.board.scratchpadRAM),
              OutputConsole(
                  label: "OUT", outputRegister: widget.board.outputRegister),
            ],
          ),
        ));
  }

  _load() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['bin']);

    if (result != null && result.files.single.bytes != null) {
      widget.board.load(result.files.single.bytes!);
    }
  }

  _onClock() {
    widget.board.clock();
    setState(() {
      widget.board.outputRegister = widget.board.outputRegister;
      widget.board.scratchpadRAM = widget.board.scratchpadRAM;
    });
  }
}
