import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text_field.dart';
import '../../controllers/login_controller.dart';

/// Password reset as a bottom sheet (keyboard-aware, thumb-reachable).
class ResetPasswordSheet extends StatelessWidget {
  const ResetPasswordSheet({super.key, required this.controller});

  final LoginController controller;

  static Future<void> show(LoginController controller) {
    return Get.bottomSheet<void>(
      ResetPasswordSheet(controller: controller),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
          child: Form(
            key: controller.resetFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppStrings.resetPassword.tr, style: context.text.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(AppStrings.resetPasswordInstruction.tr, style: context.text.bodyMedium),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  controller: controller.resetEmailController,
                  label: AppStrings.email.tr,
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.send,
                  validator: Validators.email,
                  onSubmitted: (_) => controller.sendPasswordReset(),
                ),
                const SizedBox(height: AppSpacing.xl),
                Obx(
                  () => AppButton(
                    label: AppStrings.sendResetLink.tr,
                    icon: Icons.send_rounded,
                    isLoading: controller.isSendingReset.value,
                    onPressed: controller.sendPasswordReset,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
