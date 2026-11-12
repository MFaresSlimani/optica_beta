import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/store.dart';
import '../../../../data/providers/storage_provider.dart';
import '../../../../data/providers/stores_provider.dart';
import '../../../../data/providers/users_provider.dart';
import '../../../services/feedback_service.dart';

class CreateStoreController extends GetxController {
  CreateStoreController({
    StoresProvider? stores,
    UsersProvider? users,
    StorageProvider? storage,
    SessionService? session,
    FeedbackService? feedback,
    ImagePicker? picker,
  }) : _stores = stores ?? Get.find<StoresProvider>(),
       _users = users ?? Get.find<UsersProvider>(),
       _storage = storage ?? Get.find<StorageProvider>(),
       _session = session ?? Get.find<SessionService>(),
       _feedback = feedback ?? Get.find<FeedbackService>(),
       _picker = picker ?? ImagePicker();

  final StoresProvider _stores;
  final UsersProvider _users;
  final StorageProvider _storage;
  final SessionService _session;
  final FeedbackService _feedback;
  final ImagePicker _picker;

  static const int maxPhotos = 8;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxList<String> photoPaths = <String>[].obs;
  final RxBool isCreating = false.obs;

  bool get canAddPhotos => photoPaths.length < maxPhotos && !isCreating.value;

  Future<void> addPhotos() async {
    final files = await _picker.pickMultiImage(maxWidth: 1600, imageQuality: 85);
    final room = maxPhotos - photoPaths.length;
    photoPaths.addAll(files.take(room).map((f) => f.path));
  }

  void removePhoto(int index) => photoPaths.removeAt(index);

  Future<void> create() async {
    final me = _session.user.value;
    if (me == null || isCreating.value || !(formKey.currentState?.validate() ?? false)) return;
    isCreating.value = true;
    try {
      final urls = await Future.wait(
        photoPaths.map((path) => _storage.uploadStoreImage(uid: me.uid, filePath: path)),
      );
      final storeId = await _stores.createStore(
        Store(
          id: '',
          name: nameController.text.trim(),
          location: addressController.text.trim(),
          details: descriptionController.text.trim(),
          ownerUid: me.uid,
          ownerName: me.displayName,
          ownerEmail: me.email,
          ownerPhone: me.phoneNumber,
          ownerPfp: me.pfp,
          pictures: urls,
          admins: [me.uid],
        ),
      );
      await _users.setStore(me.uid, storeId);
      _session.updateUser(me.copyWith(isStoreOwner: true, storeId: storeId));
      Get.back<void>();
      _feedback.showSuccess(AppStrings.storeCreatedSuccessfully.tr);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      isCreating.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
