import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_assets.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'optica_palette.dart';

/// Material 3 themes built from the brand palette.
abstract final class AppTheme {
  static ThemeData get light => _build(
    brightness: Brightness.light,
    palette: OpticaPalette.light,
    scheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.teal900,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.teal50,
      onPrimaryContainer: AppColors.teal900,
      secondary: AppColors.copper600,
      onSecondary: AppColors.white,
      secondaryContainer: Color(0xFFF5E9E1),
      onSecondaryContainer: AppColors.copper700,
      tertiary: AppColors.teal600,
      onTertiary: AppColors.white,
      error: AppColors.red600,
      onError: AppColors.white,
      errorContainer: Color(0xFFFBE6E4),
      onErrorContainer: AppColors.red600,
      surface: AppColors.sand50,
      onSurface: AppColors.ink900,
      onSurfaceVariant: AppColors.ink600,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.white,
      surfaceContainer: AppColors.sand100,
      surfaceContainerHigh: AppColors.sand100,
      surfaceContainerHighest: AppColors.sand200,
      outline: Color(0xFFD3C7BA),
      outlineVariant: Color(0xFFE6DED5),
      shadow: AppColors.black,
      scrim: AppColors.black,
      inverseSurface: AppColors.teal900,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.copper300,
    ),
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    palette: OpticaPalette.dark,
    scheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.copper400,
      onPrimary: AppColors.teal950,
      primaryContainer: Color(0x33B78D75),
      onPrimaryContainer: AppColors.copper200,
      secondary: AppColors.copper300,
      onSecondary: AppColors.teal950,
      secondaryContainer: Color(0x26B78D75),
      onSecondaryContainer: AppColors.copper200,
      tertiary: AppColors.teal100,
      onTertiary: AppColors.teal900,
      error: AppColors.red300,
      onError: AppColors.teal950,
      errorContainer: Color(0x26C8433A),
      onErrorContainer: AppColors.red300,
      surface: AppColors.teal900,
      onSurface: Color(0xFFF3EFEB),
      onSurfaceVariant: Color(0xFFB8C9CB),
      surfaceContainerLowest: AppColors.teal950,
      surfaceContainerLow: AppColors.teal800,
      surfaceContainer: AppColors.teal800,
      surfaceContainerHigh: AppColors.teal700,
      surfaceContainerHighest: AppColors.teal600,
      outline: Color(0x59B78D75),
      outlineVariant: Color(0x33B78D75),
      shadow: AppColors.black,
      scrim: AppColors.black,
      inverseSurface: AppColors.sand50,
      onInverseSurface: AppColors.teal900,
      inversePrimary: AppColors.copper600,
    ),
  );

  static TextTheme _textTheme(OpticaPalette p) {
    TextStyle style(
      double size,
      FontWeight weight,
      Color color, {
      double height = 1.3,
      double spacing = 0,
    }) {
      // Family set here, not only on ThemeData: component themes (buttons, app
      // bar, inputs) copy these styles directly and would otherwise lose it.
      return TextStyle(
        fontFamily: AppFonts.primary,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: spacing,
      );
    }

    return TextTheme(
      displaySmall: style(32, FontWeight.w800, p.textPrimary, height: 1.15, spacing: -0.8),
      headlineMedium: style(28, FontWeight.w800, p.textPrimary, height: 1.2, spacing: -0.6),
      headlineSmall: style(24, FontWeight.w700, p.textPrimary, height: 1.25, spacing: -0.4),
      titleLarge: style(20, FontWeight.w700, p.textPrimary, spacing: -0.2),
      titleMedium: style(16, FontWeight.w700, p.textPrimary),
      titleSmall: style(14, FontWeight.w600, p.textPrimary),
      bodyLarge: style(16, FontWeight.w400, p.textSecondary, height: 1.5),
      bodyMedium: style(14, FontWeight.w500, p.textSecondary, height: 1.45),
      bodySmall: style(13, FontWeight.w500, p.textMuted, height: 1.4),
      labelLarge: style(15, FontWeight.w700, p.textPrimary, spacing: 0.1),
      labelMedium: style(13, FontWeight.w600, p.textSecondary),
      labelSmall: style(11, FontWeight.w800, p.textMuted, spacing: 1.2),
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required OpticaPalette palette,
  }) {
    final isDark = brightness == Brightness.dark;
    final textTheme = _textTheme(palette);
    final inputBorder = OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(color: palette.border),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: AppFonts.primary,
      fontFamilyFallback: AppFonts.fallback,
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [palette],
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: palette.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.lg,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
          side: BorderSide(color: palette.border),
        ),
      ),
      dividerTheme: DividerThemeData(color: palette.border, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTapTarget, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(AppSpacing.minTapTarget, 52),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          foregroundColor: palette.textPrimary,
          side: BorderSide(color: palette.borderStrong),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.accent,
          minimumSize: const Size(AppSpacing.minTapTarget, AppSpacing.minTapTarget),
          textStyle: textTheme.labelLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: palette.textPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceRaised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: palette.textMuted),
        labelStyle: textTheme.bodyMedium,
        floatingLabelStyle: textTheme.bodyMedium?.copyWith(color: palette.accent),
        prefixIconColor: palette.textMuted,
        suffixIconColor: palette.textMuted,
        border: inputBorder,
        enabledBorder: inputBorder,
        disabledBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.border.withValues(alpha: 0.5)),
        ),
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.accent, width: 1.5),
        ),
        errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: palette.danger)),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: palette.danger, width: 1.5),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: palette.danger),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceRaised,
        selectedColor: scheme.primary,
        disabledColor: palette.surfaceSunken,
        side: BorderSide(color: palette.border),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        labelStyle: textTheme.labelMedium,
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(color: scheme.onPrimary),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: palette.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.accentSoft,
        indicatorShape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium?.copyWith(
            color: selected ? palette.textPrimary : palette.textMuted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? palette.accent : palette.textMuted, size: 24);
        }),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          backgroundColor: palette.surfaceSunken,
          foregroundColor: palette.textSecondary,
          selectedBackgroundColor: palette.surfaceRaised,
          selectedForegroundColor: palette.textPrimary,
          side: BorderSide(color: palette.border),
          textStyle: textTheme.labelMedium,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: palette.borderStrong,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: palette.accent,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        minVerticalPadding: AppSpacing.md,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? palette.onAccent : palette.textMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? palette.accent : palette.surfaceSunken,
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? palette.success : Colors.transparent,
        ),
        side: BorderSide(color: palette.borderStrong, width: 1.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.smAll),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? palette.accent : palette.borderStrong,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.accent,
        linearTrackColor: palette.surfaceSunken,
        circularTrackColor: Colors.transparent,
      ),
      badgeTheme: BadgeThemeData(backgroundColor: palette.danger, textColor: AppColors.white),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(color: scheme.inverseSurface, borderRadius: AppRadius.smAll),
        textStyle: textTheme.bodySmall?.copyWith(color: scheme.onInverseSurface),
      ),
    );
  }
}
