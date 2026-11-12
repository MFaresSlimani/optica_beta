import 'package:flutter/material.dart';

import 'optica_palette.dart';

/// Short accessors so views read tokens, never raw colors.
extension ThemeContext on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get text => Theme.of(this).textTheme;
  OpticaPalette get palette => Theme.of(this).extension<OpticaPalette>()!;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
