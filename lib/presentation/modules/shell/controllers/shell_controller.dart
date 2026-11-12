import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum ShellTab { stores, requests, profile, settings }

class ShellController extends GetxController {
  final Rx<ShellTab> tab = ShellTab.stores.obs;

  void select(int index) {
    final next = ShellTab.values[index];
    if (next == tab.value) return;
    HapticFeedback.selectionClick();
    tab.value = next;
  }
}
