/// Typed, null-safe reads from a JSON map.
///
/// Each getter takes a list of candidate keys (snake_case first, then the
/// camelCase spelling used by older app versions) and returns a sensible
/// default instead of throwing on a missing or mistyped value.
class JsonReader {
  const JsonReader(this._map);

  final Map<String, dynamic> _map;

  Object? _first(List<String> keys) {
    for (final key in keys) {
      final value = _map[key];
      if (value != null) return value;
    }
    return null;
  }

  String string(List<String> keys) => _first(keys)?.toString() ?? '';

  String? nullableString(List<String> keys) => _first(keys)?.toString();

  bool boolean(List<String> keys, {bool fallback = false}) {
    final value = _first(keys);
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true';
    return fallback;
  }

  List<String> stringList(List<String> keys) {
    final value = _first(keys);
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item != null) item.toString(),
    ];
  }

  /// Accepts epoch milliseconds (int or numeric string) or ISO-8601.
  DateTime? dateTime(List<String> keys) {
    final value = _first(keys);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is num) return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    if (value is String) {
      final millis = int.tryParse(value);
      if (millis != null) return DateTime.fromMillisecondsSinceEpoch(millis);
      return DateTime.tryParse(value);
    }
    return null;
  }
}
