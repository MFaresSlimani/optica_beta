import 'dart:io';

import 'package:bng_optica/core/constants/app_config.dart';
import 'package:bng_optica/core/translations/app_translations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every key declared in AppStrings, read from source so a new constant
/// without translations fails CI.
Set<String> _declaredKeys() {
  final source = File('lib/core/constants/app_strings.dart').readAsStringSync();
  return RegExp(
    r"static const String \w+ = '([^']+)';",
  ).allMatches(source).map((m) => m.group(1)!).toSet();
}

void main() {
  final keys = AppTranslations().keys;
  final declared = _declaredKeys();

  test('AppStrings is not empty (sanity check for the source scan)', () {
    expect(declared.length, greaterThan(150));
  });

  for (final language in AppLanguage.all) {
    final tag = '${language.locale.languageCode}_${language.locale.countryCode}';

    group(language.nativeName, () {
      test('has a translation map', () {
        expect(keys, contains(tag));
      });

      test('translates every AppStrings key', () {
        final missing = declared.difference(keys[tag]!.keys.toSet());
        expect(missing, isEmpty, reason: '$tag is missing: ${missing.join(', ')}');
      });

      test('has no blank values', () {
        final blank = keys[tag]!.entries.where((e) => e.value.trim().isEmpty).map((e) => e.key);
        expect(blank, isEmpty);
      });

      test('keeps every @placeholder of the English string', () {
        final placeholder = RegExp(r'@\w+');
        for (final key in declared) {
          final english = placeholder.allMatches(keys['en_UK']![key]!).map((m) => m[0]).toSet();
          final local = placeholder.allMatches(keys[tag]![key]!).map((m) => m[0]).toSet();
          expect(local, english, reason: '$tag "$key"');
        }
      });
    });
  }

  test('Tamazight is written in Tifinagh', () {
    final tifinagh = RegExp(r'[ⴰ-⵿]');
    expect(keys['kab_KAB']!['Login'], matches(tifinagh));
    expect(keys['kab_KAB']!['Stores'], matches(tifinagh));
  });

  test('locale aliases resolve to the same map', () {
    expect(identical(keys['kab'], keys['kab_KAB']), isTrue);
    expect(identical(keys['en_US'], keys['en_UK']), isTrue);
  });
}
