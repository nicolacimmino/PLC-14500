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
    switch (i.getValue()) {
      case 0x00: // NOPO
        flagO = true;
        break;
      case 0x01: // LD
        rr = _readD();
        break;
      case 0x02: // LDC
        rr = !_readD();
        break;
      case 0x03: // AND
        rr = rr && _readD();
        break;
      case 0x04: // ANDC
        rr = rr && !_readD();
        break;
      case 0x05: // OR
        rr = rr || _readD();
        break;
      case 0x06: // ORC
        rr = rr || !_readD();
        break;
      case 0x07: // XNOR
        rr = !(rr ^ _readD());
        break;
      case 0x08: // STO
        _writeD(rr);
        w = true;
        break;
      case 0x09: // STOC
        _writeD(!rr);
        w = true;
        break;
      case 0x0A: // IEN
        ien = d;
        break;
      case 0x0B: // OEN
        oen = d;
        break;
      case 0x0C: // JMP
        jmp = true;
        break;
      case 0x0D: // RTN
        rtn = true;
        _skipNext = true;
        break;
      case 0x0E: // SKZ
        if (rr == false) {
          _skipNext = true;
        }
        break;
      case 0x0F: // NOPF
        flagF = true;
        break;
      default:
        print("Wierd, we got opcode $i");
    }
  }

  bool _readD() {
    if (!ien) {
      return false;
    }

    return d;
  }

  _writeD(bool value) {
    if (!oen) {
      d = false;
    }

    d = value;
  }
}
