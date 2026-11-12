import 'package:hive/hive.dart';

import '../../core/constants/app_config.dart';
import '../models/lens_item.dart';

/// Unsent orders, saved per store on the device so a half-built order
/// survives leaving the screen or restarting the app.
class OrderDraftProvider {
  Box<dynamic> get _box => Hive.box<dynamic>(StorageKeys.orderDraftsBox);

  List<LensItem> load(String storeId) {
    final stored = _box.get(storeId);
    if (stored is! List) return const [];
    return [
      for (final line in stored)
        if (line is String) LensItem.decode(line),
    ];
  }

  Future<void> save(String storeId, List<LensItem> items) {
    if (items.isEmpty) return clear(storeId);
    return _box.put(storeId, [for (final item in items) item.encode()]);
  }

  Future<void> clear(String storeId) => _box.delete(storeId);
}
