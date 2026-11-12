import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/theme_context.dart';

enum AppButtonVariant { primary, accent, outlined, destructive }

/// The app's one button. Handles loading, haptics and a subtle press scale.
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool expand;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final colors = context.colors;
    final enabled = widget.onPressed != null && !widget.isLoading;

    final onPressed = enabled
        ? () {
            HapticFeedback.lightImpact();
            widget.onPressed!();
          }
        : null;

    final foreground = switch (widget.variant) {
      AppButtonVariant.primary => colors.onPrimary,
      AppButtonVariant.accent => palette.onAccent,
      AppButtonVariant.outlined => palette.textPrimary,
      AppButtonVariant.destructive => palette.danger,
    };

    final child = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: widget.isLoading
          ? SizedBox.square(
              key: const ValueKey('loading'),
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2, color: foreground),
            )
          : Row(
              key: const ValueKey('label'),
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Flexible(child: Text(widget.label, maxLines: 1, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );

    final button = switch (widget.variant) {
      AppButtonVariant.primary => FilledButton(onPressed: onPressed, child: child),
      AppButtonVariant.accent => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: palette.accent,
          foregroundColor: palette.onAccent,
        ),
        child: child,
      ),
      AppButtonVariant.outlined => OutlinedButton(onPressed: onPressed, child: child),
      AppButtonVariant.destructive => OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.danger,
          side: BorderSide(color: palette.danger.withValues(alpha: 0.4)),
        ),
        child: child,
      ),
    };

    return Listener(
      onPointerDown: enabled ? (_) => _setPressed(true) : null,
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        child: widget.expand ? SizedBox(width: double.infinity, child: button) : button,
      ),
    );
  }
}
