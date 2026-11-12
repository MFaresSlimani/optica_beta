import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/providers/preferences_provider.dart';
import '../constants/app_config.dart';

/// Theme mode and language, restored on launch and saved on change.
class PreferencesService extends GetxService {
  PreferencesService({PreferencesProvider? provider})
    : _provider = provider ?? Get.find<PreferencesProvider>();

  final PreferencesProvider _provider;

  late final Rx<ThemeMode> themeMode = _provider.readThemeMode().obs;
  late final Rx<AppLanguage> language = AppLanguage.fromCode(_provider.readLanguageCode()).obs;

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    await _provider.writeThemeMode(mode);
  }

  Future<void> setLanguage(AppLanguage lang) async {
    language.value = lang;
    await Get.updateLocale(lang.locale);
    await _provider.writeLanguageCode(lang.locale.languageCode);
  }
}
