import 'package:flutter/widgets.dart';

/// 4/8-point spacing scale. Every padding, gap and radius in the app comes
/// from here; no magic numbers in views.
abstract final class AppSpacing {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Horizontal gutter for screen content.
  static const double gutter = lg;

  /// Content never grows wider than this on tablets and desktop.
  static const double maxContentWidth = 600;

  /// Minimum tap target (Material guideline).
  static const double minTapTarget = 48;

  static const EdgeInsets screen = EdgeInsets.symmetric(horizontal: gutter);
  static const EdgeInsets card = EdgeInsets.all(lg);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 999;

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
}

abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);
}
