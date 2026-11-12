import 'package:get/get.dart';

import '../../../../data/models/store.dart';
import '../controllers/store_details_controller.dart';

class StoreDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final store = Get.arguments as Store;
    Get.lazyPut(() => StoreDetailsController(store: store));
  }
}
