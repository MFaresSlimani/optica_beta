import '../../data/models/lens_item.dart';

/// Pure helpers for building an order out of [LensItem] lines.
abstract final class LensOrder {
  /// Adds [item], merging its quantity into an existing line for the same
  /// lens instead of creating a duplicate. Returns a new list.
  static List<LensItem> add(List<LensItem> lines, LensItem item) {
    final index = lines.indexWhere((line) => line.isSameLensAs(item));
    if (index == -1) return [...lines, item];
    final merged = lines[index].copyWith(quantity: lines[index].quantity + item.quantity);
    return [...lines]..[index] = merged;
  }

  /// Folds duplicates together, keeping first-seen order.
  static List<LensItem> consolidate(Iterable<LensItem> lines) {
    return lines.fold(<LensItem>[], add);
  }

  static int totalQuantity(Iterable<LensItem> lines) {
    return lines.fold(0, (sum, line) => sum + line.quantity);
  }

  /// Splits [ordered] into lines that are in [supplied] and the rest.
  static ({List<LensItem> done, List<LensItem> left}) split(
    List<LensItem> ordered,
    Set<int> suppliedIndexes,
  ) {
    final done = <LensItem>[];
    final left = <LensItem>[];
    for (var i = 0; i < ordered.length; i++) {
      (suppliedIndexes.contains(i) ? done : left).add(ordered[i]);
    }
    return (done: done, left: left);
  }
}
