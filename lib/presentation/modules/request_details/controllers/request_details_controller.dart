import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/request_entry.dart';

class RequestDetailsController extends GetxController {
  RequestDetailsController({required RequestEntry entry, SessionService? session})
    : entry = entry.obs,
      _session = session ?? Get.find<SessionService>();

  final Rx<RequestEntry> entry;
  final SessionService _session;
  bool _changed = false;

  bool get isReceiver => entry.value.request.receiverUid == _session.uid;
  bool get canProcess => isReceiver && !entry.value.request.isDone;

  Future<void> process() async {
    final updated = await Get.toNamed<RequestEntry>(
      AppRoutes.handleRequest,
      arguments: entry.value,
    );
    if (updated != null) {
      entry.value = updated;
      _changed = true;
    }
  }

  void printTicket() => Get.toNamed<void>(AppRoutes.printing, arguments: entry.value);

  void openSender() {
    final uid = entry.value.request.senderUid;
    if (uid.isNotEmpty) Get.toNamed<void>(AppRoutes.userProfile, arguments: uid);
  }

  /// Back navigation tells the list whether it needs to reload.
  void close() => Get.back<bool>(result: _changed);
}
