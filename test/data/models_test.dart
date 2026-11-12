import 'package:bng_optica/data/models/app_user.dart';
import 'package:bng_optica/data/models/glasses_request.dart';
import 'package:bng_optica/data/models/store.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/sample_data.dart';

void main() {
  group('GlassesRequest', () {
    test('toMap / fromMap round-trip', () {
      final request = Sample.completedRequest;
      expect(GlassesRequest.fromMap(request.toMap()), request);
    });

    test('writes epoch milliseconds, matching the bigint columns', () {
      final map = Sample.completedRequest.toMap();
      expect(map['created_at'], Sample.completedRequest.createdAt.millisecondsSinceEpoch);
      expect(map['done_at'], isA<int>());
      expect(map['description'], everyElement(isA<String>()));
    });

    test('omits an empty id so Postgres generates one', () {
      final map = Sample.pendingRequest.copyWith(id: '').toMap();
      expect(map.containsKey('id'), isFalse);
    });

    test('reads legacy camelCase rows and numeric strings', () {
      final request = GlassesRequest.fromMap({
        'id': 'r1',
        'senderUid': 'a',
        'receiverUid': 'b',
        'storeId': 's',
        'description': ['HCT 1.56\n CYL: +0.00,\t\t\t SPH: +0.00 (x1)'],
        'createdAt': '1700000000000',
        'isDone': false,
      });
      expect(request.senderUid, 'a');
      expect(request.items.single.type, 'HCT 1.56');
      expect(request.createdAt, DateTime.fromMillisecondsSinceEpoch(1700000000000));
    });

    test('ignores done_at while the request is still pending', () {
      final request = GlassesRequest.fromMap({'id': 'r', 'done_at': 1, 'is_done': false});
      expect(request.doneAt, isNull);
    });

    test('totalQuantity sums line quantities', () {
      expect(Sample.pendingRequest.totalQuantity, 7);
    });
  });

  group('AppUser', () {
    test('round-trips and treats an empty store id as none', () {
      expect(AppUser.fromMap(Sample.owner.toMap()), Sample.owner);
      expect(AppUser.fromMap(const {'id': 'x', 'store_id': ''}).storeId, isNull);
    });

    test('displayName falls back to the email local part', () {
      expect(const AppUser(uid: 'x', email: 'sara@shop.dz').displayName, 'sara');
      expect(const AppUser(uid: 'x', username: ' Sara ').displayName, 'Sara');
    });
  });

  group('Store', () {
    test('round-trips and defaults to approved', () {
      expect(Store.fromMap(Sample.visionPlus.toMap()), Sample.visionPlus);
      expect(Store.fromMap(const {'id': 's'}).isApproved, isTrue);
    });
  });
}
