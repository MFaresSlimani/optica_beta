import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../data/models/diopter.dart';
import '../../controllers/diopter_input.dart';

/// Lens power picker: a ± toggle, a wheel for whole diopters and a wheel for
/// the quarter decimals. Two short flicks reach any value from -10.75 to
/// +10.75, instead of scrolling one long list.
class DiopterPicker extends StatelessWidget {
  const DiopterPicker({super.key, required this.label, required this.input});

  final String label;
  final DiopterInput input;

  static const double _itemExtent = 36;
  static const double _wheelHeight = _itemExtent * 3;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Obx(
      () => Semantics(
        label: label,
        value: input.value.value.format(),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: palette.surfaceRaised,
            borderRadius: AppRadius.lgAll,
            border: Border.all(color: palette.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xs,
                  AppSpacing.xs,
                  AppSpacing.xs,
                  AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label.toUpperCase(),
                        style: context.text.labelSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      input.value.value.format(),
                      style: context.text.titleSmall?.copyWith(
                        color: palette.accent,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: _wheelHeight,
                // The decimal point and wheels read left-to-right in every
                // language, like the numbers on a prescription.
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SignButton(negative: input.negative.value, onTap: input.toggleSign),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: _itemExtent,
                              decoration: BoxDecoration(
                                color: palette.accentSoft,
                                borderRadius: AppRadius.smAll,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: _Wheel(
                                    controller: input.wholeWheel,
                                    count: DiopterInput.wholeCount,
                                    label: (i) => '$i',
                                    onChanged: input.onWholeChanged,
                                    itemExtent: _itemExtent,
                                  ),
                                ),
                                Text(
                                  '.',
                                  style: context.text.titleLarge?.copyWith(color: palette.accent),
                                ),
                                Expanded(
                                  child: _Wheel(
                                    controller: input.quarterWheel,
                                    count: DiopterInput.quarterCount,
                                    label: (i) => Diopter.quarterLabels[i],
                                    onChanged: input.onQuarterChanged,
                                    itemExtent: _itemExtent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _SignButton extends StatelessWidget {
  const _SignButton({required this.negative, required this.onTap});

  final bool negative;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.accent,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        borderRadius: AppRadius.mdAll,
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: SizedBox(
          width: AppSpacing.minTapTarget - AppSpacing.xs,
          child: Center(
            child: AnimatedSwitcher(
              duration: AppDurations.fast,
              transitionBuilder: (child, animation) =>
                  ScaleTransition(scale: animation, child: child),
              child: Text(
                // U+2212 minus sign: same width as +, unlike a hyphen.
                negative ? '−' : '+',
                key: ValueKey(negative),
                style: context.text.headlineSmall?.copyWith(
                  color: palette.onAccent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.controller,
    required this.count,
    required this.label,
    required this.onChanged,
    required this.itemExtent,
  });

  final FixedExtentScrollController controller;
  final int count;
  final String Function(int index) label;
  final ValueChanged<int> onChanged;
  final double itemExtent;

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: itemExtent,
      diameterRatio: 1.4,
      perspective: 0.004,
      overAndUnderCenterOpacity: 0.35,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        HapticFeedback.selectionClick();
        onChanged(index);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: count,
        builder: (context, index) => Center(
          child: Text(
            label(index),
            style: context.text.titleMedium?.copyWith(
              color: context.palette.textPrimary,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ),
    );
  }
}
