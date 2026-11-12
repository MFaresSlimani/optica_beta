import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/theme_context.dart';

/// − n + pill. [onDecrement] null disables the minus button.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int value;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Semantics(
      label: AppStrings.quantity.tr,
      value: '$value',
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: palette.surfaceRaised,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: palette.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrement == null
                  ? null
                  : () {
                      HapticFeedback.selectionClick();
                      onDecrement!();
                    },
              icon: const Icon(Icons.remove_rounded),
            ),
            AnimatedSwitcher(
              duration: AppDurations.fast,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: SizedBox(
                key: ValueKey(value),
                width: AppSpacing.xl,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: context.text.titleMedium?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                onIncrement();
              },
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
