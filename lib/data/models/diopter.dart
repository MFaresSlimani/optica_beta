import 'package:flutter/foundation.dart';

/// A lens power in diopters, stored as an integer number of quarter steps.
///
/// Prescriptions move in 0.25 D increments, so storing quarters keeps
/// equality and arithmetic exact (no `0.1 + 0.2` surprises).
@immutable
class Diopter implements Comparable<Diopter> {
  const Diopter.quarters(this.quarters);

  /// Rounds to the nearest quarter step.
  factory Diopter.fromValue(double value) => Diopter.quarters((value * 4).round());

  /// Parses `+1.25`, `-0.50` or `2`. Returns null for anything else.
  static Diopter? tryParse(String input) {
    final match = RegExp(r'^\s*([+-]?\d+(?:\.\d+)?)\s*$').firstMatch(input);
    if (match == null) return null;
    final value = double.tryParse(match.group(1)!.replaceFirst('+', ''));
    return value == null ? null : Diopter.fromValue(value);
  }

  /// Builds a power from the picker's parts: sign, whole diopters and quarter
  /// steps (0–3, i.e. .00 .25 .50 .75).
  factory Diopter.fromParts({required bool negative, required int whole, required int quarter}) {
    final magnitude = whole * 4 + quarter;
    return Diopter.quarters(negative ? -magnitude : magnitude);
  }

  static const Diopter zero = Diopter.quarters(0);

  /// Decimal labels for the quarter steps, indexed by [quarterPart].
  static const List<String> quarterLabels = ['00', '25', '50', '75'];

  final int quarters;

  double get value => quarters / 4;

  bool get isZero => quarters == 0;

  bool get isNegative => quarters < 0;

  /// Whole diopters, without sign: 2 for -2.75.
  int get wholePart => quarters.abs() ~/ 4;

  /// Quarter steps after the whole part, without sign: 3 for -2.75.
  int get quarterPart => quarters.abs() % 4;

  /// Signed, two decimals: `+1.25`, `-0.50`, `+0.00`.
  String format() {
    final sign = quarters < 0 ? '-' : '+';
    return '$sign${value.abs().toStringAsFixed(2)}';
  }

  @override
  int compareTo(Diopter other) => quarters.compareTo(other.quarters);

  @override
  bool operator ==(Object other) => other is Diopter && other.quarters == quarters;

  @override
  int get hashCode => quarters.hashCode;

  @override
  String toString() => format();
}
