import 'package:get/get.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/utils/load_status.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/store.dart';
import '../../../../data/providers/stores_provider.dart';
import '../../../../data/providers/users_provider.dart';

/// A user's profile. With no [userId] it shows the signed-in user and
/// follows session changes live.
class ProfileController extends GetxController {
  ProfileController({
    this.userId,
    UsersProvider? users,
    StoresProvider? stores,
    SessionService? session,
  }) : _users = users ?? Get.find<UsersProvider>(),
       _stores = stores ?? Get.find<StoresProvider>(),
       _session = session ?? Get.find<SessionService>();

  final String? userId;
  final UsersProvider _users;
  final StoresProvider _stores;
  final SessionService _session;
  Worker? _sessionWorker;

  final Rxn<AppUser> user = Rxn<AppUser>();
  final Rxn<Store> store = Rxn<Store>();
  final Rx<LoadStatus> status = LoadStatus.loading.obs;

  bool get isMe => userId == null || userId == _session.uid;

  @override
  void onInit() {
    super.onInit();
    if (isMe) {
      _sessionWorker = ever<AppUser?>(_session.user, _applyUser);
      _applyUser(_session.user.value);
    } else {
      load();
    }
  }

  @override
  void onClose() {
    _sessionWorker?.dispose();
    super.onClose();
  }

  Future<void> _applyUser(AppUser? value) async {
    user.value = value;
    status.value = value == null ? LoadStatus.loading : LoadStatus.ready;
    await _loadStore();
  }

  Future<void> load() async {
    if (isMe) return _session.refreshUser();
    status.value = LoadStatus.loading;
    try {
      user.value = await _users.getUser(userId!);
      status.value = LoadStatus.ready;
      await _loadStore();
    } on DataException {
      status.value = LoadStatus.error;
    }
  }

  Future<void> _loadStore() async {
    final storeId = user.value?.storeId;
    if (storeId == null || !(user.value?.isStoreOwner ?? false)) {
      store.value = null;
      return;
    }
    if (store.value?.id == storeId) return;
    try {
      store.value = await _stores.getStore(storeId);
    } on DataException {
      store.value = null;
    }
  }

  void editProfile() => Get.toNamed<void>(AppRoutes.editProfile);

  void createStore() => Get.toNamed<void>(AppRoutes.createStore);

  Future<void> openStore() async {
    final value = store.value;
    if (value == null) return;
    final changed = await Get.toNamed<bool>(AppRoutes.storeDetails, arguments: value);
    if (changed ?? false) store.value = null;
  }
}
