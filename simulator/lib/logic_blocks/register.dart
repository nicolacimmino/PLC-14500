class Register {
  late int _size;
  late List<bool> status;
  //late Function(int index, bool status)? onChange;

  Register({int size = 8}) {
    _size = size;
    status = List<bool>.filled(_size, false);
  }

  setStatus(int index, bool newStatus) {
    status[index] = newStatus;

    // if (onChange != null) {
    //   onChange!(index, newStatus);
    // }
  }

  int getSize() {
    return _size;
  }
}
