import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/theme_context.dart';
import 'app_button.dart';

/// Confirmation dialog. Pops `true` on confirm, `false` on cancel.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.destructive = false,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final tint = destructive ? palette.danger : palette.accent;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xl),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: destructive ? palette.dangerSoft : palette.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: tint, size: 28),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
              Text(title, style: context.text.titleLarge, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(message, style: context.text.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: cancelLabel,
                      variant: AppButtonVariant.outlined,
                      onPressed: () => Get.back(result: false),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: destructive
                        ? FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: palette.danger,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => Get.back(result: true),
                            child: Text(confirmLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
                          )
                        : AppButton(label: confirmLabel, onPressed: () => Get.back(result: true)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
