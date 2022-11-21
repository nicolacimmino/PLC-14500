import 'package:simulator/logic_blocks/register.dart';

class MC14500 {
  Register i = Register(size: 4);
  bool ien = false;
  bool oen = false;
  bool d = false;
  bool rr = false;
  bool jmp = false;
  bool rtn = false;
  bool w = false;
  bool flagO = false;
  bool flagF = false;
  bool _skipNext = false;

  late List<void Function()> _instructions;

  MC14500() {
    _instructions = List<void Function()>.from([
      _nopo,
      _ld,
      _ldc,
      _and,
      _andc,
      _or,
      _orc,
      _xnor,
      _sto,
      _stoc,
      _ien,
      _oen,
      _jmp,
      _rtn,
      _skz,
      _nopf
    ]);
  }

  void _nopo() {
    flagO = true;
  }

  void _ld() {
    rr = _readD();
  }

  void _ldc() {
    rr = !_readD();
  }

  void _and() {
    rr = rr && _readD();
  }

  void _andc() {
    rr = rr && !_readD();
  }

  void _or() {
    rr = rr || _readD();
  }

  void _orc() {
    rr = rr || !_readD();
  }

  void _xnor() {
    rr = !(rr ^ _readD());
  }

  void _sto() {
    d = rr;
    w = oen ? true : false;
  }

  void _stoc() {
    d = !rr;
    w = oen ? true : false;
  }

  void _ien() {
    ien = d;
  }

  void _oen() {
    oen = d;
  }

  void _jmp() {
    jmp = true;
  }

  void _rtn() {
    rtn = true;
    _skipNext = true;
  }

  void _skz() {
    if (rr == false) {
      _skipNext = true;
    }
  }

  void _nopf() {
    flagF = true;
  }

  clock(bool clockPhase) {
    if (clockPhase) {
      if (_skipNext) {
        _skipNext = false;
        rtn = false;
        return;
      }

      _clockHi();

      return;
    }

    _clockLow();
  }

  _clockLow() {
    flagO = false;
    flagF = false;
    jmp = false;
    w = false;
  }

  _clockHi() {
    _instructions[i.getValue()]();
  }

  bool _readD() {
    if (!ien) {
      return false;
    }

    return d;
  }
}
