import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/theme_context.dart';
import 'app_button.dart';

/// Friendly empty state: tinted icon, title, guidance and optional action.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Compact variant for use inside a card rather than a whole screen.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final iconSize = compact ? 48.0 : 72.0;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: compact ? AppSpacing.xl : AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(color: palette.accentSoft, shape: BoxShape.circle),
              child: Icon(icon, size: iconSize * 0.45, color: palette.accent),
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            Text(
              title,
              style: compact ? context.text.titleSmall : context.text.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Text(message, style: context.text.bodyMedium, textAlign: TextAlign.center),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: AppButtonVariant.outlined,
                expand: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state with a retry button.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.onRetry, this.message});

  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.cloud_off_rounded,
      title: AppStrings.somethingWentWrong.tr,
      message: message ?? AppStrings.checkConnection.tr,
      actionLabel: AppStrings.retry.tr,
      onAction: onRetry,
    );
  }
}

/// Pulsing placeholder block for loading states.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, this.height = 16, this.width, this.radius = AppRadius.sm});

  final double height;
  final double? width;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.palette.surfaceSunken;
    return FadeTransition(
      opacity: Tween<double>(
        begin: 0.55,
        end: 1,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(widget.radius)),
      ),
    );
  }
}
