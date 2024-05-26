class Timer {
  Duration _duration = const Duration(seconds: 5);
  DateTime _expires = DateTime.now();
  bool _trigger = false;

  setTrigger(bool trigger) {
    if (_trigger == false && trigger == true) {
      _expires = DateTime.now().add(_duration);
    }

    _trigger = trigger;
  }

  bool read() {
    if (_expires.isBefore(DateTime.now())) {
      return false;
    }

    return true;
  }

  setTime(Duration duration) {
    _duration = duration;
  }
}
