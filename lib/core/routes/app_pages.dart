import 'package:get/get.dart';

import '../../presentation/modules/auth/bindings/auth_binding.dart';
import '../../presentation/modules/auth/views/login_view.dart';
import '../../presentation/modules/auth/views/sign_up_view.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../wrapper.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const AuthWrapper(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpView(),
      binding: AuthBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      transition: Transition.cupertino,
    ),
  ];
}
