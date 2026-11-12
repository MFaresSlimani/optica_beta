import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/app_info_service.dart';
import '../../../../core/services/preferences_service.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/data_exception.dart';
import '../../../services/feedback_service.dart';

class SettingsController extends GetxController {
  SettingsController({
    PreferencesService? preferences,
    SessionService? session,
    FeedbackService? feedback,
    AppInfoService? appInfo,
  }) : _preferences = preferences ?? Get.find<PreferencesService>(),
       _session = session ?? Get.find<SessionService>(),
       _feedback = feedback ?? Get.find<FeedbackService>(),
       _appInfo = appInfo ?? Get.find<AppInfoService>();

  final PreferencesService _preferences;
  final SessionService _session;
  final FeedbackService _feedback;
  final AppInfoService _appInfo;

  final RxBool isSigningOut = false.obs;

  Rx<ThemeMode> get themeMode => _preferences.themeMode;
  Rx<AppLanguage> get language => _preferences.language;
  Rxn<AppUser> get user => _session.user;
  String get version => _appInfo.label;

  Future<void> setThemeMode(ThemeMode mode) => _preferences.setThemeMode(mode);

  void openAbout() => Get.toNamed<void>(AppRoutes.about);

  Future<void> logout() async {
    final confirmed = await _feedback.confirm(
      title: AppStrings.logoutConfirmTitle.tr,
      message: AppStrings.logoutConfirmMessage.tr,
      confirmLabel: AppStrings.logout.tr,
      destructive: true,
      icon: Icons.logout_rounded,
    );
    if (!confirmed) return;
    isSigningOut.value = true;
    try {
      await _session.signOut();
      await Get.offAllNamed<void>(AppRoutes.login);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      isSigningOut.value = false;
    }
  }
}
