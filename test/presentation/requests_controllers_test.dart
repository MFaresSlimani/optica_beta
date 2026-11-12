import 'package:bng_optica/core/utils/load_status.dart';
import 'package:bng_optica/data/models/app_user.dart';
import 'package:bng_optica/presentation/modules/request_details/controllers/handle_request_controller.dart';
import 'package:bng_optica/presentation/modules/requests/controllers/requests_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fakes.dart';
import '../helpers/sample_data.dart';

void main() {
  setUp(() => Get.testMode = true);

  group('RequestsController', () {
    late FakeRequestsProvider requests;

    RequestsController build(AppUser user) {
      return RequestsController(
        requests: requests,
        users: FakeUsersProvider([Sample.owner, Sample.optician]),
        stores: FakeStoresProvider(Sample.stores),
        session: signedInSession(user),
      );
    }

    setUp(() {
      requests = FakeRequestsProvider([Sample.pendingRequest, Sample.completedRequest]);
    });

    test('store owners open on their inbox, with names resolved in bulk', () async {
      final controller = build(Sample.owner);
      controller.onInit();
      await controller.load();

      expect(controller.box.value, RequestsBox.received);
      expect(controller.status.value, LoadStatus.ready);
      expect(controller.received, hasLength(2));
      expect(controller.received.first.senderName, 'Yacine Haddad');
      expect(controller.received.first.storeName, 'Vision Plus Optique');
      expect(controller.pendingReceivedCount, 1);
    });

    test('opticians without a store only see what they sent', () async {
      final controller = build(Sample.optician);
      controller.onInit();
      await controller.load();

      expect(controller.box.value, RequestsBox.sent);
      expect(controller.sent, hasLength(2));
      expect(controller.received, isEmpty);
    });

    test('filters by status', () async {
      final controller = build(Sample.owner);
      controller.onInit();
      await controller.load();

      controller.selectFilter(RequestsFilter.pending);
      expect(controller.visible.single.request.isDone, isFalse);
      controller.selectFilter(RequestsFilter.done);
      expect(controller.visible.single.request.isDone, isTrue);
    });

    test('surfaces backend failures as an error state', () async {
      requests.fail = true;
      final controller = build(Sample.owner);
      await controller.load();
      expect(controller.status.value, LoadStatus.error);
    });
  });

  group('HandleRequestController', () {
    late FakeRequestsProvider requests;
    late RecordingFeedback feedback;
    final now = DateTime(2026, 11, 12, 18);

    HandleRequestController build() => HandleRequestController(
      entry: Sample.entry(Sample.pendingRequest),
      requests: requests,
      feedback: feedback,
      clock: () => now,
    );

    setUp(() {
      requests = FakeRequestsProvider();
      feedback = RecordingFeedback();
    });

    test('toggle and toggleAll', () {
      final controller = build()..toggle(1);
      expect(controller.supplied, {1});
      controller.toggle(1);
      expect(controller.supplied, isEmpty);
      controller.toggleAll();
      expect(controller.allSelected, isTrue);
      controller.toggleAll();
      expect(controller.supplied, isEmpty);
    });

    test('complete splits supplied and not supplied lines', () async {
      final controller = build()
        ..toggle(0)
        ..toggle(2);
      controller.notesController.text = '  Ready Thursday  ';
      await controller.complete();

      final saved = requests.updated.single;
      final items = Sample.pendingRequest.items;
      expect(saved.isDone, isTrue);
      expect(saved.doneAt, now);
      expect(saved.doneItems, [items[0], items[2]]);
      expect(saved.leftItems, [items[1]]);
      expect(saved.doneMessage, 'Ready Thursday');
      expect(saved.items, items, reason: 'the original order is never rewritten');
      expect(feedback.successes, hasLength(1));
    });

    test('a failed save keeps the screen usable', () async {
      requests.fail = true;
      final controller = build();
      await controller.complete();
      expect(controller.isSubmitting.value, isFalse);
      expect(feedback.errors, hasLength(1));
    });
  });
}
