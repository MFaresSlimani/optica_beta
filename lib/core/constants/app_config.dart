import 'package:flutter/widgets.dart';

/// External links and contact details shown in the About screen.
abstract final class AppLinks {
  static const String website = 'https://bengherbia-optic.shop';
  static const String websiteLabel = 'bengherbia-optic.shop';
  static const String email = 'Bengherbia_optical@outlook.com';
  static const String facebook = 'https://www.facebook.com/bengherbia.optique/';
  static const String facebookLabel = 'Facebook';
  static const String facebookHandle = 'Bengherbia Optique';
  static const String instagram = 'https://www.instagram.com/bengherbia_optical';
  static const String instagramLabel = 'Instagram';
  static const String instagramHandle = '@bengherbia_optical';
}

/// Local storage (Hive) box and key names.
abstract final class StorageKeys {
  static const String orderDraftsBox = 'glassesBox';
  static const String preferencesBox = 'preferences';
  static const String themeMode = 'theme_mode';
  static const String localeCode = 'locale';
}

/// Languages the app ships. Each has a GetX translation map and a display
/// name written in its own script.
class AppLanguage {
  const AppLanguage(this.locale, this.nativeName, this.shortLabel);

  final Locale locale;
  final String nativeName;
  final String shortLabel;

  static const AppLanguage french = AppLanguage(Locale('fr', 'FR'), 'Français', 'FR');
  static const AppLanguage english = AppLanguage(Locale('en', 'UK'), 'English', 'EN');
  static const AppLanguage arabic = AppLanguage(Locale('ar', 'AR'), 'العربية', 'AR');
  static const AppLanguage tamazight = AppLanguage(Locale('kab', 'KAB'), 'ⵜⴰⵎⴰⵣⵉⵖⵜ', 'ⵣ');

  static const List<AppLanguage> all = [french, english, arabic, tamazight];
  static const AppLanguage fallback = french;

  static AppLanguage fromCode(String? languageCode) {
    return all.firstWhere(
      (lang) => lang.locale.languageCode == languageCode,
      orElse: () => fallback,
    );
  }
}

/// Lens types offered in the order builder.
abstract final class LensCatalog {
  static const List<String> types = [
    'HCT 1.56',
    'Blue Block 1.56',
    'HMC 1.56',
    'HMC 1.61',
    'HMC 1.67',
    'HMC 1.74',
    'Photochromique Gris',
    'Photochromique Brun',
    'Hydrophobe',
    'Oléophobe',
    'Blanc Organique',
    'Polycarbonate',
    'Transitions',
    'Trivex',
    'UV400',
    'Polarisé',
  ];

  /// Largest absolute diopter the picker offers, in quarter steps (±10.75).
  static const int maxQuarterSteps = 43;
}
