import 'package:flutter_test/flutter_test.dart';
import 'package:simulator/logic_blocks/mc14500.dart';

void main() {
  group("MC14500", () {
    test('NOPO', () {
      var mc14500 = MC14500();

      mc14500.i.setValue(0);
      mc14500.clock(true);

      expect(true, mc14500.flagO);

      mc14500.clock(false);
      expect(false, mc14500.flagO);
    });

    test('LD', () {
      var mc14500 = MC14500();

      mc14500.i.setValue(1);
      mc14500.d = true;
      mc14500.rr = false;

      mc14500.clock(true);
      expect(true, mc14500.rr);

      mc14500.clock(false);
      expect(true, mc14500.rr);
    });

    test('LDC', () {
      var mc14500 = MC14500();

      mc14500.i.setValue(2);
      mc14500.d = true;
      mc14500.rr = true;

      mc14500.clock(true);
      expect(false, mc14500.rr);

      mc14500.clock(false);
      expect(false, mc14500.rr);
    });
  });
}
