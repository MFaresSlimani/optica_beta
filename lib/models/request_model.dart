class Request {
  String id;
  final String senderUid;
  final String receiverUid;
  final String storeId;
  final List<String> description;
  List<String>? doneGlasses;
  List<String>? leftGlasses;
  final DateTime createdAt;
  DateTime? doneAt;
  String doneMessage;
  bool isDone;

  Request({
    required this.id,
    required this.senderUid,
    required this.receiverUid,
    required this.storeId,
    required this.description,
    this.doneGlasses,
    this.leftGlasses,
    required this.createdAt,
    this.doneAt,
    required this.doneMessage,
    required this.isDone,
  });

  static DateTime _parseDate(dynamic val, [DateTime? fallback]) {
    if (val == null) return fallback ?? DateTime.now();
    if (val is int) return DateTime.fromMillisecondsSinceEpoch(val);
    if (val is String) {
      final intVal = int.tryParse(val);
      if (intVal != null) return DateTime.fromMillisecondsSinceEpoch(intVal);
      return DateTime.tryParse(val) ?? fallback ?? DateTime.now();
    }
    return fallback ?? DateTime.now();
  }

  factory Request.fromMap(Map<String, dynamic> map, [String? id]) {
    final isDone = (map['is_done'] ?? map['isDone']) as bool? ?? false;
    final doneAtVal = map['done_at'] ?? map['doneAt'];

    return Request(
      id: id ?? map['id']?.toString() ?? '',
      senderUid: (map['sender_uid'] ?? map['senderUid'])?.toString() ?? '',
      receiverUid: (map['receiver_uid'] ?? map['receiverUid'])?.toString() ?? '',
      storeId: (map['store_id'] ?? map['storeId'])?.toString() ?? '',
      description: List<String>.from(map['description'] ?? []),
      doneGlasses: map['done_glasses'] != null
          ? List<String>.from(map['done_glasses'])
          : (map['doneGlasses'] != null ? List<String>.from(map['doneGlasses']) : []),
      leftGlasses: map['left_glasses'] != null
          ? List<String>.from(map['left_glasses'])
          : (map['leftGlasses'] != null ? List<String>.from(map['leftGlasses']) : []),
      createdAt: _parseDate(map['created_at'] ?? map['createdAt']),
      doneAt: isDone && doneAtVal != null ? _parseDate(doneAtVal) : null,
      doneMessage: (map['done_message'] ?? map['doneMessage'])?.toString() ?? '',
      isDone: isDone,
    );
  }

  factory Request.fromJson(Map<String, dynamic> json) => Request.fromMap(json);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'sender_uid': senderUid,
      'receiver_uid': receiverUid,
      'store_id': storeId,
      'description': description,
      'done_glasses': doneGlasses ?? [],
      'left_glasses': leftGlasses ?? [],
      'created_at': createdAt.millisecondsSinceEpoch,
      'done_message': doneMessage,
      'is_done': isDone,
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    if (isDone && doneAt != null) {
      map['done_at'] = doneAt!.millisecondsSinceEpoch;
    }
    return map;
  }

  Map<String, dynamic> toJson() => toMap();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Request &&
          id == other.id &&
          senderUid == other.senderUid &&
          receiverUid == other.receiverUid &&
          storeId == other.storeId &&
          description == other.description &&
          doneGlasses == other.doneGlasses &&
          leftGlasses == other.leftGlasses &&
          createdAt == other.createdAt &&
          doneAt == other.doneAt &&
          doneMessage == other.doneMessage &&
          isDone == other.isDone);

  @override
  int get hashCode =>
      id.hashCode ^
      senderUid.hashCode ^
      receiverUid.hashCode ^
      storeId.hashCode ^
      description.hashCode ^
      doneGlasses.hashCode ^
      leftGlasses.hashCode ^
      createdAt.hashCode ^
      doneAt.hashCode ^
      doneMessage.hashCode ^
      isDone.hashCode;
}
