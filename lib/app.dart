import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/constants/app_config.dart';
import 'core/constants/app_strings.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/services/preferences_service.dart';
import 'core/services/session_service.dart';
import 'core/theme/app_theme.dart';
import 'core/translations/app_translations.dart';

class OpticaApp extends StatelessWidget {
  const OpticaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<PreferencesService>();
    final signedIn = Get.find<SessionService>().isSignedIn;
    return GetMaterialApp(
      onGenerateTitle: (_) => AppStrings.appName.tr,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: prefs.themeMode.value,
      translations: AppTranslations(),
      locale: prefs.language.value.locale,
      fallbackLocale: AppLanguage.fallback.locale,
      // Material/Cupertino strings and RTL layout for Arabic. Tamazight has no
      // Flutter localization yet, so framework strings fall back to French.
      supportedLocales: const [Locale('fr'), Locale('en'), Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      localeListResolutionCallback: (locales, supported) {
        final code = locales?.firstOrNull?.languageCode;
        return supported.firstWhere(
          (locale) => locale.languageCode == code,
          orElse: () => supported.first,
        );
      },
      initialRoute: signedIn ? AppRoutes.shell : AppRoutes.login,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
