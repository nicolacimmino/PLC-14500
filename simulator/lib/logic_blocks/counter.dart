import "dart:math";

import 'package:simulator/logic_blocks/register.dart';

class Counter extends Register {
  Counter({int size = 8}) : super(size: size);

  increment() {
    setValue((getValue() + 1) % (pow(2, getSize()).floor()));
  }

  reset() {
    setValue(0);
  }
}
