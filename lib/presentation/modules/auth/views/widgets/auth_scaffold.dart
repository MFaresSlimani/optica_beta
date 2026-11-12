import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../widgets/brand_visuals.dart';
import '../../../../widgets/language_sheet.dart';
import '../../../../widgets/layout.dart';

/// Shared layout for login and sign-up: a deep-teal brand header with lens
/// rings, and the form on a rounded sheet that overlaps it.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    required this.footer,
    this.showBack = false,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget footer;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colors.surface,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              _Header(topInset: topInset, showBack: showBack),
              Transform.translate(
                offset: const Offset(0, -AppSpacing.xl),
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                  ),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    AppSpacing.xxl,
                    AppSpacing.xl,
                    AppSpacing.lg,
                  ),
                  child: ConstrainedContent(
                    maxWidth: 440,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(title, style: context.text.headlineMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(subtitle, style: context.text.bodyLarge),
                        const SizedBox(height: AppSpacing.xl),
                        form,
                        const SizedBox(height: AppSpacing.xl),
                        footer,
                        SizedBox(height: MediaQuery.paddingOf(context).bottom),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.topInset, required this.showBack});

  final double topInset;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.tealGradient),
      child: CustomPaint(
        painter: LensRingsPainter(
          color: AppColors.copper500.withValues(alpha: 0.14),
          center: const Alignment(1.1, -0.2),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.sm,
            topInset + AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xxxl + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (showBack)
                    IconButton(
                      onPressed: Get.back<void>,
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    ),
                  const Spacer(),
                  const LanguagePill(onDark: true),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSpacing.md),
                child: Row(
                  children: [
                    const BrandMark(size: 64),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShaderMask(
                            shaderCallback: AppColors.copperGradient.createShader,
                            child: Text(
                              AppStrings.appName.tr,
                              style: context.text.titleLarge?.copyWith(
                                color: Colors.white,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppStrings.appTagline.tr,
                            style: context.text.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.72),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Don't have an account? Sign up" row.
class AuthSwitchPrompt extends StatelessWidget {
  const AuthSwitchPrompt({
    super.key,
    required this.prompt,
    required this.action,
    required this.onTap,
  });

  final String prompt;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(prompt, style: context.text.bodyMedium),
        TextButton(onPressed: onTap, child: Text(action)),
      ],
    );
  }
}
