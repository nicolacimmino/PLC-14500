import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter_test/flutter_test.dart';
import 'package:simulator/logic_blocks/register.dart';

void main() {
  group("Register", () {
    test('get size', () {
      var register = Register(size: 4);

      expect(register.getSize(), 4);
    });

    test('set value', () {
      var register = Register(size: 4);

      dynamic testData = json.decoder.convert(
          io.File("test/data/register_set_value.json").readAsStringSync());

      for (var testDataPoint in testData) {
        var value = testDataPoint['value'];
        var expectedBits = testDataPoint['expected'];

        register.setValue(value);

        for (var ix = 0; ix < expectedBits.length; ix++) {
          expect(register.status[ix], expectedBits[ix],
              reason: "bit $ix of $value");
        }
      }
    });

    test('get value', () {
      var register = Register(size: 4);

      dynamic testData = json.decoder.convert(
          io.File("test/data/register_get_value.json").readAsStringSync());

      for (var testDataPoint in testData) {
        var bits = testDataPoint['value'];
        var expectedValue = testDataPoint['expected'];

        for (var ix = 0; ix < register.getSize(); ix++) {
          register.status[ix] = bits[ix];
        }

        expect(register.getValue(), expectedValue);
      }
    });

    test('set bit', () {
      var register = Register(size: 4);

      dynamic testData = json.decoder.convert(
          io.File("test/data/register_set_bit.json").readAsStringSync());

      for (var testDataPoint in testData) {
        var bits = testDataPoint['value'];
        var expectedValue = testDataPoint['expected'];

        for (var ix = 0; ix < register.getSize(); ix++) {
          register.setBit(ix, bits[ix]);
        }

        expect(register.getValue(), expectedValue);
      }
    });

    test('get bit', () {
      var register = Register(size: 4);

      dynamic testData = json.decoder.convert(
          io.File("test/data/register_get_bit.json").readAsStringSync());

      for (var testDataPoint in testData) {
        var value = testDataPoint['value'];
        var expectedBits = testDataPoint['expected'];

        register.setValue(value);

        for (var ix = 0; ix < expectedBits.length; ix++) {
          expect(register.getBit(ix), expectedBits[ix],
              reason: "bit $ix of $value");
        }
      }
    });
  });
}
