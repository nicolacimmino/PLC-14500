import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simulator/logic_blocks/counter.dart';
import 'package:simulator/logic_blocks/ram.dart';

void main() {
  group("Ram", () {
    test('get size', () {
      var ram = Ram(size: 16);

      expect(ram.getSize(), 16);
    });

    test('writes', () {
      var ram = Ram(size: 16);

      ram.address = 1;
      ram.write(12);

      ram.address = 0;
      expect(ram.read(), 0);

      ram.address = 1;
      expect(ram.read(), 12);
    });


  });
}
