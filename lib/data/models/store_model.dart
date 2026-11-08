class Store {
  final String storeName,
      storeDetails,
      storeLocation,
      storeOwner,
      storeOwnerEmail,
      storeOwnerUid,
      storeOwnerPfp,
      storeOwnerPhoneNumber;
  final bool isRestricted, isApproved;
  final List<String> storeAdmins;
  final List<String>? storePictures;
  String storeId;

  Store({
    required this.storeId,
    required this.storeName,
    required this.storeDetails,
    required this.storeLocation,
    required this.storeOwner,
    required this.storeOwnerEmail,
    required this.storeOwnerUid,
    required this.isRestricted,
    required this.isApproved,
    required this.storeAdmins,
    required this.storeOwnerPfp,
    required this.storeOwnerPhoneNumber,
    required this.storePictures,
  });

  factory Store.fromMap(Map<String, dynamic> data, [String? storeId]) {
    return Store(
      storeId: storeId ?? data['id']?.toString() ?? data['storeId']?.toString() ?? '',
      storeName: (data['store_name'] ?? data['storeName'])?.toString() ?? '',
      storeDetails: (data['store_details'] ?? data['storeDetails'])?.toString() ?? '',
      storeLocation: (data['store_location'] ?? data['storeLocation'])?.toString() ?? '',
      storeOwner: (data['store_owner'] ?? data['storeOwner'])?.toString() ?? '',
      storeOwnerEmail: (data['store_owner_email'] ?? data['storeOwnerEmail'])?.toString() ?? '',
      storeOwnerUid: (data['store_owner_uid'] ?? data['storeOwnerUid'])?.toString() ?? '',
      isRestricted: (data['is_restricted'] ?? data['isRestricted']) as bool? ?? false,
      isApproved: (data['is_approved'] ?? data['isApproved']) as bool? ?? true,
      storeAdmins: List<String>.from(data['store_admins'] ?? data['storeAdmins'] ?? []),
      storeOwnerPfp: (data['store_owner_pfp'] ?? data['storeOwnerPfp'])?.toString() ?? '',
      storeOwnerPhoneNumber:
          (data['store_owner_phone_number'] ?? data['storeOwnerPhoneNumber'])?.toString() ?? '',
      storePictures: data['store_pictures'] != null
          ? List<String>.from(data['store_pictures'])
          : (data['storePictures'] != null ? List<String>.from(data['storePictures']) : []),
    );
  }

  factory Store.fromJson(Map<String, dynamic> json) => Store.fromMap(json);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'store_name': storeName,
      'store_owner': storeOwner,
      'store_details': storeDetails,
      'store_location': storeLocation,
      'store_owner_email': storeOwnerEmail,
      'store_owner_uid': storeOwnerUid,
      'is_restricted': isRestricted,
      'is_approved': isApproved,
      'store_admins': storeAdmins,
      'store_owner_pfp': storeOwnerPfp,
      'store_owner_phone_number': storeOwnerPhoneNumber,
      'store_pictures': storePictures,
    };
    if (storeId.isNotEmpty) {
      map['id'] = storeId;
    }
    return map;
  }

  Map<String, dynamic> toJson() => toMap();
}