import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/providers/storage_provider.dart';
import '../../../../data/providers/users_provider.dart';
import '../../../services/feedback_service.dart';

class EditProfileController extends GetxController {
  EditProfileController({
    UsersProvider? users,
    StorageProvider? storage,
    SessionService? session,
    FeedbackService? feedback,
    ImagePicker? picker,
  }) : _users = users ?? Get.find<UsersProvider>(),
       _storage = storage ?? Get.find<StorageProvider>(),
       _session = session ?? Get.find<SessionService>(),
       _feedback = feedback ?? Get.find<FeedbackService>(),
       _picker = picker ?? ImagePicker();

  final UsersProvider _users;
  final StorageProvider _storage;
  final SessionService _session;
  final FeedbackService _feedback;
  final ImagePicker _picker;

  final formKey = GlobalKey<FormState>();
  late final AppUser original = _session.user.value ?? AppUser(uid: _session.uid ?? '');
  late final nameController = TextEditingController(text: original.username);
  late final phoneController = TextEditingController(text: original.phoneNumber);

  final RxnString pickedImagePath = RxnString();
  final RxBool isSaving = false.obs;

  /// Bumped on every keystroke so `hasChanges` re-evaluates in `Obx`.
  final RxInt _edits = 0.obs;

  bool get hasChanges {
    _edits.value;
    return nameController.text.trim() != original.username ||
        phoneController.text.trim() != original.phoneNumber ||
        pickedImagePath.value != null;
  }

  void onEdited(String _) => _edits.value++;

  Future<void> pickImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source, maxWidth: 1024, imageQuality: 85);
    if (file != null) pickedImagePath.value = file.path;
  }

  Future<void> save() async {
    if (isSaving.value || !(formKey.currentState?.validate() ?? false)) return;
    isSaving.value = true;
    try {
      var pfp = original.pfp;
      final path = pickedImagePath.value;
      if (path != null) pfp = await _storage.uploadProfileImage(uid: original.uid, filePath: path);
      final updated = original.copyWith(
        username: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        pfp: pfp,
      );
      await _users.updateProfile(
        original.uid,
        username: updated.username,
        phoneNumber: updated.phoneNumber,
        pfp: updated.pfp,
      );
      _session.updateUser(updated);
      Get.back<void>();
      _feedback.showSuccess(AppStrings.updateProfileSuccess.tr);
    } on DataException {
      _feedback.showError(AppStrings.updateProfileError.tr);
    } finally {
      isSaving.value = false;
    }
  }

  /// Asks before throwing away edits. Returns true when it is safe to leave.
  Future<bool> confirmLeave() async {
    if (!hasChanges) return true;
    return _feedback.confirm(
      title: AppStrings.discardChanges.tr,
      message: AppStrings.discardChangesMessage.tr,
      confirmLabel: AppStrings.confirm.tr,
      destructive: true,
      icon: Icons.edit_off_outlined,
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
