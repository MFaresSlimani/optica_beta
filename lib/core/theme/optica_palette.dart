import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Semantic colors that Material's [ColorScheme] has no slot for.
///
/// Read with `context.palette` (see `theme_context.dart`).
@immutable
class OpticaPalette extends ThemeExtension<OpticaPalette> {
  const OpticaPalette({
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.surfaceRaised,
    required this.surfaceSunken,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.warningSoft,
    required this.danger,
    required this.dangerSoft,
    required this.heroGradient,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
  final Color surfaceRaised;
  final Color surfaceSunken;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color warningSoft;
  final Color danger;
  final Color dangerSoft;
  final Gradient heroGradient;

  static const OpticaPalette light = OpticaPalette(
    textPrimary: AppColors.ink900,
    textSecondary: AppColors.ink600,
    textMuted: AppColors.ink400,
    border: Color(0xFFE6DED5),
    borderStrong: Color(0xFFD3C7BA),
    surfaceRaised: AppColors.white,
    surfaceSunken: AppColors.sand100,
    accent: AppColors.copper600,
    onAccent: AppColors.white,
    accentSoft: Color(0xFFF5E9E1),
    success: AppColors.green500,
    successSoft: Color(0xFFE3F4EA),
    warning: AppColors.amber600,
    warningSoft: Color(0xFFFBF0DA),
    danger: AppColors.red600,
    dangerSoft: Color(0xFFFBE6E4),
    heroGradient: AppColors.tealGradient,
  );

  static const OpticaPalette dark = OpticaPalette(
    textPrimary: Color(0xFFF3EFEB),
    textSecondary: Color(0xFFB8C9CB),
    textMuted: Color(0xFF7F9A9E),
    border: Color(0x33B78D75),
    borderStrong: Color(0x59B78D75),
    surfaceRaised: AppColors.teal800,
    surfaceSunken: AppColors.teal950,
    accent: AppColors.copper300,
    onAccent: AppColors.teal950,
    accentSoft: Color(0x26B78D75),
    success: AppColors.green300,
    successSoft: Color(0x262E9D6A),
    warning: AppColors.amber300,
    warningSoft: Color(0x26B7791F),
    danger: AppColors.red300,
    dangerSoft: Color(0x26C8433A),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [AppColors.teal950, AppColors.teal800],
    ),
  );

  @override
  OpticaPalette copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? borderStrong,
    Color? surfaceRaised,
    Color? surfaceSunken,
    Color? accent,
    Color? onAccent,
    Color? accentSoft,
    Color? success,
    Color? successSoft,
    Color? warning,
    Color? warningSoft,
    Color? danger,
    Color? dangerSoft,
    Gradient? heroGradient,
  }) {
    return OpticaPalette(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      borderStrong: borderStrong ?? this.borderStrong,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      surfaceSunken: surfaceSunken ?? this.surfaceSunken,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentSoft: accentSoft ?? this.accentSoft,
      success: success ?? this.success,
      successSoft: successSoft ?? this.successSoft,
      warning: warning ?? this.warning,
      warningSoft: warningSoft ?? this.warningSoft,
      danger: danger ?? this.danger,
      dangerSoft: dangerSoft ?? this.dangerSoft,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  OpticaPalette lerp(OpticaPalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return OpticaPalette(
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      textMuted: mix(textMuted, other.textMuted),
      border: mix(border, other.border),
      borderStrong: mix(borderStrong, other.borderStrong),
      surfaceRaised: mix(surfaceRaised, other.surfaceRaised),
      surfaceSunken: mix(surfaceSunken, other.surfaceSunken),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      accentSoft: mix(accentSoft, other.accentSoft),
      success: mix(success, other.success),
      successSoft: mix(successSoft, other.successSoft),
      warning: mix(warning, other.warning),
      warningSoft: mix(warningSoft, other.warningSoft),
      danger: mix(danger, other.danger),
      dangerSoft: mix(dangerSoft, other.dangerSoft),
      heroGradient: Gradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }
}
