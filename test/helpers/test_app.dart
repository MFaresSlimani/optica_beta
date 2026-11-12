import 'dart:convert';

import 'package:bng_optica/core/constants/app_config.dart';
import 'package:bng_optica/core/services/app_info_service.dart';
import 'package:bng_optica/core/services/preferences_service.dart';
import 'package:bng_optica/core/services/session_service.dart';
import 'package:bng_optica/core/theme/app_theme.dart';
import 'package:bng_optica/core/translations/app_translations.dart';
import 'package:bng_optica/data/models/app_user.dart';
import 'package:bng_optica/presentation/services/feedback_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'fakes.dart';

/// Loads every font declared in pubspec (Manrope, Arabic, Tifinagh and
/// Material Icons) so widget tests render real glyphs instead of boxes.
Future<void> loadAppFonts() async {
  final manifest = json.decode(await rootBundle.loadString('FontManifest.json')) as List<dynamic>;
  for (final family in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(family['family'] as String);
    for (final font in (family['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
  await initializeDateFormatting();
}

/// Registers the app-wide services with fakes. Returns the session.
SessionService registerServices({AppUser? user, FakeUsersProvider? users}) {
  Get
    ..reset()
    ..testMode = true;
  final session = signedInSession(user, users: users);
  Get
    ..put<SessionService>(session)
    ..put<FeedbackService>(RecordingFeedback())
    ..put(PreferencesService(provider: FakePreferencesProvider()))
    ..put(AppInfoService(version: '1.3.0', buildNumber: '3'));
  return session;
}

/// Phone-sized surface: 390 × 844 logical px with notch insets.
void usePhoneSurface(WidgetTester tester, {double pixelRatio = 3, double height = 844}) {
  tester.view
    ..devicePixelRatio = pixelRatio
    ..physicalSize = Size(390 * pixelRatio, height * pixelRatio)
    ..padding = FakeViewPadding(top: 47 * pixelRatio, bottom: 34 * pixelRatio)
    ..viewPadding = FakeViewPadding(top: 47 * pixelRatio, bottom: 34 * pixelRatio);
  addTearDown(tester.view.reset);
}

const screenshotKey = ValueKey('screenshot');

/// Pumps [home] inside a fully configured app.
///
/// With [framed], the screen gets a status bar and rounded corners so the
/// PNG reads as a phone screenshot in the README.
Future<void> pumpApp(
  WidgetTester tester,
  Widget home, {
  ThemeMode themeMode = ThemeMode.light,
  Locale locale = const Locale('en', 'UK'),
  bool framed = false,
  bool lightStatusBar = false,
}) async {
  Get.locale = locale;
  final app = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: themeMode,
    translations: AppTranslations(),
    locale: locale,
    fallbackLocale: AppLanguage.fallback.locale,
    supportedLocales: const [Locale('fr'), Locale('en'), Locale('ar')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    home: home,
  );

  if (!framed) {
    await tester.pumpWidget(app);
    await settle(tester);
    return;
  }

  final dark = themeMode == ThemeMode.dark || lightStatusBar;
  await tester.pumpWidget(
    RepaintBoundary(
      key: screenshotKey,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(48),
          child: Stack(
            children: [
              app,
              Positioned(top: 0, left: 0, right: 0, child: _StatusBar(light: dark)),
            ],
          ),
        ),
      ),
    ),
  );
  await settle(tester);
}

/// Pumps frames without waiting for infinite animations to end, decoding
/// any images on the way.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.runAsync(() async {
    for (final element in find.byType(Image).evaluate()) {
      final image = element.widget as Image;
      await precacheImage(image.image, element);
    }
  });
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.light});

  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? Colors.white : const Color(0xFF14262A);
    final style = TextStyle(
      fontFamily: 'Manrope',
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: color,
      decoration: TextDecoration.none,
    );
    return SizedBox(
      height: 47,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(36, 14, 28, 0),
        child: Row(
          textDirection: TextDirection.ltr,
          children: [
            Text('9:41', style: style, textDirection: TextDirection.ltr),
            const Spacer(),
            Icon(Icons.signal_cellular_alt_rounded, size: 18, color: color),
            const SizedBox(width: 4),
            Icon(Icons.wifi_rounded, size: 18, color: color),
            const SizedBox(width: 4),
            Icon(Icons.battery_full_rounded, size: 20, color: color),
          ],
        ),
      ),
    );
  }
}
