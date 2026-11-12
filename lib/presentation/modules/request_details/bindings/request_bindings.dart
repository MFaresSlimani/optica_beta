import 'package:get/get.dart';

import '../../../../data/models/request_entry.dart';
import '../../printing/controllers/printing_controller.dart';
import '../controllers/handle_request_controller.dart';
import '../controllers/request_details_controller.dart';

class RequestDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final entry = Get.arguments as RequestEntry;
    Get.lazyPut(() => RequestDetailsController(entry: entry));
  }
}

class HandleRequestBinding extends Bindings {
  @override
  void dependencies() {
    final entry = Get.arguments as RequestEntry;
    Get.lazyPut(() => HandleRequestController(entry: entry));
  }
}

class PrintingBinding extends Bindings {
  @override
  void dependencies() {
    final entry = Get.arguments as RequestEntry;
    Get.lazyPut(() => PrintingController(entry: entry));
  }
}
