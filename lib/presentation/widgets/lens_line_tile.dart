import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_context.dart';
import '../../data/models/lens_item.dart';

/// One order line: lens type, SPH / CYL pills and quantity.
class LensLineTile extends StatelessWidget {
  const LensLineTile({
    super.key,
    required this.item,
    this.leading,
    this.trailing,
    this.muted = false,
  });

  final LensItem item;
  final Widget? leading;
  final Widget? trailing;

  /// Dims the line (used for "not supplied").
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedOpacity(
      duration: AppDurations.fast,
      opacity: muted ? 0.55 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        child: Row(
          children: [
            leading ?? QuantityBadge(quantity: item.quantity),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.type,
                    style: context.text.titleSmall?.copyWith(
                      decoration: muted ? TextDecoration.lineThrough : null,
                      decorationColor: palette.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.isParsed) ...[
                    const SizedBox(height: AppSpacing.xs + AppSpacing.xxs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _PowerPill(label: AppStrings.sph.tr, value: item.sphere.format()),
                        _PowerPill(label: AppStrings.cyl.tr, value: item.cylinder.format()),
                        if (leading != null) _PowerPill(label: '×', value: '${item.quantity}'),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: AppSpacing.sm), trailing!],
          ],
        ),
      ),
    );
  }
}

class QuantityBadge extends StatelessWidget {
  const QuantityBadge({super.key, required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: palette.accentSoft, borderRadius: AppRadius.mdAll),
      child: Text(
        '×$quantity',
        style: context.text.labelLarge?.copyWith(
          color: palette.accent,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _PowerPill extends StatelessWidget {
  const _PowerPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
      decoration: BoxDecoration(color: palette.surfaceSunken, borderRadius: AppRadius.smAll),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$label ', style: context.text.bodySmall),
            TextSpan(
              text: value,
              style: context.text.labelMedium?.copyWith(
                color: palette.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
