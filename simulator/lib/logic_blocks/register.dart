import "dart:math";

class Register {
  late final int _size;
  late final List<bool> _status;

  getStatus() {
    return _status;
  }

  Register({int size = 8}) {
    _size = size;
    _status = List<bool>.filled(_size, false);
  }

  getBit(int index) {
    return _status[index];
  }

  setBit(int index, bool newStatus) {
    _status[index] = newStatus;
  }

  int getSize() {
    return _size;
  }

  int getValue() {
    int value = 0;
    for (int ix = 0; ix < _size; ix++) {
      value += _status[ix] ? pow(2, ix).floor() : 0;
    }

    return value;
  }

  setValue(int value) {
    for (int ix = 0; ix < _size; ix++) {
      _status[ix] = ((value & pow(2, ix).floor()) != 0) ? true : false;
    }
  }
}
