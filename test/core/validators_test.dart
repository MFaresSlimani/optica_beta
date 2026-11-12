import 'package:bng_optica/core/constants/app_strings.dart';
import 'package:bng_optica/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('accepts well-formed addresses', () {
      expect(Validators.email('amina@vision-plus.dz'), isNull);
      expect(Validators.email('  a.b+c@d.co  '), isNull);
    });

    test('rejects empty and malformed input with the right key', () {
      expect(Validators.email(''), AppStrings.pleaseEnterEmail);
      expect(Validators.email(null), AppStrings.pleaseEnterEmail);
      for (final bad in ['plain', 'a@b', '@b.c', 'a b@c.d']) {
        expect(Validators.email(bad), AppStrings.pleaseEnterValidEmail, reason: bad);
      }
    });
  });

  test('password requires 6 characters', () {
    expect(Validators.password(''), AppStrings.pleaseEnterPassword);
    expect(Validators.password('12345'), AppStrings.passwordTooShort);
    expect(Validators.password('123456'), isNull);
  });

  test('confirmPassword must match', () {
    expect(Validators.confirmPassword('', 'x'), AppStrings.pleaseEnterPassword);
    expect(Validators.confirmPassword('abc', 'abd'), AppStrings.passwordsDontMatch);
    expect(Validators.confirmPassword('abc', 'abc'), isNull);
  });

  test('required returns the given key for blank input', () {
    expect(Validators.required('  ', 'k'), 'k');
    expect(Validators.required('x', 'k'), isNull);
  });

  test('optionalPhone allows empty and common formats', () {
    expect(Validators.optionalPhone(''), isNull);
    expect(Validators.optionalPhone('+213 (0) 555-12-34-56'), isNull);
    expect(Validators.optionalPhone('12ab'), AppStrings.pleaseEnterPhoneNumber);
  });
}
