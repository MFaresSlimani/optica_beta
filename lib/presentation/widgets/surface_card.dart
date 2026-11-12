import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/theme_context.dart';

/// A raised surface with a hairline tinted border and a whisper of shadow.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = AppSpacing.card,
    this.onTap,
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? palette.surfaceRaised,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: borderColor ?? palette.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.18 : 0.035),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: AppRadius.lgAll,
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap!();
                },
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// A card made of rows separated by inset dividers (settings-style group).
class GroupedCard extends StatelessWidget {
  const GroupedCard({super.key, required this.children, this.dividerIndent = 56});

  final List<Widget> children;
  final double dividerIndent;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(indent: dividerIndent, endIndent: AppSpacing.lg),
            children[i],
          ],
        ],
      ),
    );
  }
}
