import 'package:get/get.dart';

import '../../../../data/models/store.dart';
import '../controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    final store = Get.arguments as Store;
    Get.lazyPut(() => OrderController(store: store));
  }
}
