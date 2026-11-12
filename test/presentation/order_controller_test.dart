import 'package:bng_optica/data/models/diopter.dart';
import 'package:bng_optica/presentation/modules/order/controllers/order_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fakes.dart';
import '../helpers/sample_data.dart';

void main() {
  late FakeRequestsProvider requests;
  late FakeOrderDraftProvider drafts;
  late RecordingFeedback feedback;
  final now = DateTime(2026, 11, 12, 10);

  OrderController build() {
    final controller = OrderController(
      store: Sample.visionPlus,
      requests: requests,
      drafts: drafts,
      session: signedInSession(Sample.optician),
      feedback: feedback,
      clock: () => now,
    )..onInit();
    return controller;
  }

  setUp(() {
    Get.testMode = true;
    requests = FakeRequestsProvider();
    drafts = FakeOrderDraftProvider();
    feedback = RecordingFeedback();
  });

  test('restores and consolidates a saved draft for this store', () {
    final line = Sample.orderLines.first;
    drafts.drafts[Sample.visionPlus.id] = [line, line];
    final controller = build();
    expect(controller.lines.single.quantity, line.quantity * 2);
  });

  test('adds the current selection and resets quantity', () {
    final controller = build()
      ..selectLensType('HMC 1.67')
      ..onSphereIndexChanged(OrderController.indexOf(Diopter.fromValue(-3)))
      ..onCylinderIndexChanged(OrderController.indexOf(Diopter.fromValue(-0.75)))
      ..incrementQuantity()
      ..incrementQuantity()
      ..addLine();

    final line = controller.lines.single;
    expect(line.type, 'HMC 1.67');
    expect(line.sphere.format(), '-3.00');
    expect(line.cylinder.format(), '-0.75');
    expect(line.quantity, 3);
    expect(controller.quantity.value, 1);
    expect(drafts.drafts[Sample.visionPlus.id], controller.lines);
  });

  test('adding the same lens twice merges instead of duplicating', () {
    final controller = build()
      ..addLine()
      ..incrementQuantity()
      ..addLine();
    expect(controller.lines, hasLength(1));
    expect(controller.totalQuantity, 3);
  });

  test('quantity never goes below one', () {
    final controller = build()..decrementQuantity();
    expect(controller.quantity.value, 1);
  });

  test('removing a line updates the draft', () {
    final controller = build()
      ..addLine()
      ..removeLine(0);
    expect(controller.lines, isEmpty);
    expect(drafts.drafts, isEmpty);
  });

  test('submit sends one request to the store owner and clears the draft', () async {
    final controller = build()..addLine();
    await controller.submit();

    final sent = requests.created.single;
    expect(sent.senderUid, Sample.optician.uid);
    expect(sent.receiverUid, Sample.visionPlus.ownerUid);
    expect(sent.storeId, Sample.visionPlus.id);
    expect(sent.createdAt, now);
    expect(sent.isDone, isFalse);
    expect(controller.lines, isEmpty);
    expect(drafts.drafts, isEmpty);
    expect(feedback.successes, hasLength(1));
  });

  test('a failed submit keeps the order and reports the error', () async {
    requests.fail = true;
    final controller = build()..addLine();
    await controller.submit();
    expect(controller.lines, hasLength(1));
    expect(controller.isSubmitting.value, isFalse);
    expect(feedback.errors, hasLength(1));
  });

  test('cannot submit an empty order', () async {
    await build().submit();
    expect(requests.created, isEmpty);
  });
}
