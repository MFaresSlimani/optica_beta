import 'package:bng_optica/data/models/diopter.dart';
import 'package:bng_optica/data/models/lens_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LensItem wire format', () {
    // Exactly what app versions before the rework wrote to Supabase and Hive.
    const legacy = 'HMC 1.61\n CYL: -0.50,\t\t\t SPH: +1.25 (x3)';

    test('decodes the legacy string', () {
      final item = LensItem.decode(legacy);
      expect(item.isParsed, isTrue);
      expect(item.type, 'HMC 1.61');
      expect(item.cylinder, Diopter.fromValue(-0.5));
      expect(item.sphere, Diopter.fromValue(1.25));
      expect(item.quantity, 3);
    });

    test('encodes byte-for-byte compatible with older app versions', () {
      expect(LensItem.decode(legacy).encode(), legacy);
    });

    test('handles multi-word and accented lens types', () {
      final item = LensItem(
        type: 'Photochromique Gris Oléophobe',
        cylinder: Diopter.zero,
        sphere: Diopter.fromValue(-10.75),
        quantity: 12,
      );
      expect(LensItem.decode(item.encode()), item);
    });

    test('keeps unparseable text verbatim instead of losing it', () {
      const garbage = 'Something typed by hand';
      final item = LensItem.decode(garbage);
      expect(item.isParsed, isFalse);
      expect(item.encode(), garbage);
      expect(item.copyWith(quantity: 9).encode(), garbage);
    });
  });

  group('LensItem identity', () {
    const a = LensItem(
      type: 'Blue Block 1.56',
      cylinder: Diopter.zero,
      sphere: Diopter.quarters(2),
    );

    test('same lens ignores case, padding and quantity', () {
      const b = LensItem(
        type: '  blue block 1.56 ',
        cylinder: Diopter.zero,
        sphere: Diopter.quarters(2),
        quantity: 5,
      );
      expect(a.isSameLensAs(b), isTrue);
      expect(a == b, isFalse, reason: 'equality still includes quantity and exact type');
    });

    test('different power or type is a different lens', () {
      expect(a.isSameLensAs(a.copyWith()), isTrue);
      expect(
        a.isSameLensAs(
          LensItem(type: a.type, cylinder: const Diopter.quarters(1), sphere: a.sphere),
        ),
        isFalse,
      );
      expect(
        a.isSameLensAs(LensItem(type: 'HMC 1.56', cylinder: a.cylinder, sphere: a.sphere)),
        isFalse,
      );
    });
  });
}
