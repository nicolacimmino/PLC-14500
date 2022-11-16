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
}
