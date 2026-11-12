import 'package:bng_optica/data/models/app_user.dart';
import 'package:bng_optica/data/models/diopter.dart';
import 'package:bng_optica/data/models/glasses_request.dart';
import 'package:bng_optica/data/models/lens_item.dart';
import 'package:bng_optica/data/models/request_entry.dart';
import 'package:bng_optica/data/models/store.dart';

/// Realistic fixtures shared by tests and screenshot generation.
abstract final class Sample {
  static const owner = AppUser(
    uid: 'u-owner',
    username: 'Amina Benali',
    email: 'amina@vision-plus.dz',
    phoneNumber: '+213 555 12 34 56',
    isStoreOwner: true,
    storeId: 's-vision',
  );

  static const optician = AppUser(
    uid: 'u-optician',
    username: 'Yacine Haddad',
    email: 'yacine@optique-casbah.dz',
    phoneNumber: '+213 661 98 76 54',
  );

  static const karim = AppUser(
    uid: 'u-karim',
    username: 'Karim Meziane',
    email: 'karim@regard-clair.dz',
  );

  static const visionPlus = Store(
    id: 's-vision',
    name: 'Vision Plus Optique',
    location: 'Rue Didouche Mourad, Alger Centre',
    details:
        'Independent optician since 2009. Full range of organic and polycarbonate '
        'lenses, same-week edging and fitting for partner stores.',
    ownerUid: 'u-owner',
    ownerEmail: 'amina@vision-plus.dz',
    ownerPhone: '+213 555 12 34 56',
  );

  static const stores = [
    visionPlus,
    Store(id: 's-2', name: 'Optique El Djazair', location: 'Bab Ezzouar, Alger', ownerUid: 'u-2'),
    Store(
      id: 's-3',
      name: 'Lumière Opticiens',
      location: 'Boulevard Zighoud Youcef, Oran',
      ownerUid: 'u-3',
    ),
    Store(id: 's-4', name: 'Regard Clair', location: 'Cité 5 Juillet, Boumerdès', ownerUid: 'u-4'),
    Store(id: 's-5', name: 'Atlas Vision', location: 'Centre-ville, Constantine', ownerUid: 'u-5'),
  ];

  static LensItem lens(String type, double sph, double cyl, int qty) => LensItem(
    type: type,
    sphere: Diopter.fromValue(sph),
    cylinder: Diopter.fromValue(cyl),
    quantity: qty,
  );

  static final orderLines = [
    lens('HMC 1.61', -2.25, -0.50, 2),
    lens('Blue Block 1.56', 1.00, 0, 4),
    lens('Photochromique Gris', -4.75, -1.25, 1),
  ];

  static final pendingRequest = GlassesRequest(
    id: 'a3f9c2e1-0000-4000-8000-000000000001',
    senderUid: optician.uid,
    receiverUid: owner.uid,
    storeId: visionPlus.id,
    items: orderLines,
    createdAt: DateTime(2026, 11, 12, 9, 40),
  );

  static final completedRequest = GlassesRequest(
    id: 'b7d1e4a0-0000-4000-8000-000000000002',
    senderUid: optician.uid,
    receiverUid: owner.uid,
    storeId: visionPlus.id,
    items: orderLines,
    doneItems: orderLines.sublist(0, 2),
    leftItems: orderLines.sublist(2),
    createdAt: DateTime(2026, 11, 10, 14, 5),
    doneAt: DateTime(2026, 11, 11, 10, 30),
    doneMessage: 'Photochromic grey is back in stock on Monday, we will ship it then.',
    isDone: true,
  );

  static final karimRequest = GlassesRequest(
    id: 'c9a2f6b3-0000-4000-8000-000000000003',
    senderUid: karim.uid,
    receiverUid: owner.uid,
    storeId: visionPlus.id,
    items: [lens('Polycarbonate', -1.50, -0.25, 6), lens('UV400', 0, 0, 10)],
    createdAt: DateTime(2026, 11, 12, 11, 15),
  );

  static RequestEntry entry(GlassesRequest request) =>
      RequestEntry(request: request, store: visionPlus, sender: optician, receiver: owner);
}
