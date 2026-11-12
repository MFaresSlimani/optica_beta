import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/utils/load_status.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/glasses_request.dart';
import '../../../../data/models/request_entry.dart';
import '../../../../data/providers/requests_provider.dart';
import '../../../../data/providers/stores_provider.dart';
import '../../../../data/providers/users_provider.dart';
import '../../../services/realtime_service.dart';

enum RequestsBox { sent, received }

enum RequestsFilter { all, pending, done }

class RequestsController extends GetxController {
  RequestsController({
    RequestsProvider? requests,
    UsersProvider? users,
    StoresProvider? stores,
    SessionService? session,
    RealtimeService? realtime,
  }) : _requests = requests ?? Get.find<RequestsProvider>(),
       _users = users ?? Get.find<UsersProvider>(),
       _stores = stores ?? Get.find<StoresProvider>(),
       _session = session ?? Get.find<SessionService>(),
       _realtime =
           realtime ?? (Get.isRegistered<RealtimeService>() ? Get.find<RealtimeService>() : null);

  final RequestsProvider _requests;
  final UsersProvider _users;
  final StoresProvider _stores;
  final SessionService _session;
  final RealtimeService? _realtime;
  final List<Worker> _workers = [];

  final Rx<RequestsBox> box = RequestsBox.sent.obs;
  final Rx<RequestsFilter> filter = RequestsFilter.all.obs;
  final Rx<LoadStatus> status = LoadStatus.loading.obs;
  final RxList<RequestEntry> sent = <RequestEntry>[].obs;
  final RxList<RequestEntry> received = <RequestEntry>[].obs;

  bool get isStoreOwner => _session.user.value?.isStoreOwner ?? false;

  int get pendingReceivedCount => received.where((e) => !e.request.isDone).length;

  List<RequestEntry> get visible {
    final source = box.value == RequestsBox.received && isStoreOwner ? received : sent;
    return switch (filter.value) {
      RequestsFilter.all => source.toList(),
      RequestsFilter.pending => source.where((e) => !e.request.isDone).toList(),
      RequestsFilter.done => source.where((e) => e.request.isDone).toList(),
    };
  }

  @override
  void onInit() {
    super.onInit();
    // Store owners land on their inbox first.
    if (isStoreOwner) box.value = RequestsBox.received;
    _workers.add(ever(_session.user, (_) => load()));
    final realtime = _realtime;
    if (realtime != null) _workers.add(ever(realtime.changes, (_) => load()));
    load();
  }

  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }

  void selectBox(RequestsBox value) => box.value = value;
  void selectFilter(RequestsFilter value) => filter.value = value;

  Future<void> load() async {
    final uid = _session.uid;
    if (uid == null) return;
    if (sent.isEmpty && received.isEmpty) status.value = LoadStatus.loading;
    try {
      final results = await Future.wait([
        _requests.getSent(uid),
        if (isStoreOwner) _requests.getReceived(uid) else Future.value(const <GlassesRequest>[]),
      ]);
      final all = [...results[0], ...results[1]];
      final lookups = await (
        _users.getUsers(all.expand((r) => [r.senderUid, r.receiverUid])),
        _stores.getStores(all.map((r) => r.storeId)),
      ).wait;

      RequestEntry entryFor(GlassesRequest r) => RequestEntry(
        request: r,
        store: lookups.$2[r.storeId],
        sender: lookups.$1[r.senderUid],
        receiver: lookups.$1[r.receiverUid],
      );

      sent.assignAll(results[0].map(entryFor));
      received.assignAll(results[1].map(entryFor));
      status.value = LoadStatus.ready;
    } on DataException {
      status.value = LoadStatus.error;
    } on ParallelWaitError<dynamic, dynamic> {
      status.value = LoadStatus.error;
    }
  }

  Future<void> open(RequestEntry entry) async {
    final changed = await Get.toNamed<bool>(AppRoutes.requestDetails, arguments: entry);
    if (changed ?? false) await load();
  }
}
