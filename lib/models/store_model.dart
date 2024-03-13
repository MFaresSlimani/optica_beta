class Store{
  final String storeId, storeName, storeOwner, storeOwnerEmail, storeOwnerUid, storeOwnerPfp, storeOwnerPhoneNumber;
  final bool isRestricted, isApproved;
  final List<String> storeAdmins;
  final List<String> storePictures;
  Store({
    required this.storeId,
    required this.storeName,
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
  factory Store.fromMap(Map<String, dynamic> data, String storeId){
    return Store(
      storeId: storeId,
      storeName: data['storeName'],
      storeOwner: data['storeOwner'],
      storeOwnerEmail: data['storeOwnerEmail'],
      storeOwnerUid: data['storeOwnerUid'],
      isRestricted: data['isRestricted'],
      isApproved: data['isApproved'],
      storeAdmins: List<String>.from(data['storeAdmins']),
      storeOwnerPfp: data['storeOwnerPfp'],
      storeOwnerPhoneNumber: data['storeOwnerPhoneNumber'],
      storePictures: List<String>.from(data['storePictures']),
    );
  }
  Map<String, dynamic> toMap(){
    return {
      'storeName': storeName,
      'storeOwner': storeOwner,
      'storeOwnerEmail': storeOwnerEmail,
      'storeOwnerUid': storeOwnerUid,
      'isRestricted': isRestricted,
      'isApproved': isApproved,
      'storeAdmins': storeAdmins,
      'storeOwnerPfp': storeOwnerPfp,
      'storeOwnerPhoneNumber': storeOwnerPhoneNumber,
      'storePictures': storePictures,
    };
  }
}