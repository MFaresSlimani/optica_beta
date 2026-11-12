import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/lens_order.dart';
import '../../../../data/models/data_exception.dart';
import '../../../../data/models/request_entry.dart';
import '../../../../data/providers/requests_provider.dart';
import '../../../services/feedback_service.dart';

/// The store owner ticks what they can supply and completes the request.
class HandleRequestController extends GetxController {
  HandleRequestController({
    required this.entry,
    RequestsProvider? requests,
    FeedbackService? feedback,
    DateTime Function()? clock,
  }) : _requests = requests ?? Get.find<RequestsProvider>(),
       _feedback = feedback ?? Get.find<FeedbackService>(),
       _clock = clock ?? DateTime.now;

  final RequestEntry entry;
  final RequestsProvider _requests;
  final FeedbackService _feedback;
  final DateTime Function() _clock;

  final notesController = TextEditingController();
  final RxSet<int> supplied = <int>{}.obs;
  final RxBool isSubmitting = false.obs;

  int get total => entry.request.items.length;
  bool get allSelected => supplied.length == total;

  void toggle(int index) {
    if (!supplied.remove(index)) supplied.add(index);
  }

  void toggleAll() {
    if (allSelected) {
      supplied.clear();
    } else {
      supplied.assignAll(List.generate(total, (i) => i));
    }
  }

  Future<void> complete() async {
    if (isSubmitting.value) return;
    isSubmitting.value = true;
    final split = LensOrder.split(entry.request.items, supplied);
    final updated = entry.request.copyWith(
      isDone: true,
      doneAt: _clock(),
      doneItems: split.done,
      leftItems: split.left,
      doneMessage: notesController.text.trim(),
    );
    try {
      await _requests.updateRequest(updated);
      Get.back<RequestEntry>(result: entry.withRequest(updated));
      _feedback.showSuccess(AppStrings.requestCompleted.tr);
    } on DataException catch (e) {
      _feedback.showError(e.message);
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
