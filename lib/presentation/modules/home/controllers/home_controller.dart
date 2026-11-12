import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/utils/load_status.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/store.dart';
import '../../../../data/providers/stores_provider.dart';

/// Store directory: loads approved stores and filters them as you type.
class HomeController extends GetxController {
  HomeController({StoresProvider? stores, SessionService? session})
    : _stores = stores ?? Get.find<StoresProvider>(),
      _session = session ?? Get.find<SessionService>();

  final StoresProvider _stores;
  final SessionService _session;

  final searchController = TextEditingController();
  final RxList<Store> stores = <Store>[].obs;
  final Rx<LoadStatus> status = LoadStatus.loading.obs;
  final RxString query = ''.obs;

  String get firstName => _session.user.value?.displayName.split(' ').first ?? '';

  bool isMine(Store store) => store.ownerUid == _session.uid;

  /// Stores matching [query] by name or location, own store first.
  List<Store> get visibleStores {
    final q = query.value.trim().toLowerCase();
    final matches = q.isEmpty
        ? stores.toList()
        : stores
              .where(
                (s) => s.name.toLowerCase().contains(q) || s.location.toLowerCase().contains(q),
              )
              .toList();
    matches.sort((a, b) => (isMine(b) ? 1 : 0) - (isMine(a) ? 1 : 0));
    return matches;
  }

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    if (stores.isEmpty) status.value = LoadStatus.loading;
    try {
      stores.assignAll(await _stores.getApprovedStores());
      status.value = LoadStatus.ready;
    } on DataException {
      status.value = LoadStatus.error;
    }
  }

  void onSearchChanged(String value) => query.value = value;

  void clearSearch() {
    searchController.clear();
    query.value = '';
  }

  Future<void> openStore(Store store) async {
    final changed = await Get.toNamed<bool>(AppRoutes.storeDetails, arguments: store);
    if (changed ?? false) await load();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
