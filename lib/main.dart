import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'authentication.dart';
import 'core/network/supabase_client.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'notifications/notifications.dart';
import 'screens/request_screen/make_request.dart';
import 'theme/themes.dart';
import 'translation/translations.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initSupabase();
    await NotificationController().initNotifications();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Supabase: $e');
    }
  }

  Get.put(GlassesController());
  Get.put(AuthenticationService());

  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  await Hive.openBox('glassesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BNG Optica',
      initialRoute: AppRoutes.initial,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      translations: Translation(),
      locale: const Locale('fr', 'FR'),
      fallbackLocale: const Locale('fr', 'FR'),
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}