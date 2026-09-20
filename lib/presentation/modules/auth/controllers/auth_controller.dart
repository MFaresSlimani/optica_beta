import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../authentication.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../screens/home_screen/home_screen.dart';

class AuthController extends GetxController {
  final AuthenticationService _authService = Get.find<AuthenticationService>();

  // Text Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController resetEmailController = TextEditingController();

  // Form Keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();

  // Observables
  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isResetLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void clearErrorMessage() {
    errorMessage.value = '';
  }

  // Language switcher
  void changeLocale(String languageCode, String countryCode) {
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }

  // Navigation
  void goToSignUp() {
    clearErrorMessage();
    Get.toNamed(AppRoutes.signUp);
  }

  void goToLogin() {
    clearErrorMessage();
    if (Get.previousRoute.isNotEmpty) {
      Get.back();
    } else {
      Get.offNamed(AppRoutes.login);
    }
  }

  // Login Action
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    clearErrorMessage();

    try {
      final user = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        errorMessage.value = AppStrings.failedToSignIn.tr;
        _showNotificationSnackbar(
          title: AppStrings.error.tr,
          message: AppStrings.failedToSignIn.tr,
          isError: true,
        );
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      _showNotificationSnackbar(
        title: AppStrings.error.tr,
        message: e.message,
        isError: true,
      );
    } catch (e) {
      errorMessage.value = AppStrings.failedToSignIn.tr;
      _showNotificationSnackbar(
        title: AppStrings.error.tr,
        message: AppStrings.failedToSignIn.tr,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign Up Action
  Future<void> signUp() async {
    if (!signUpFormKey.currentState!.validate()) return;

    if (confirmPasswordController.text.isNotEmpty &&
        passwordController.text != confirmPasswordController.text) {
      errorMessage.value = AppStrings.passwordsDontMatch.tr;
      _showNotificationSnackbar(
        title: AppStrings.error.tr,
        message: AppStrings.passwordsDontMatch.tr,
        isError: true,
      );
      return;
    }

    isLoading.value = true;
    clearErrorMessage();

    try {
      final user = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text,
        username: usernameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );

      if (user != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        errorMessage.value = AppStrings.failedToSignUp.tr;
        _showNotificationSnackbar(
          title: AppStrings.error.tr,
          message: AppStrings.failedToSignUp.tr,
          isError: true,
        );
      }
    } on AuthException catch (e) {
      errorMessage.value = e.message;
      _showNotificationSnackbar(
        title: AppStrings.error.tr,
        message: e.message,
        isError: true,
      );
    } catch (e) {
      errorMessage.value = AppStrings.failedToSignUp.tr;
      _showNotificationSnackbar(
        title: AppStrings.error.tr,
        message: AppStrings.failedToSignUp.tr,
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Password Reset Action
  Future<void> sendPasswordReset() async {
    if (!resetFormKey.currentState!.validate()) return;

    isResetLoading.value = true;

    try {
      final success = await _authService.resetPassword(
        resetEmailController.text.trim(),
      );

      if (Get.isDialogOpen == true) {
        Get.back();
      }

      if (success) {
        _showNotificationSnackbar(
          title: AppStrings.success.tr,
          message: AppStrings.resetEmailSent.tr,
          isError: false,
        );
        resetEmailController.clear();
      } else {
        _showNotificationSnackbar(
          title: AppStrings.error.tr,
          message: AppStrings.error.tr,
          isError: true,
        );
      }
    } finally {
      isResetLoading.value = false;
    }
  }

  void _showNotificationSnackbar({
    required String title,
    required String message,
    required bool isError,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.surfaceDark.withValues(alpha: 0.95),
      colorText: AppColors.textLight,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      isDismissible: true,
      borderColor: isError ? AppColors.error.withValues(alpha: 0.6) : AppColors.accent.withValues(alpha: 0.6),
      borderWidth: 1.2,
      titleText: Text(
        title,
        style: GoogleFonts.abel(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: isError ? AppColors.error : AppColors.accent,
        ),
      ),
      messageText: Text(
        message,
        style: GoogleFonts.abel(
          fontSize: 15,
          color: AppColors.textLight,
        ),
      ),
      icon: Icon(
        isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
        color: isError ? AppColors.error : AppColors.accent,
      ),
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    resetEmailController.dispose();
    super.onClose();
  }
}
