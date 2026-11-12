import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../core/constants/app_config.dart';

/// Theme and language choices, persisted on the device.
class PreferencesProvider {
  Box<dynamic> get _box => Hive.box<dynamic>(StorageKeys.preferencesBox);

  ThemeMode readThemeMode() {
    final name = _box.get(StorageKeys.themeMode);
    return ThemeMode.values.firstWhere((mode) => mode.name == name, orElse: () => ThemeMode.system);
  }

  Future<void> writeThemeMode(ThemeMode mode) => _box.put(StorageKeys.themeMode, mode.name);

  String? readLanguageCode() {
    final code = _box.get(StorageKeys.localeCode);
    return code is String ? code : null;
  }

  Future<void> writeLanguageCode(String code) => _box.put(StorageKeys.localeCode, code);
}
