import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../../data/providers/users_provider.dart';
import '../../../services/feedback_service.dart';

class SignUpController extends GetxController {
  SignUpController({
    AuthProvider? auth,
    UsersProvider? users,
    SessionService? session,
    FeedbackService? feedback,
  }) : _auth = auth ?? Get.find<AuthProvider>(),
       _users = users ?? Get.find<UsersProvider>(),
       _session = session ?? Get.find<SessionService>(),
       _feedback = feedback ?? Get.find<FeedbackService>();

  final AuthProvider _auth;
  final UsersProvider _users;
  final SessionService _session;
  final FeedbackService _feedback;

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> signUp() async {
    if (isLoading.value || !(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final username = usernameController.text.trim();
      final uid = await _auth.signUp(
        email: email,
        password: passwordController.text,
        username: username,
      );
      await _users.upsertUser(
        AppUser(
          uid: uid,
          email: email,
          username: username,
          phoneNumber: phoneController.text.trim(),
        ),
      );
      await _session.refreshUser();
      await Get.offAllNamed<void>(AppRoutes.shell);
    } on DataException catch (e) {
      _feedback.showError(e.message.isEmpty ? AppStrings.failedToSignUp.tr : e.message);
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() => Get.back<void>();

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
