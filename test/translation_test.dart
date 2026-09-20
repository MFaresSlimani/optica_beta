import 'package:flutter_test/flutter_test.dart';
import 'package:bng_optica/translation/translations.dart';

void main() {
  group('Translations Tests', () {
    final translations = Translation();
    final keys = translations.keys;

    test('All required locales are present', () {
      expect(keys.containsKey('en_UK'), isTrue);
      expect(keys.containsKey('fr_FR'), isTrue);
      expect(keys.containsKey('ar_AR'), isTrue);
      expect(keys.containsKey('kab_KAB'), isTrue);
    });

    test('kab_KAB contains all keys present in en_UK', () {
      final enKeys = keys['en_UK']!.keys.toSet();
      final kabKeys = keys['kab_KAB']!.keys.toSet();

      final missingInKab = enKeys.difference(kabKeys);
      expect(missingInKab, isEmpty,
          reason: 'kab_KAB should have all keys from en_UK');
    });

    test('kab_KAB translations contain valid Tifinagh characters', () {
      final kab = keys['kab_KAB']!;

      // Spot check key optical & app terms
      expect(kab['Login'], 'ⴰⵏⴻⴽⵛⵓⵎ');
      expect(kab['Requests'], 'ⵉⵙⵓⵜⵔⴻⵏ');
      expect(kab['Settings'], 'ⵉⵖⴻⵡⵡⴰⵔⴻⵏ');
      expect(kab['Make_order'], 'ⵙⵙⵓⵜⴻⵔ');
      expect(kab['Type_of_glasses'], 'ⴰⵏⴰⵡ ⵏ ⵜⵙⴻⴽⴽⵉⵔⵉⵏ');
      expect(kab['Store'], 'ⵜⴰⵃⴰⵏⵓⵜⵜ');
      expect(kab['Discard_changes'], 'ⵙⴻⴼⵙⴻⵅ ⵉⴱⴻⴷⴷⵉⵍⴻⵏ?');
      expect(kab['Light_mode'], 'ⴰⵙⴽⴰⵔ ⵏ ⵜⴰⴼⴰⵜ');
      expect(kab['Welcome_Back'], 'ⴰⵏⵙⵓⴼ ⵢⵉⵙ-ⵡⴻⵏ');

      // Ensure no values are empty or null
      for (final entry in kab.entries) {
        expect(entry.value.trim().isNotEmpty, isTrue,
            reason: 'Key "${entry.key}" in kab_KAB must not be empty');
      }
    });

    test('Locale aliases function correctly', () {
      expect(keys['kab'], equals(keys['kab_KAB']));
      expect(keys['en_US'], equals(keys['en_UK']));
    });
  });
}
