import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import '../controllers/sign_up_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(LoginController.new);
}

class SignUpBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut(SignUpController.new);
}
