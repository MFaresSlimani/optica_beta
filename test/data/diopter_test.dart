import 'package:bng_optica/data/models/diopter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Diopter', () {
    test('stores exact quarter steps, so float noise cannot break equality', () {
      expect(Diopter.fromValue(0.1 + 0.15), const Diopter.quarters(1));
      expect(Diopter.fromValue(-2.25), const Diopter.quarters(-9));
      expect(Diopter.fromValue(1.24).value, 1.25);
    });

    test('formats with an explicit sign and two decimals', () {
      expect(const Diopter.quarters(5).format(), '+1.25');
      expect(const Diopter.quarters(-2).format(), '-0.50');
      expect(Diopter.zero.format(), '+0.00');
    });

    test('parses signed, unsigned and padded input', () {
      expect(Diopter.tryParse('+1.25'), const Diopter.quarters(5));
      expect(Diopter.tryParse('-0.50'), const Diopter.quarters(-2));
      expect(Diopter.tryParse(' 2 '), const Diopter.quarters(8));
      expect(Diopter.tryParse('abc'), isNull);
      expect(Diopter.tryParse('1.2.3'), isNull);
    });

    test('splits into sign, whole and quarter parts', () {
      final d = Diopter.fromValue(-2.75);
      expect(d.isNegative, isTrue);
      expect(d.wholePart, 2);
      expect(d.quarterPart, 3);
      expect(Diopter.quarterLabels[d.quarterPart], '75');
    });

    test('every picker combination round-trips through parts and text', () {
      for (final negative in [false, true]) {
        for (var whole = 0; whole <= 10; whole++) {
          for (var quarter = 0; quarter < 4; quarter++) {
            final d = Diopter.fromParts(negative: negative, whole: whole, quarter: quarter);
            expect(Diopter.tryParse(d.format()), d, reason: d.format());
            if (!d.isZero) {
              expect((d.isNegative, d.wholePart, d.quarterPart), (negative, whole, quarter));
            }
          }
        }
      }
    });

    test('negative zero is just zero', () {
      expect(Diopter.fromParts(negative: true, whole: 0, quarter: 0), Diopter.zero);
    });
  });
}
