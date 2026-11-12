import 'package:bng_optica/core/utils/load_status.dart';
import 'package:bng_optica/presentation/modules/home/controllers/home_controller.dart';
import 'package:bng_optica/presentation/modules/profile/controllers/create_store_controller.dart';
import 'package:bng_optica/presentation/modules/store_details/controllers/store_details_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fakes.dart';
import '../helpers/sample_data.dart';

void main() {
  setUp(() => Get.testMode = true);

  group('HomeController', () {
    test('loads approved stores and puts my own store first', () async {
      final controller = HomeController(
        stores: FakeStoresProvider([...Sample.stores.reversed]),
        session: signedInSession(Sample.owner),
      );
      await controller.load();
      expect(controller.status.value, LoadStatus.ready);
      expect(controller.visibleStores.first.id, Sample.visionPlus.id);
      expect(controller.firstName, 'Amina');
    });

    test('search matches name or city, case-insensitively', () async {
      final controller = HomeController(
        stores: FakeStoresProvider(Sample.stores),
        session: signedInSession(Sample.optician),
      );
      await controller.load();
      controller.onSearchChanged('ORAN');
      expect(controller.visibleStores.single.name, 'Lumière Opticiens');
      controller.onSearchChanged('vision');
      expect(controller.visibleStores.map((s) => s.name), ['Vision Plus Optique', 'Atlas Vision']);
      controller.clearSearch();
      expect(controller.visibleStores, hasLength(Sample.stores.length));
    });

    test('shows an error state when the backend fails', () async {
      final controller = HomeController(
        stores: FakeStoresProvider()..fail = true,
        session: signedInSession(Sample.optician),
      );
      await controller.load();
      expect(controller.status.value, LoadStatus.error);
    });
  });

  group('StoreDetailsController', () {
    test('deleting asks first and does nothing when declined', () async {
      final stores = FakeStoresProvider(Sample.stores);
      final feedback = RecordingFeedback()..confirmResult = false;
      final controller = StoreDetailsController(
        store: Sample.visionPlus,
        stores: stores,
        users: FakeUsersProvider([Sample.owner]),
        session: signedInSession(Sample.owner),
        feedback: feedback,
      );
      await controller.deleteStore();
      expect(feedback.confirmCalls, 1);
      expect(stores.stores, hasLength(Sample.stores.length));
    });

    test('deleting removes the store and clears ownership in the session', () async {
      final stores = FakeStoresProvider(Sample.stores);
      final users = FakeUsersProvider([Sample.owner]);
      final session = signedInSession(Sample.owner, users: users);
      final controller = StoreDetailsController(
        store: Sample.visionPlus,
        stores: stores,
        users: users,
        session: session,
        feedback: RecordingFeedback(),
      );
      expect(controller.isOwner, isTrue);
      await controller.deleteStore();
      expect(stores.stores.any((s) => s.id == Sample.visionPlus.id), isFalse);
      expect(users.users[Sample.owner.uid]!.isStoreOwner, isFalse);
      expect(session.user.value!.hasStore, isFalse);
    });
  });

  testWidgets('CreateStoreController uploads photos, creates the store and links it', (
    tester,
  ) async {
    final stores = FakeStoresProvider();
    final users = FakeUsersProvider([Sample.optician]);
    final storage = FakeStorageProvider();
    final session = signedInSession(Sample.optician, users: users);
    final controller = CreateStoreController(
      stores: stores,
      users: users,
      storage: storage,
      session: session,
      feedback: RecordingFeedback(),
    );
    // The form key needs a mounted Form to validate.
    await tester.pumpWidget(Form(key: controller.formKey, child: const SizedBox()));

    controller.nameController.text = 'Optique Casbah';
    controller.addressController.text = 'Casbah, Alger';
    controller.descriptionController.text = 'Neighbourhood optician.';
    controller.photoPaths.addAll(['/tmp/a.jpg', '/tmp/b.jpg']);
    await controller.create();

    final created = stores.stores.single;
    expect(created.name, 'Optique Casbah');
    expect(created.ownerUid, Sample.optician.uid);
    expect(created.pictures, hasLength(2));
    expect(storage.uploaded, ['/tmp/a.jpg', '/tmp/b.jpg']);
    expect(users.users[Sample.optician.uid]!.storeId, created.id);
    expect(session.user.value!.hasStore, isTrue);
  });
}
