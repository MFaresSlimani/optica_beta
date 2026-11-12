import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../controllers/sign_up_controller.dart';
import 'widgets/auth_scaffold.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBack: true,
      title: AppStrings.createAccount.tr,
      subtitle: AppStrings.signUpToGetStarted.tr,
      form: AutofillGroup(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: controller.usernameController,
                label: AppStrings.username.tr,
                icon: Icons.person_outline_rounded,
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.name],
                validator: (value) => Validators.required(value, AppStrings.pleaseEnterUsername),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: controller.emailController,
                label: AppStrings.email.tr,
                icon: Icons.alternate_email_rounded,
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: controller.phoneController,
                label: '${AppStrings.phoneNumber.tr} · ${AppStrings.optional.tr}',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumber],
                validator: Validators.optionalPhone,
              ),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => AppTextField(
                  controller: controller.passwordController,
                  label: AppStrings.password.tr,
                  icon: Icons.lock_outline_rounded,
                  obscureText: controller.obscurePassword.value,
                  onToggleObscure: controller.togglePasswordVisibility,
                  autofillHints: const [AutofillHints.newPassword],
                  validator: Validators.password,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Obx(
                () => AppTextField(
                  controller: controller.confirmPasswordController,
                  label: AppStrings.confirmPassword.tr,
                  icon: Icons.lock_outline_rounded,
                  obscureText: controller.obscurePassword.value,
                  textInputAction: TextInputAction.done,
                  validator: (value) =>
                      Validators.confirmPassword(value, controller.passwordController.text),
                  onSubmitted: (_) => controller.signUp(),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Obx(
                () => AppButton(
                  label: AppStrings.createAccount.tr,
                  icon: Icons.arrow_forward_rounded,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.signUp,
                ),
              ),
            ],
          ),
        ),
      ),
      footer: AuthSwitchPrompt(
        prompt: AppStrings.alreadyHaveAccount.tr,
        action: AppStrings.login.tr,
        onTap: controller.goToLogin,
      ),
    );
  }
}
