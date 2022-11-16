import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:simulator/logic_blocks/counter.dart';

void main() {
  group("Counter", () {
    test('get size', () {
      var counter = Counter(size: 4);

      expect(counter.getSize(), 4);
    });

    test('increments', () {
      var counter = Counter(size: 4);

      var initialValue = counter.getValue();

      counter.increment();

      expect(counter.getValue(), initialValue + 1);
    });

    test('resets', () {
      var counter = Counter(size: 4);

      counter.increment();
      counter.reset();

      expect(counter.getValue(), 0);
    });

    test('wraps around', () {
      var counter = Counter(size: 4);

      counter.setValue(pow(2, counter.getSize()).floor() - 1);
      counter.increment();

      expect(counter.getValue(), 0);
    });
  });
}
