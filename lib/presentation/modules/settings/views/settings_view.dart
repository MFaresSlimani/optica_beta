import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/language_sheet.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/surface_card.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.gutter,
          AppSpacing.xl,
          AppSpacing.gutter,
          AppSpacing.xxl,
        ),
        children: [
          ConstrainedContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(AppStrings.settings.tr, style: context.text.headlineMedium),
                const SizedBox(height: AppSpacing.xl),
                Obx(() {
                  final user = controller.user.value;
                  if (user == null) return const SizedBox.shrink();
                  return SurfaceCard(
                    child: Row(
                      children: [
                        UserAvatar(name: user.displayName, imageUrl: user.pfp, radius: 26),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppStrings.signedInAs.tr, style: context.text.bodySmall),
                              Text(
                                user.email,
                                style: context.text.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(AppStrings.appearance.tr),
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(AppStrings.theme.tr, style: context.text.titleSmall),
                      const SizedBox(height: AppSpacing.md),
                      Obx(
                        () => SegmentedButton<ThemeMode>(
                          showSelectedIcon: false,
                          segments: [
                            ButtonSegment(
                              value: ThemeMode.system,
                              icon: const Icon(Icons.brightness_auto_outlined, size: 18),
                              label: Text(AppStrings.themeSystem.tr),
                            ),
                            ButtonSegment(
                              value: ThemeMode.light,
                              icon: const Icon(Icons.light_mode_outlined, size: 18),
                              label: Text(AppStrings.themeLight.tr),
                            ),
                            ButtonSegment(
                              value: ThemeMode.dark,
                              icon: const Icon(Icons.dark_mode_outlined, size: 18),
                              label: Text(AppStrings.themeDark.tr),
                            ),
                          ],
                          selected: {controller.themeMode.value},
                          onSelectionChanged: (selection) {
                            HapticFeedback.selectionClick();
                            controller.setThemeMode(selection.first);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GroupedCard(
                  children: [
                    Obx(
                      () => NavRow(
                        icon: Icons.translate_rounded,
                        title: AppStrings.language.tr,
                        value: controller.language.value.nativeName,
                        onTap: LanguageSheet.show,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(AppStrings.support.tr),
                GroupedCard(
                  children: [
                    NavRow(
                      icon: Icons.info_outline_rounded,
                      title: AppStrings.info.tr,
                      onTap: controller.openAbout,
                    ),
                    NavRow(
                      icon: Icons.verified_outlined,
                      title: AppStrings.version.tr,
                      value: controller.version,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
                Obx(
                  () => AppButton(
                    label: AppStrings.logout.tr,
                    icon: Icons.logout_rounded,
                    variant: AppButtonVariant.destructive,
                    isLoading: controller.isSigningOut.value,
                    onPressed: controller.logout,
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
