import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/auth_controller.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/language_selector.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    onPressed: authController.goToLogin,
                  ),
                  LanguageSelector(controller: authController),
                ],
              ),
            ),

            // Main Content: Effortless Sign Up Form
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: authController.signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Brand Header
                          AuthHeader(
                            title: AppStrings.createAccount.tr,
                            subtitle: AppStrings.signUpToGetStarted.tr,
                          ),
                          const SizedBox(height: 32),

                          // Username / Name Field
                          AuthTextField(
                            controller: authController.usernameController,
                            label: AppStrings.username.tr,
                            hint: AppStrings.username.tr,
                            prefixIcon: Icons.person_outline_rounded,
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(height: 18),

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

                          // Phone Number Field (Stored in DB only)
                          AuthTextField(
                            controller: authController.phoneController,
                            label: AppStrings.phoneNumber.tr,
                            hint: AppStrings.phoneNumber.tr,
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
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
                              textInputAction: TextInputAction.next,
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
                          const SizedBox(height: 18),

                          // Confirm Password Field
                          Obx(() {
                            final isHidden = authController.isConfirmPasswordHidden.value;
                            return AuthTextField(
                              controller: authController.confirmPasswordController,
                              label: AppStrings.confirmPassword.tr,
                              hint: AppStrings.confirmPassword.tr,
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
                                onPressed: authController.toggleConfirmPasswordVisibility,
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return AppStrings.pleaseEnterPassword.tr;
                                }
                                if (val != authController.passwordController.text) {
                                  return AppStrings.passwordsDontMatch.tr;
                                }
                                return null;
                              },
                            );
                          }),
                          const SizedBox(height: 28),

                          // Minimalist Sign Up Action Button
                          Obx(() {
                            final isLoading = authController.isLoading.value;
                            return SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : authController.signUp,
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
                                        AppStrings.signUp.tr,
                                        style: GoogleFonts.abel(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                              ),
                            );
                          }),
                          const SizedBox(height: 28),

                          // Switch to Sign In
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.alreadyHaveAccount.tr,
                                style: GoogleFonts.abel(
                                  fontSize: 15,
                                  color: AppColors.textMuted,
                                ),
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: authController.goToLogin,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                ),
                                child: Text(
                                  AppStrings.login.tr,
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
