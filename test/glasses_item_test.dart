import 'package:flutter_test/flutter_test.dart';
import 'package:bng_optica/screens/request_screen/make_request.dart';

void main() {
  group('GlassesItem Tests', () {
    test('Format and parse GlassesItem', () {
      final item = GlassesItem(
        type: 'HCT 1.56',
        cyl: 1.25,
        sph: -2.50,
        quantity: 3,
      );

      final str = item.toFormattedString();
      expect(str, contains('HCT 1.56'));
      expect(str, contains('CYL: +1.25'));
      expect(str, contains('SPH: -2.50'));
      expect(str, contains('(x3)'));

      final parsed = GlassesItem.fromFormattedString(str);
      expect(parsed, isNotNull);
      expect(parsed!.type, equals('HCT 1.56'));
      expect(parsed.cyl, closeTo(1.25, 0.001));
      expect(parsed.sph, closeTo(-2.50, 0.001));
      expect(parsed.quantity, equals(3));
    });

    test('Match exact same glasses parameters', () {
      final item1 = GlassesItem(
        type: 'Blue Block 1.56',
        cyl: 0.00,
        sph: 0.50,
        quantity: 1,
      );

      expect(item1.matches('Blue Block 1.56', 0.00, 0.50), isTrue);
      expect(item1.matches('blue block 1.56', 0.00, 0.50), isTrue); // case-insensitive
      expect(item1.matches('Blue Block 1.56', 0.25, 0.50), isFalse); // different CYL
      expect(item1.matches('Blue Block 1.56', 0.00, -0.50), isFalse); // different SPH
      expect(item1.matches('HMC 1.56', 0.00, 0.50), isFalse); // different type
    });

    test('Quantity accumulation on duplicate additions', () {
      final list = <String>[];

      void addItem(String type, double cyl, double sph, int qty) {
        int existingIndex = -1;
        GlassesItem? existingItem;

        for (int i = 0; i < list.length; i++) {
          final parsed = GlassesItem.fromFormattedString(list[i]);
          if (parsed != null && parsed.matches(type, cyl, sph)) {
            existingIndex = i;
            existingItem = parsed;
            break;
          }
        }

        if (existingIndex != -1 && existingItem != null) {
          existingItem.quantity += qty;
          list[existingIndex] = existingItem.toFormattedString();
        } else {
          final newItem = GlassesItem(
            type: type,
            cyl: cyl,
            sph: sph,
            quantity: qty,
          );
          list.add(newItem.toFormattedString());
        }
      }

      // Add item 1
      addItem('HCT 1.56', 0.0, 0.0, 1);
      expect(list.length, equals(1));
      expect(GlassesItem.fromFormattedString(list[0])!.quantity, equals(1));

      // Add exact same item again with qty 2
      addItem('HCT 1.56', 0.0, 0.0, 2);
      expect(list.length, equals(1)); // merged!
      expect(GlassesItem.fromFormattedString(list[0])!.quantity, equals(3));

      // Add a different item
      addItem('HCT 1.56', 0.25, 0.0, 1);
      expect(list.length, equals(2));
      expect(GlassesItem.fromFormattedString(list[1])!.quantity, equals(1));

      // Add to first item again with qty 5
      addItem('HCT 1.56', 0.0, 0.0, 5);
      expect(list.length, equals(2));
      expect(GlassesItem.fromFormattedString(list[0])!.quantity, equals(8));
    });
  });
}
