import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/store.dart';
import '../../../../data/providers/stores_provider.dart';
import '../../../../data/providers/users_provider.dart';
import '../../../services/feedback_service.dart';

class StoreDetailsController extends GetxController {
  StoreDetailsController({
    required this.store,
    StoresProvider? stores,
    UsersProvider? users,
    SessionService? session,
    FeedbackService? feedback,
  }) : _stores = stores ?? Get.find<StoresProvider>(),
       _users = users ?? Get.find<UsersProvider>(),
       _session = session ?? Get.find<SessionService>(),
       _feedback = feedback ?? Get.find<FeedbackService>();

  final Store store;
  final StoresProvider _stores;
  final UsersProvider _users;
  final SessionService _session;
  final FeedbackService _feedback;

  final RxInt photoIndex = 0.obs;
  final Rxn<AppUser> owner = Rxn<AppUser>();
  final RxBool isDeleting = false.obs;

  bool get isOwner => store.ownerUid == _session.uid;

  String get ownerName => owner.value?.displayName ?? '';
  String get ownerPhone =>
      (owner.value?.phoneNumber.isNotEmpty ?? false) ? owner.value!.phoneNumber : store.ownerPhone;
  String get ownerEmail =>
      (owner.value?.email.isNotEmpty ?? false) ? owner.value!.email : store.ownerEmail;

  @override
  void onInit() {
    super.onInit();
    _loadOwner();
  }

  Future<void> _loadOwner() async {
    try {
      owner.value = await _users.getUser(store.ownerUid);
    } on DataException {
      // Contact details fall back to the copy stored on the store row.
    }
  }

  void onPhotoChanged(int index) => photoIndex.value = index;

  void openGallery(int index) {
    Get.toNamed<void>(AppRoutes.storeGallery, arguments: (pictures: store.pictures, index: index));
  }

  Future<void> call() => _launch(Uri(scheme: 'tel', path: ownerPhone));

  Future<void> email() => _launch(Uri(scheme: 'mailto', path: ownerEmail));

  Future<void> _launch(Uri uri) async {
    if (uri.path.isEmpty || !await launchUrl(uri)) {
      _feedback.showError(AppStrings.somethingWentWrong.tr);
    }
  }

  void openOwnerProfile() => Get.toNamed<void>(AppRoutes.userProfile, arguments: store.ownerUid);

  void placeOrder() => Get.toNamed<void>(AppRoutes.order, arguments: store);

  Future<void> deleteStore() async {
    final confirmed = await _feedback.confirm(
      title: AppStrings.deleteStore.tr,
      message: AppStrings.deleteStoreMessage.tr,
      confirmLabel: AppStrings.delete.tr,
      destructive: true,
      icon: Icons.delete_outline_rounded,
    );
    if (!confirmed) return;

    isDeleting.value = true;
    try {
      await _stores.deleteStore(store.id);
      await _users.setStore(store.ownerUid, null);
      final me = _session.user.value;
      if (me != null) _session.updateUser(me.copyWith(isStoreOwner: false, clearStore: true));
      Get.back<bool>(result: true);
      _feedback.showSuccess(AppStrings.storeDeleted.tr);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      isDeleting.value = false;
    }
  }
}
