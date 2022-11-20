class Ram {
  late final int _size;
  late final List<int> _content;
  int address = 0;

  Ram({int size = 256}) {
    _size = size;
    _content = List<int>.filled(_size, 0);
  }

  int getSize() {
    return _size;
  }

  int read() {
    return _content[address];
  }

  write(int value) {
    _content[address] = value;
  }

  writeBulk(List<int> values) {
    for (int ix = 0; ix < values.length; ix++) {
      write(values[ix]);
    }
  }
}
