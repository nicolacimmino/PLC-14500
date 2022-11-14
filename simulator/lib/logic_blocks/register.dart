import "dart:math";

class Register {
  late int _size;
  late List<bool> status;

  Register({int size = 8}) {
    _size = size;
    status = List<bool>.filled(_size, false);
  }

  getBit(int index) {
    return status[index];
  }

  setBit(int index, bool newStatus) {
    status[index] = newStatus;
  }

  int getSize() {
    return _size;
  }

  int getValue() {
    int value = 0;
    for (int ix = 0; ix < _size; ix++) {
      value += status[ix] ? pow(2, ix).floor() : 0;
    }

    return value;
  }

  setValue(int value) {
    for (int ix = 0; ix < _size; ix++) {
      status[ix] = ((value & pow(2, ix).floor()) != 0) ? true : false;
    }
  }
}
