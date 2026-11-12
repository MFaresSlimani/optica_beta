import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_config.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/preferences_service.dart';
import '../../core/theme/theme_context.dart';

/// Bottom sheet listing the app languages, each in its own script.
class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  static Future<void> show() =>
      Get.bottomSheet<void>(const LanguageSheet(), isScrollControlled: true);

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<PreferencesService>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Text(AppStrings.changeLanguage.tr, style: context.text.titleLarge),
            ),
            const SizedBox(height: AppSpacing.sm),
            Obx(() {
              final current = prefs.language.value;
              return RadioGroup<AppLanguage>(
                groupValue: current,
                onChanged: (lang) {
                  if (lang == null) return;
                  Get.back<void>();
                  prefs.setLanguage(lang);
                },
                child: Column(
                  children: [
                    for (final lang in AppLanguage.all)
                      RadioListTile<AppLanguage>(
                        value: lang,
                        controlAffinity: ListTileControlAffinity.trailing,
                        title: Text(lang.nativeName, style: context.text.titleSmall),
                        secondary: CircleAvatar(
                          radius: 18,
                          backgroundColor: context.palette.accentSoft,
                          child: Text(
                            lang.shortLabel,
                            style: context.text.labelMedium?.copyWith(
                              color: context.palette.accent,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// Compact pill showing the current language; opens [LanguageSheet].
class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final prefs = Get.find<PreferencesService>();
    final fg = onDark ? Colors.white : context.palette.textPrimary;
    return Material(
      color: onDark ? Colors.white.withValues(alpha: 0.12) : context.palette.surfaceRaised,
      shape: StadiumBorder(
        side: BorderSide(
          color: onDark ? Colors.white.withValues(alpha: 0.2) : context.palette.border,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: LanguageSheet.show,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.translate_rounded, size: 16, color: fg),
              const SizedBox(width: AppSpacing.sm),
              Obx(
                () => Text(
                  prefs.language.value.shortLabel,
                  style: context.text.labelMedium?.copyWith(color: fg, fontWeight: FontWeight.w700),
                ),
              ),
              Icon(Icons.expand_more_rounded, size: 18, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}
