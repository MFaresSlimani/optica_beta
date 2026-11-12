import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../data/models/diopter.dart';

/// A labelled wheel for picking a lens power in 0.25 D steps.
class DiopterWheel extends StatelessWidget {
  const DiopterWheel({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.scrollController,
    required this.onChanged,
  });

  final String label;
  final List<Diopter> values;
  final Diopter selected;
  final FixedExtentScrollController scrollController;
  final ValueChanged<int> onChanged;

  static const double _itemExtent = 40;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final valueStyle = context.text.titleMedium?.copyWith(
      fontFeatures: const [FontFeature.tabularFigures()],
    );

    return Semantics(
      label: label,
      value: selected.format(),
      child: Container(
        decoration: BoxDecoration(
          color: palette.surfaceRaised,
          borderRadius: AppRadius.lgAll,
          border: Border.all(color: palette.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
              child: Text(
                label.toUpperCase(),
                style: context.text.labelSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: _itemExtent * 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Selection band.
                  Container(
                    height: _itemExtent,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: palette.accentSoft,
                      borderRadius: AppRadius.mdAll,
                    ),
                  ),
                  ListWheelScrollView.useDelegate(
                    controller: scrollController,
                    itemExtent: _itemExtent,
                    diameterRatio: 1.6,
                    perspective: 0.004,
                    physics: const FixedExtentScrollPhysics(),
                    overAndUnderCenterOpacity: 0.4,
                    onSelectedItemChanged: (index) {
                      HapticFeedback.selectionClick();
                      onChanged(index);
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: values.length,
                      builder: (_, index) {
                        final value = values[index];
                        final isSelected = value == selected;
                        return Center(
                          child: Text(
                            value.format(),
                            style: valueStyle?.copyWith(
                              color: isSelected ? palette.accent : palette.textPrimary,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}
