import 'package:flutter/foundation.dart';

import 'json_reader.dart';

@immutable
class Store {
  const Store({
    required this.id,
    required this.name,
    required this.ownerUid,
    this.details = '',
    this.location = '',
    this.ownerName = '',
    this.ownerEmail = '',
    this.ownerPhone = '',
    this.ownerPfp = '',
    this.pictures = const [],
    this.admins = const [],
    this.isApproved = true,
    this.isRestricted = false,
  });

  final String id;
  final String name;
  final String details;
  final String location;
  final String ownerUid;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String ownerPfp;
  final List<String> pictures;
  final List<String> admins;
  final bool isApproved;
  final bool isRestricted;

  String? get coverUrl => pictures.isEmpty ? null : pictures.first;

  factory Store.fromMap(Map<String, dynamic> map) {
    final json = JsonReader(map);
    return Store(
      id: json.string(['id', 'storeId']),
      name: json.string(['store_name', 'storeName']),
      details: json.string(['store_details', 'storeDetails']),
      location: json.string(['store_location', 'storeLocation']),
      ownerUid: json.string(['store_owner_uid', 'storeOwnerUid']),
      ownerName: json.string(['store_owner', 'storeOwner']),
      ownerEmail: json.string(['store_owner_email', 'storeOwnerEmail']),
      ownerPhone: json.string(['store_owner_phone_number', 'storeOwnerPhoneNumber']),
      ownerPfp: json.string(['store_owner_pfp', 'storeOwnerPfp']),
      pictures: json.stringList(['store_pictures', 'storePictures']),
      admins: json.stringList(['store_admins', 'storeAdmins']),
      isApproved: json.boolean(['is_approved', 'isApproved'], fallback: true),
      isRestricted: json.boolean(['is_restricted', 'isRestricted']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'store_name': name,
      'store_details': details,
      'store_location': location,
      'store_owner_uid': ownerUid,
      'store_owner': ownerName,
      'store_owner_email': ownerEmail,
      'store_owner_phone_number': ownerPhone,
      'store_owner_pfp': ownerPfp,
      'store_pictures': pictures,
      'store_admins': admins,
      'is_approved': isApproved,
      'is_restricted': isRestricted,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Store &&
      other.id == id &&
      other.name == name &&
      other.details == details &&
      other.location == location &&
      other.ownerUid == ownerUid &&
      other.ownerName == ownerName &&
      other.ownerEmail == ownerEmail &&
      other.ownerPhone == ownerPhone &&
      other.ownerPfp == ownerPfp &&
      listEquals(other.pictures, pictures) &&
      listEquals(other.admins, admins) &&
      other.isApproved == isApproved &&
      other.isRestricted == isRestricted;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    details,
    location,
    ownerUid,
    ownerName,
    ownerEmail,
    ownerPhone,
    ownerPfp,
    Object.hashAll(pictures),
    Object.hashAll(admins),
    isApproved,
    isRestricted,
  );
}
