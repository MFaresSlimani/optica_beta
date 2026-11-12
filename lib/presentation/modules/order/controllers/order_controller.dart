import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/utils/lens_order.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/diopter.dart';
import '../../../../data/models/glasses_request.dart';
import '../../../../data/models/lens_item.dart';
import '../../../../data/models/store.dart';
import '../../../../data/providers/order_draft_provider.dart';
import '../../../../data/providers/requests_provider.dart';
import '../../../services/feedback_service.dart';

/// Builds a glasses order for one store. The draft is saved on every change.
class OrderController extends GetxController {
  OrderController({
    required this.store,
    RequestsProvider? requests,
    OrderDraftProvider? drafts,
    SessionService? session,
    FeedbackService? feedback,
    DateTime Function()? clock,
  }) : _requests = requests ?? Get.find<RequestsProvider>(),
       _drafts = drafts ?? Get.find<OrderDraftProvider>(),
       _session = session ?? Get.find<SessionService>(),
       _feedback = feedback ?? Get.find<FeedbackService>(),
       _clock = clock ?? DateTime.now;

  final Store store;
  final RequestsProvider _requests;
  final OrderDraftProvider _drafts;
  final SessionService _session;
  final FeedbackService _feedback;
  final DateTime Function() _clock;

  /// Every selectable power, ascending (index 0 = most negative).
  static final List<Diopter> powers = Diopter.range(LensCatalog.maxQuarterSteps);
  static int indexOf(Diopter value) => value.quarters + LensCatalog.maxQuarterSteps;

  final Rx<String> lensType = LensCatalog.types.first.obs;
  final Rx<Diopter> sphere = Diopter.zero.obs;
  final Rx<Diopter> cylinder = Diopter.zero.obs;
  final RxInt quantity = 1.obs;
  final RxList<LensItem> lines = <LensItem>[].obs;
  final RxBool isSubmitting = false.obs;

  late final FixedExtentScrollController sphereWheel = FixedExtentScrollController(
    initialItem: indexOf(sphere.value),
  );
  late final FixedExtentScrollController cylinderWheel = FixedExtentScrollController(
    initialItem: indexOf(cylinder.value),
  );

  int get totalQuantity => LensOrder.totalQuantity(lines);
  bool get canSubmit => lines.isNotEmpty && !isSubmitting.value;

  @override
  void onInit() {
    super.onInit();
    lines.assignAll(LensOrder.consolidate(_drafts.load(store.id)));
  }

  void selectLensType(String type) => lensType.value = type;
  void onSphereIndexChanged(int index) => sphere.value = powers[index];
  void onCylinderIndexChanged(int index) => cylinder.value = powers[index];

  void incrementQuantity() => quantity.value++;

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  /// Adds the current selection, merging with an identical line.
  void addLine() {
    final item = LensItem(
      type: lensType.value,
      sphere: sphere.value,
      cylinder: cylinder.value,
      quantity: quantity.value,
    );
    lines.assignAll(LensOrder.add(lines, item));
    quantity.value = 1;
    _persist();
  }

  void removeLine(int index) {
    if (index < 0 || index >= lines.length) return;
    lines.removeAt(index);
    _persist();
  }

  void _persist() => unawaited(_drafts.save(store.id, lines.toList()));

  Future<void> submit() async {
    final uid = _session.uid;
    if (!canSubmit || uid == null) return;
    isSubmitting.value = true;
    try {
      await _requests.createRequest(
        GlassesRequest(
          id: '',
          senderUid: uid,
          receiverUid: store.ownerUid,
          storeId: store.id,
          items: lines.toList(),
          createdAt: _clock(),
        ),
      );
      await _drafts.clear(store.id);
      lines.clear();
      Get.back<void>();
      _feedback.showSuccess(AppStrings.requestSentSuccessfully.tr);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    sphereWheel.dispose();
    cylinderWheel.dispose();
    super.onClose();
  }
}
