import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../services/session_service.dart';
import 'app_routes.dart';

/// Sends signed-out users to the login screen.
class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return Get.find<SessionService>().isSignedIn
        ? null
        : const RouteSettings(name: AppRoutes.login);
  }
}

/// Keeps signed-in users out of the login and sign-up screens.
class GuestGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    return Get.find<SessionService>().isSignedIn
        ? const RouteSettings(name: AppRoutes.shell)
        : null;
  }
}
