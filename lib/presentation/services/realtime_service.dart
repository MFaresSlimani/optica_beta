import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/session_service.dart';
import '../../data/providers/requests_provider.dart';
import 'feedback_service.dart';

/// Live alerts for incoming and completed requests.
///
/// Subscribes whenever a user signs in and unsubscribes on sign-out (the old
/// version subscribed once at launch, so a fresh login never got alerts).
/// [changes] ticks on every event so request lists can reload themselves.
class RealtimeService extends GetxService {
  RealtimeService({RequestsProvider? requests, SessionService? session, FeedbackService? feedback})
    : _requests = requests ?? Get.find<RequestsProvider>(),
      _session = session ?? Get.find<SessionService>(),
      _feedback = feedback ?? Get.find<FeedbackService>();

  final RequestsProvider _requests;
  final SessionService _session;
  final FeedbackService _feedback;

  final RxInt changes = 0.obs;

  VoidCallback? _unsubscribe;
  String? _subscribedUid;
  Worker? _worker;

  @override
  void onInit() {
    super.onInit();
    _worker = ever(_session.user, (_) => _sync());
    _sync();
  }

  @override
  void onClose() {
    _worker?.dispose();
    _stop();
    super.onClose();
  }

  void _sync() {
    final uid = _session.user.value?.uid;
    if (uid == _subscribedUid) return;
    _stop();
    if (uid == null) return;
    _subscribedUid = uid;
    _unsubscribe = _requests.subscribe(
      uid: uid,
      onReceived: () => _notify(AppStrings.newOrderTitle, AppStrings.newOrderMessage),
      onCompleted: () => _notify(AppStrings.requestDoneTitle, AppStrings.requestDoneMessage),
    );
  }

  void _stop() {
    _unsubscribe?.call();
    _unsubscribe = null;
    _subscribedUid = null;
  }

  void _notify(String titleKey, String messageKey) {
    changes.value++;
    _feedback.showInfo(
      title: titleKey.tr,
      message: messageKey.tr,
      onTap: () => Get.until((route) => route.settings.name == AppRoutes.shell),
    );
  }
}
