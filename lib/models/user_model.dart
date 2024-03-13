class AppUser{
  final String uid, username, email, pfp, phoneNumber;
  final bool isStoreOwner, isRestricted;
  AppUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.isStoreOwner,
    required this.isRestricted,
    required this.pfp,
    required this.phoneNumber,
  });
  factory AppUser.fromMap(Map<String, dynamic> data, String uid){
    return AppUser(
      uid: uid,
      username: data['username'],
      email: data['email'],
      isStoreOwner: data['isStoreOwner'],
      isRestricted: data['isRestricted'],
      pfp: data['pfp'],
      phoneNumber: data['phoneNumber'],
    );
  }
  Map<String, dynamic> toMap(){
    return {
      'username': username,
      'email': email,
      'isStoreOwner': isStoreOwner,
      'isRestricted': isRestricted,
      'pfp': pfp,
      'phoneNumber': phoneNumber,
    };
  }
}