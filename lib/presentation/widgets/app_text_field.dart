import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_spacing.dart';
import '../../core/theme/theme_context.dart';

/// Labelled text field. [validator] returns a translation key (see
/// `Validators`), which is translated here.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.obscureText = false,
    this.onToggleObscure,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final IconData? icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final bool obscureText;

  /// When set, shows an eye button that calls this.
  final VoidCallback? onToggleObscure;
  final bool readOnly;
  final bool enabled;
  final int maxLines;
  final int? minLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: AppSpacing.xs, bottom: AppSpacing.sm),
          child: Text(label, style: context.text.labelMedium),
        ),
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          validator: validator == null ? null : (value) => validator!(value)?.tr,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: obscureText ? 1 : maxLines,
          minLines: minLines,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          textCapitalization: textCapitalization,
          style: context.text.bodyLarge?.copyWith(
            color: readOnly ? palette.textMuted : palette.textPrimary,
          ),
          cursorColor: palette.accent,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon == null ? null : Icon(icon, size: 20),
            suffixIcon: onToggleObscure == null
                ? null
                : IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
