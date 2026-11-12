import 'package:flutter/material.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/theme_context.dart';

/// Centers content and caps its width on tablets and desktop.
class ConstrainedContent extends StatelessWidget {
  const ConstrainedContent({
    super.key,
    required this.child,
    this.maxWidth = AppSpacing.maxContentWidth,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    // heightFactor: 1 shrink-wraps vertically. Without it an Align under loose
    // constraints (e.g. Scaffold.bottomNavigationBar) grows to full height.
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// Sticky bottom bar for the screen's primary action, in thumb reach.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child, this.leading});

  final Widget child;

  /// Optional summary shown above the action (e.g. order totals).
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surfaceRaised,
        border: Border(top: BorderSide(color: palette.border)),
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (leading != null) ...[leading!, const SizedBox(height: AppSpacing.md)],
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon + label + value row used in info cards.
class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: palette.accentSoft, borderRadius: AppRadius.mdAll),
            child: Icon(icon, size: 20, color: palette.accent),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.text.bodySmall),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  value,
                  style: context.text.titleSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Settings-style navigation row.
class NavRow extends StatelessWidget {
  const NavRow({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.value,
    this.destructive = false,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String? value;
  final bool destructive;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final color = destructive ? palette.danger : palette.textPrimary;
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: destructive ? palette.danger : palette.accent),
      title: Text(title, style: context.text.titleSmall?.copyWith(color: color)),
      trailing:
          trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                Text(value!, style: context.text.bodyMedium?.copyWith(color: palette.textMuted)),
              if (onTap != null && !destructive) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(Icons.chevron_right_rounded, color: palette.textMuted),
              ],
            ],
          ),
    );
  }
}
