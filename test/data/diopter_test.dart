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

    test('format and parse round-trip over the whole picker range', () {
      for (final d in Diopter.range(43)) {
        expect(Diopter.tryParse(d.format()), d, reason: d.format());
      }
    });

    test('range is symmetric, ascending and centred on zero', () {
      final range = Diopter.range(4);
      expect(range, hasLength(9));
      expect(range.first, const Diopter.quarters(-4));
      expect(range[4], Diopter.zero);
      expect(range, orderedEquals([...range]..sort()));
    });
  });
}
