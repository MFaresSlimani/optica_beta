import 'package:flutter/foundation.dart';

import 'json_reader.dart';

@immutable
class AppUser {
  const AppUser({
    required this.uid,
    this.username = '',
    this.email = '',
    this.phoneNumber = '',
    this.pfp = '',
    this.fcmToken = '',
    this.isStoreOwner = false,
    this.isRestricted = false,
    this.storeId,
  });

  /// Placeholder used when a profile row is missing.
  const AppUser.unknown(String uid) : this(uid: uid);

  final String uid;
  final String username;
  final String email;
  final String phoneNumber;
  final String pfp;
  final String fcmToken;
  final bool isStoreOwner;
  final bool isRestricted;
  final String? storeId;

  bool get hasStore => isStoreOwner && (storeId?.isNotEmpty ?? false);

  /// Username, else the local part of the email, else empty.
  String get displayName {
    if (username.trim().isNotEmpty) return username.trim();
    final at = email.indexOf('@');
    return at > 0 ? email.substring(0, at) : email;
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    final json = JsonReader(map);
    final storeId = json.nullableString(['store_id', 'storeId']);
    return AppUser(
      uid: json.string(['id', 'uid']),
      username: json.string(['username']),
      email: json.string(['email']),
      phoneNumber: json.string(['phone_number', 'phoneNumber']),
      pfp: json.string(['pfp']),
      fcmToken: json.string(['fcmtoken']),
      isStoreOwner: json.boolean(['is_store_owner', 'isStoreOwner']),
      isRestricted: json.boolean(['is_restricted', 'isRestricted']),
      storeId: (storeId == null || storeId.isEmpty) ? null : storeId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'pfp': pfp,
      'fcmtoken': fcmToken,
      'is_store_owner': isStoreOwner,
      'is_restricted': isRestricted,
      'store_id': storeId ?? '',
    };
  }

  AppUser copyWith({
    String? username,
    String? phoneNumber,
    String? pfp,
    bool? isStoreOwner,
    String? storeId,
    bool clearStore = false,
  }) {
    return AppUser(
      uid: uid,
      username: username ?? this.username,
      email: email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pfp: pfp ?? this.pfp,
      fcmToken: fcmToken,
      isStoreOwner: isStoreOwner ?? this.isStoreOwner,
      isRestricted: isRestricted,
      storeId: clearStore ? null : (storeId ?? this.storeId),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is AppUser &&
      other.uid == uid &&
      other.username == username &&
      other.email == email &&
      other.phoneNumber == phoneNumber &&
      other.pfp == pfp &&
      other.fcmToken == fcmToken &&
      other.isStoreOwner == isStoreOwner &&
      other.isRestricted == isRestricted &&
      other.storeId == storeId;

  @override
  int get hashCode => Object.hash(
    uid,
    username,
    email,
    phoneNumber,
    pfp,
    fcmToken,
    isStoreOwner,
    isRestricted,
    storeId,
  );
}
