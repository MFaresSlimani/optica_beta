import '../constants/app_strings.dart';

/// Form validators. Each returns a translation key on failure, or null.
/// Views translate with `.tr`; controllers and tests compare keys.
abstract final class Validators {
  static const int minPasswordLength = 6;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return AppStrings.pleaseEnterEmail;
    if (!_email.hasMatch(input)) return AppStrings.pleaseEnterValidEmail;
    return null;
  }

  static String? password(String? value) {
    final input = value ?? '';
    if (input.isEmpty) return AppStrings.pleaseEnterPassword;
    if (input.length < minPasswordLength) return AppStrings.passwordTooShort;
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if ((value ?? '').isEmpty) return AppStrings.pleaseEnterPassword;
    if (value != original) return AppStrings.passwordsDontMatch;
    return null;
  }

  /// Returns [messageKey] when [value] is blank.
  static String? required(String? value, String messageKey) {
    return (value?.trim() ?? '').isEmpty ? messageKey : null;
  }

  /// Optional phone: empty is fine, otherwise 6–20 digits with + ( ) - and spaces.
  static String? optionalPhone(String? value) {
    final input = value?.trim() ?? '';
    if (input.isEmpty) return null;
    final digits = input.replaceAll(RegExp(r'[\s()+-]'), '');
    final valid = RegExp(r'^\d{6,20}$').hasMatch(digits);
    return valid ? null : AppStrings.pleaseEnterPhoneNumber;
  }
}
