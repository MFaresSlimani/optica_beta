import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/constants/app_config.dart';
import 'core/network/supabase_client.dart';
import 'core/services/app_info_service.dart';
import 'core/services/preferences_service.dart';
import 'core/services/session_service.dart';
import 'data/providers/auth_provider.dart';
import 'data/providers/order_draft_provider.dart';
import 'data/providers/preferences_provider.dart';
import 'data/providers/printer_provider.dart';
import 'data/providers/requests_provider.dart';
import 'data/providers/storage_provider.dart';
import 'data/providers/stores_provider.dart';
import 'data/providers/users_provider.dart';
import 'presentation/services/feedback_service.dart';
import 'presentation/services/realtime_service.dart';

/// Everything that must exist before the first frame: local storage, the
/// backend client and the app-wide services. Feature controllers are
/// created lazily by their route bindings.
abstract final class Bootstrap {
  static Future<void> init() async {
    await Future.wait([
      initializeDateFormatting(),
      Hive.initFlutter().then(
        (_) => Future.wait([
          Hive.openBox<dynamic>(StorageKeys.orderDraftsBox),
          Hive.openBox<dynamic>(StorageKeys.preferencesBox),
        ]),
      ),
    ]);

    try {
      await initSupabase();
    } catch (error) {
      // The UI still starts and shows error states; log for diagnosis.
      debugPrint('Supabase failed to initialise: $error');
    }

    final appInfo = await AppInfoService.load();

    Get
      ..put(AuthProvider(), permanent: true)
      ..put(UsersProvider(), permanent: true)
      ..put(StoresProvider(), permanent: true)
      ..put(RequestsProvider(), permanent: true)
      ..put(StorageProvider(), permanent: true)
      ..put(OrderDraftProvider(), permanent: true)
      ..put(PreferencesProvider(), permanent: true)
      ..lazyPut(PrinterProvider.new, fenix: true)
      ..put(appInfo, permanent: true)
      ..put(FeedbackService(), permanent: true)
      ..put(PreferencesService(), permanent: true);

    final session = Get.put(SessionService(), permanent: true);
    await session.refreshUser();
    Get.put(RealtimeService(), permanent: true);
  }
}
