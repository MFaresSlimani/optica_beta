import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/optica_palette.dart';
import '../widgets/confirm_dialog.dart';

/// Snackbars and confirmation dialogs, behind one injectable service.
///
/// Controllers call this instead of building widgets, which keeps them
/// UI-free and lets tests swap in a recording fake.
class FeedbackService extends GetxService {
  void showSuccess(String message) => _show(message: message, kind: _Kind.success);

  void showError(String message) => _show(message: message, kind: _Kind.error);

  void showInfo({required String title, required String message, VoidCallback? onTap}) {
    _show(title: title, message: message, kind: _Kind.info, onTap: onTap);
  }

  Future<bool> confirm({
    required String title,
    required String message,
    required String confirmLabel,
    bool destructive = false,
    IconData? icon,
  }) async {
    final result = await Get.dialog<bool>(
      ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: AppStrings.cancel.tr,
        destructive: destructive,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  void _show({required String message, required _Kind kind, String? title, VoidCallback? onTap}) {
    final context = Get.context;
    if (context == null) return;
    final palette = Theme.of(context).extension<OpticaPalette>()!;
    final scheme = Theme.of(context).colorScheme;
    final (icon, color) = switch (kind) {
      _Kind.success => (Icons.check_circle_rounded, palette.success),
      _Kind.error => (Icons.error_rounded, palette.danger),
      _Kind.info => (Icons.notifications_active_rounded, palette.accent),
    };

    if (kind == _Kind.error) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    Get
      ..closeCurrentSnackbar()
      ..rawSnackbar(
        titleText: title == null
            ? null
            : Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(color: scheme.onInverseSurface),
              ),
        messageText: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface.withValues(alpha: 0.85)),
        ),
        icon: Icon(icon, color: color),
        backgroundColor: scheme.inverseSurface,
        borderRadius: AppRadius.md,
        margin: const EdgeInsets.all(AppSpacing.lg),
        duration: const Duration(seconds: 4),
        animationDuration: AppDurations.slow,
        forwardAnimationCurve: Curves.easeOutCubic,
        onTap: onTap == null ? null : (_) => onTap(),
      );
  }
}

enum _Kind { success, error, info }
