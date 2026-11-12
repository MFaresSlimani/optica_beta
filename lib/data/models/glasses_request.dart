import 'package:flutter/foundation.dart';

import 'json_reader.dart';
import 'lens_item.dart';

/// A glasses order sent from one store user to a store owner.
@immutable
class GlassesRequest {
  const GlassesRequest({
    required this.id,
    required this.senderUid,
    required this.receiverUid,
    required this.storeId,
    required this.items,
    required this.createdAt,
    this.doneItems = const [],
    this.leftItems = const [],
    this.doneAt,
    this.doneMessage = '',
    this.isDone = false,
  });

  final String id;
  final String senderUid;
  final String receiverUid;
  final String storeId;

  /// Everything that was ordered.
  final List<LensItem> items;

  /// Filled when completed: lines the store could supply...
  final List<LensItem> doneItems;

  /// ...and lines it could not.
  final List<LensItem> leftItems;

  final DateTime createdAt;
  final DateTime? doneAt;
  final String doneMessage;
  final bool isDone;

  int get totalQuantity => items.fold(0, (sum, item) => sum + item.quantity);

  factory GlassesRequest.fromMap(Map<String, dynamic> map) {
    final json = JsonReader(map);
    final isDone = json.boolean(['is_done', 'isDone']);
    List<LensItem> lenses(List<String> keys) =>
        json.stringList(keys).map(LensItem.decode).toList(growable: false);

    return GlassesRequest(
      id: json.string(['id']),
      senderUid: json.string(['sender_uid', 'senderUid']),
      receiverUid: json.string(['receiver_uid', 'receiverUid']),
      storeId: json.string(['store_id', 'storeId']),
      items: lenses(['description']),
      doneItems: lenses(['done_glasses', 'doneGlasses']),
      leftItems: lenses(['left_glasses', 'leftGlasses']),
      createdAt:
          json.dateTime(['created_at', 'createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      doneAt: isDone ? json.dateTime(['done_at', 'doneAt']) : null,
      doneMessage: json.string(['done_message', 'doneMessage']),
      isDone: isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'sender_uid': senderUid,
      'receiver_uid': receiverUid,
      'store_id': storeId,
      'description': [for (final item in items) item.encode()],
      'done_glasses': [for (final item in doneItems) item.encode()],
      'left_glasses': [for (final item in leftItems) item.encode()],
      'created_at': createdAt.millisecondsSinceEpoch,
      'done_at': doneAt?.millisecondsSinceEpoch,
      'done_message': doneMessage,
      'is_done': isDone,
    };
  }

  GlassesRequest copyWith({
    String? id,
    List<LensItem>? doneItems,
    List<LensItem>? leftItems,
    DateTime? doneAt,
    String? doneMessage,
    bool? isDone,
  }) {
    return GlassesRequest(
      id: id ?? this.id,
      senderUid: senderUid,
      receiverUid: receiverUid,
      storeId: storeId,
      items: items,
      createdAt: createdAt,
      doneItems: doneItems ?? this.doneItems,
      leftItems: leftItems ?? this.leftItems,
      doneAt: doneAt ?? this.doneAt,
      doneMessage: doneMessage ?? this.doneMessage,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GlassesRequest &&
          other.id == id &&
          other.senderUid == senderUid &&
          other.receiverUid == receiverUid &&
          other.storeId == storeId &&
          listEquals(other.items, items) &&
          listEquals(other.doneItems, doneItems) &&
          listEquals(other.leftItems, leftItems) &&
          other.createdAt == createdAt &&
          other.doneAt == doneAt &&
          other.doneMessage == doneMessage &&
          other.isDone == isDone;

  @override
  int get hashCode => Object.hash(
    id,
    senderUid,
    receiverUid,
    storeId,
    Object.hashAll(items),
    Object.hashAll(doneItems),
    Object.hashAll(leftItems),
    createdAt,
    doneAt,
    doneMessage,
    isDone,
  );
}
