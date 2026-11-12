import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/brand_visuals.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/surface_card.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.info.tr)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.sm,
          AppSpacing.gutter,
          AppSpacing.xxl,
        ),
        children: [
          ConstrainedContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: context.palette.heroGradient,
                    borderRadius: AppRadius.xlAll,
                  ),
                  child: CustomPaint(
                    painter: LensRingsPainter(color: AppColors.copper500.withValues(alpha: 0.12)),
                    child: Column(
                      children: [
                        const BrandMark(size: 80),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          AppStrings.aboutCompanyDescription.tr,
                          style: context.text.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                _ValueCard(
                  icon: Icons.handshake_outlined,
                  title: AppStrings.ourValues.tr,
                  body: AppStrings.ourValuesDescription.tr,
                ),
                const SizedBox(height: AppSpacing.md),
                _ValueCard(
                  icon: Icons.workspace_premium_outlined,
                  title: AppStrings.ourStrength.tr,
                  body:
                      '${AppStrings.ourStrengthDescription.tr}\n\n${AppStrings.ourStrengthItems.tr}',
                ),
                const SizedBox(height: AppSpacing.md),
                _ValueCard(
                  icon: Icons.visibility_outlined,
                  title: AppStrings.ourVision.tr,
                  body: AppStrings.ourVisionDescription.tr,
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(AppStrings.contactUs.tr),
                GroupedCard(
                  children: [
                    _LinkRow(
                      icon: Icons.language_rounded,
                      title: AppStrings.onlineStore.tr,
                      subtitle: AppLinks.websiteLabel,
                      onTap: controller.openWebsite,
                    ),
                    _LinkRow(
                      icon: Icons.mail_outline_rounded,
                      title: AppStrings.email.tr,
                      subtitle: AppLinks.email,
                      onTap: controller.sendEmail,
                    ),
                    _LinkRow(
                      icon: Icons.facebook_rounded,
                      title: AppLinks.facebookLabel,
                      subtitle: AppLinks.facebookHandle,
                      onTap: controller.openFacebook,
                    ),
                    _LinkRow(
                      icon: Icons.photo_camera_outlined,
                      title: AppLinks.instagramLabel,
                      subtitle: AppLinks.instagramHandle,
                      onTap: controller.openInstagram,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(AppStrings.help.tr),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(AppStrings.needAssistance.tr, style: context.text.titleMedium),
                      const SizedBox(height: AppSpacing.sm),
                      Text(AppStrings.helpDescription.tr, style: context.text.bodyMedium),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: AppStrings.contactOnFacebook.tr,
                        icon: Icons.chat_bubble_outline_rounded,
                        variant: AppButtonVariant.accent,
                        onPressed: controller.openFacebook,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: context.palette.accentSoft,
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(icon, color: context.palette.accent, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.text.titleSmall),
                const SizedBox(height: AppSpacing.xs),
                Text(body, style: context.text.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Icon(Icons.north_east_rounded, size: 18, color: context.palette.textMuted),
    );
  }
}
