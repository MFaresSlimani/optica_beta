import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../controllers/auth_controller.dart';
import 'auth_text_field.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final AuthController controller;

  const ForgotPasswordDialog({
    super.key,
    required this.controller,
  });

  static void show(BuildContext context, AuthController controller) {
    Get.dialog(
      ForgotPasswordDialog(controller: controller),
      barrierDismissible: true,
      barrierColor: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.surfaceCardBorder, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.resetFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lock_reset_rounded,
                    color: AppColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppStrings.resetPassword.tr,
                      style: GoogleFonts.abel(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 20),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                AppStrings.resetPasswordInstruction.tr,
                style: GoogleFonts.abel(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              AuthTextField(
                controller: controller.resetEmailController,
                label: AppStrings.email.tr,
                hint: AppStrings.email.tr,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return AppStrings.pleaseEnterEmail.tr;
                  }
                  if (!val.contains('@') || !val.contains('.')) {
                    return AppStrings.pleaseEnterValidEmail.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(() {
                final isLoading = controller.isResetLoading.value;
                return SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => controller.sendPasswordReset(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            AppStrings.sendResetLink.tr,
                            style: GoogleFonts.abel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
