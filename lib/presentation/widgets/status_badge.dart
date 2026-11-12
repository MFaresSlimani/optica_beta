import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_context.dart';

/// Pending / Completed pill.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.isDone});

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = isDone ? palette.success : palette.warning;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xxs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isDone ? palette.successSoft : palette.warningSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isDone ? Icons.check_rounded : Icons.schedule_rounded, size: 14, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            (isDone ? AppStrings.done : AppStrings.pending).tr,
            style: context.text.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

/// Small neutral tag ("Your store", "Store owner").
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label, this.icon, this.onDark = false});

  final String label;
  final IconData? icon;

  /// Light-on-dark styling for use over hero headers and photos.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final fg = onDark ? Colors.white : palette.accent;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + AppSpacing.xxs,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withValues(alpha: 0.16) : palette.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: onDark ? Border.all(color: Colors.white.withValues(alpha: 0.24)) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: context.text.labelMedium?.copyWith(color: fg, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
