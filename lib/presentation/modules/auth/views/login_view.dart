import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/login_controller.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/reset_password_sheet.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: AppStrings.welcomeBack.tr,
      subtitle: AppStrings.signInToContinue.tr,
      form: AutofillGroup(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: controller.emailController,
                label: AppStrings.email.tr,
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => AppTextField(
                  controller: controller.passwordController,
                  label: AppStrings.password.tr,
                  icon: Icons.lock_outline_rounded,
                  obscureText: controller.obscurePassword.value,
                  onToggleObscure: controller.togglePasswordVisibility,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  validator: Validators.password,
                  onSubmitted: (_) => controller.login(),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: () {
                    controller.prepareReset();
                    ResetPasswordSheet.show(controller);
                  },
                  child: Text(AppStrings.forgotPassword.tr),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Obx(
                () => AppButton(
                  label: AppStrings.login.tr,
                  icon: Icons.arrow_forward_rounded,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                ),
              ),
            ],
          ),
        ),
      ),
      footer: AuthSwitchPrompt(
        prompt: AppStrings.dontHaveAccount.tr,
        action: AppStrings.signUp.tr,
        onTap: controller.goToSignUp,
      ),
    );
  }
}
