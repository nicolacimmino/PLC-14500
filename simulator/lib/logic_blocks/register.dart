class Register {
  late int _size;
  late final List<bool> _status;

  Register({int size = 8}) {
    _size = size;
    _status = List<bool>.filled(_size, false);
  }

  bool getStatus(int index) {
    return _status[index];
  }

  setStatus(int index, bool status) {
    _status[index] = status;
    print(_status.toString());
  }

  int getSize() {
    return _size;
  }
}
