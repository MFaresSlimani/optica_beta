import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../requests/controllers/requests_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/shell_controller.dart';

class ShellBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(ShellController.new)
      ..lazyPut(HomeController.new)
      ..lazyPut(RequestsController.new)
      ..lazyPut(ProfileController.new)
      ..lazyPut(SettingsController.new);
  }
}
