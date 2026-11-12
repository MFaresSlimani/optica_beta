import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/session_service.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/providers/auth_provider.dart';
import '../../../services/feedback_service.dart';

class LoginController extends GetxController {
  LoginController({AuthProvider? auth, SessionService? session, FeedbackService? feedback})
    : _auth = auth ?? Get.find<AuthProvider>(),
      _session = session ?? Get.find<SessionService>(),
      _feedback = feedback ?? Get.find<FeedbackService>();

  final AuthProvider _auth;
  final SessionService _session;
  final FeedbackService _feedback;

  final formKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final resetEmailController = TextEditingController();

  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSendingReset = false.obs;

  void togglePasswordVisibility() => obscurePassword.toggle();

  Future<void> login() async {
    if (isLoading.value || !(formKey.currentState?.validate() ?? false)) return;
    isLoading.value = true;
    try {
      await _auth.signIn(email: emailController.text.trim(), password: passwordController.text);
      await _session.refreshUser();
      await Get.offAllNamed<void>(AppRoutes.shell);
    } on DataException {
      _feedback.showError(AppStrings.failedToSignIn.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// Opens the reset sheet pre-filled with whatever is in the email field.
  void prepareReset() => resetEmailController.text = emailController.text.trim();

  Future<void> sendPasswordReset() async {
    if (isSendingReset.value || !(resetFormKey.currentState?.validate() ?? false)) return;
    isSendingReset.value = true;
    try {
      await _auth.sendPasswordReset(resetEmailController.text.trim());
      Get.back<void>();
      _feedback.showSuccess(AppStrings.resetEmailSent.tr);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      isSendingReset.value = false;
    }
  }

  void goToSignUp() => Get.toNamed<void>(AppRoutes.signUp);

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    resetEmailController.dispose();
    super.onClose();
  }
}
