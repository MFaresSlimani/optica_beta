class AppUser {
  final String uid, username, email, pfp, phoneNumber, fcmtoken;
  final bool isStoreOwner, isRestricted;
  final String? storeId;

  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.isStoreOwner,
    required this.isRestricted,
    required this.pfp,
    required this.phoneNumber,
    required this.fcmtoken,
    this.storeId,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, [String? uid]) {
    return AppUser(
      uid: uid ?? data['id']?.toString() ?? data['uid']?.toString() ?? '',
      username: data['username']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      isStoreOwner: (data['is_store_owner'] ?? data['isStoreOwner']) as bool? ?? false,
      isRestricted: (data['is_restricted'] ?? data['isRestricted']) as bool? ?? false,
      pfp: data['pfp']?.toString() ?? '',
      phoneNumber: (data['phone_number'] ?? data['phoneNumber'])?.toString() ?? '',
      fcmtoken: data['fcmtoken']?.toString() ?? '',
      storeId: (data['store_id'] ?? data['storeId'])?.toString(),
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'username': username,
      'email': email,
      'is_store_owner': isStoreOwner,
      'is_restricted': isRestricted,
      'pfp': pfp,
      'phone_number': phoneNumber,
      'fcmtoken': fcmtoken,
      'store_id': storeId,
    };
  }

  Map<String, dynamic> toJson() => toMap();
}