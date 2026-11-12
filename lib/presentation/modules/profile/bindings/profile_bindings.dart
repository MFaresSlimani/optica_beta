import 'package:get/get.dart';

import '../controllers/create_store_controller.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';

/// Another user's profile. Tagged by user id so it never collides with the
/// signed-in user's profile tab.
class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    final uid = Get.arguments as String;
    Get.lazyPut(() => ProfileController(userId: uid), tag: uid);
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(EditProfileController.new);
}

class CreateStoreBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(CreateStoreController.new);
}
