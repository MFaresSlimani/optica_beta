import 'package:flutter/foundation.dart';

import 'diopter.dart';

/// One line of a glasses order: a lens type at a given prescription.
///
/// On the wire (Supabase `jsonb` arrays and the local Hive draft) each line
/// is a legacy formatted string, e.g. `HMC 1.61\n CYL: -0.50,\t\t\t SPH: +1.25 (x2)`.
/// [encode] and [decode] keep that format byte-for-byte so rows written by
/// older app versions still load. A string that cannot be parsed is kept
/// verbatim in [raw] and written back unchanged, so nothing is ever lost.
@immutable
class LensItem {
  const LensItem({
    required this.type,
    required this.cylinder,
    required this.sphere,
    this.quantity = 1,
  }) : raw = null;

  const LensItem._unparsed(String this.raw)
    : type = raw,
      cylinder = Diopter.zero,
      sphere = Diopter.zero,
      quantity = 1;

  final String type;
  final Diopter cylinder;
  final Diopter sphere;
  final int quantity;

  /// The original text when it could not be parsed; null for parsed items.
  final String? raw;

  bool get isParsed => raw == null;

  static final RegExp _pattern = RegExp(
    r'^(?<type>.*?)\s*CYL:\s*(?<cyl>[+-]?\d+(?:\.\d+)?)\s*,\s*SPH:\s*(?<sph>[+-]?\d+(?:\.\d+)?)\s*\(x(?<qty>\d+)\)\s*$',
    dotAll: true,
  );

  /// Parses the legacy format. Never throws and never returns null.
  static LensItem decode(String input) {
    final match = _pattern.firstMatch(input);
    if (match == null) return LensItem._unparsed(input);
    final cylinder = Diopter.tryParse(match.namedGroup('cyl')!);
    final sphere = Diopter.tryParse(match.namedGroup('sph')!);
    final quantity = int.tryParse(match.namedGroup('qty')!);
    final type = match.namedGroup('type')!.trim();
    if (cylinder == null || sphere == null || quantity == null || type.isEmpty) {
      return LensItem._unparsed(input);
    }
    return LensItem(type: type, cylinder: cylinder, sphere: sphere, quantity: quantity);
  }

  String encode() {
    return raw ?? '$type\n CYL: ${cylinder.format()},\t\t\t SPH: ${sphere.format()} (x$quantity)';
  }

  /// Same lens (type, ignoring case and padding, plus both powers).
  /// Quantity is not part of the identity.
  bool isSameLensAs(LensItem other) {
    if (!isParsed || !other.isParsed) return encode() == other.encode();
    return type.trim().toLowerCase() == other.type.trim().toLowerCase() &&
        cylinder == other.cylinder &&
        sphere == other.sphere;
  }

  LensItem copyWith({int? quantity}) {
    if (!isParsed) return this;
    return LensItem(
      type: type,
      cylinder: cylinder,
      sphere: sphere,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LensItem &&
      other.type == type &&
      other.cylinder == cylinder &&
      other.sphere == sphere &&
      other.quantity == quantity &&
      other.raw == raw;

  @override
  int get hashCode => Object.hash(type, cylinder, sphere, quantity, raw);

  @override
  String toString() => encode().replaceAll(RegExp(r'\s+'), ' ');
}
