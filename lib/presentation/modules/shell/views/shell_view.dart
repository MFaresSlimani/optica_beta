import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../requests/controllers/requests_controller.dart';
import '../../requests/views/requests_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/shell_controller.dart';

/// Bottom-tab home. Tabs keep their state (IndexedStack).
class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final requests = Get.find<RequestsController>();
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.tab.value.index,
          children: const [HomeView(), RequestsView(), ProfileView(), SettingsView()],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.tab.value.index,
          onDestinationSelected: controller.select,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.storefront_outlined),
              selectedIcon: const Icon(Icons.storefront_rounded),
              label: AppStrings.stores.tr,
            ),
            NavigationDestination(
              icon: Badge.count(
                count: requests.pendingReceivedCount,
                isLabelVisible: requests.pendingReceivedCount > 0,
                child: const Icon(Icons.receipt_long_outlined),
              ),
              selectedIcon: Badge.count(
                count: requests.pendingReceivedCount,
                isLabelVisible: requests.pendingReceivedCount > 0,
                child: const Icon(Icons.receipt_long_rounded),
              ),
              label: AppStrings.requests.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline_rounded),
              selectedIcon: const Icon(Icons.person_rounded),
              label: AppStrings.profile.tr,
            ),
            NavigationDestination(
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: const Icon(Icons.tune_rounded),
              label: AppStrings.settings.tr,
            ),
          ],
        ),
      ),
    );
  }
}
