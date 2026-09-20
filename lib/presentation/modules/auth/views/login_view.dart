import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/forgot_password_dialog.dart';
import 'widgets/language_selector.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Minimalist Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LanguageSelector(controller: authController),
                ],
              ),
            ),

            // Main Content without card/frame container
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: authController.loginFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Brand Header
                          AuthHeader(
                            title: AppStrings.welcomeBack.tr,
                            subtitle: AppStrings.signInToContinue.tr,
                          ),
                          const SizedBox(height: 36),

                          // Email Field
                          AuthTextField(
                            controller: authController.emailController,
                            label: AppStrings.email.tr,
                            hint: AppStrings.email.tr,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return AppStrings.pleaseEnterEmail.tr;
                              }
                              if (!val.contains('@')) {
                                return AppStrings.pleaseEnterValidEmail.tr;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          // Password Field
                          Obx(() {
                            final isHidden = authController.isPasswordHidden.value;
                            return AuthTextField(
                              controller: authController.passwordController,
                              label: AppStrings.password.tr,
                              hint: AppStrings.password.tr,
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: isHidden,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isHidden
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.accentLight,
                                  size: 20,
                                ),
                                onPressed: authController.togglePasswordVisibility,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return AppStrings.pleaseEnterPassword.tr;
                                }
                                if (val.length < 6) {
                                  return AppStrings.passwordTooShort.tr;
                                }
                                return null;
                              },
                            );
                          }),

                          // Forgot Password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => ForgotPasswordDialog.show(
                                context,
                                authController,
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 6,
                                ),
                              ),
                              child: Text(
                                AppStrings.forgotPassword.tr,
                                style: GoogleFonts.abel(
                                  fontSize: 14,
                                  color: AppColors.accentLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Minimalist Primary Action Button
                          Obx(() {
                            final isLoading = authController.isLoading.value;
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : authController.login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        AppStrings.login.tr,
                                        style: GoogleFonts.abel(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                              ),
                            );
                          }),
                          const SizedBox(height: 32),

                          // Clean Minimalist Switch to Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.dontHaveAccount.tr,
                                style: GoogleFonts.abel(
                                  fontSize: 15,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: authController.goToSignUp,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                ),
                                child: Text(
                                  AppStrings.signUp.tr,
                                  style: GoogleFonts.abel(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
