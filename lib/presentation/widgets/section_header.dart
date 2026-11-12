import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/theme_context.dart';

/// Upper-case eyebrow label above a group, with an optional trailing widget.
class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.trailing, this.padding});

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          const EdgeInsetsDirectional.only(
            start: AppSpacing.xs,
            end: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: context.text.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
