// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../authentication.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/request_model.dart';
import '../../models/store_model.dart';
import '../../models/user_model.dart';
import '../../notifications/notifications.dart';
import '../../widgets/list_view_wheel.dart';
import '../../widgets/picker.dart';

class GlassesItem {
  final String type;
  final double cyl;
  final double sph;
  int quantity;

  GlassesItem({
    required this.type,
    required this.cyl,
    required this.sph,
    required this.quantity,
  });

  bool matches(String otherType, double otherCyl, double otherSph) {
    return type.trim().toLowerCase() == otherType.trim().toLowerCase() &&
        (cyl - otherCyl).abs() < 0.001 &&
        (sph - otherSph).abs() < 0.001;
  }

  String toFormattedString() {
    final cylFormatted = cyl >= 0
        ? '+${cyl.toStringAsFixed(2)}'
        : cyl.toStringAsFixed(2);
    final sphFormatted = sph >= 0
        ? '+${sph.toStringAsFixed(2)}'
        : sph.toStringAsFixed(2);

    return '$type\n CYL: $cylFormatted,\t\t\t SPH: $sphFormatted (x$quantity)';
  }

  static GlassesItem? fromFormattedString(String str) {
    try {
      final cylIndex = str.indexOf("CYL");
      final bracketIndex = str.indexOf("(x");
      if (cylIndex == -1 || bracketIndex == -1) return null;

      final type = str.substring(0, cylIndex).trim();

      final endBracket = str.indexOf(")", bracketIndex);
      final qtySub = endBracket != -1
          ? str.substring(bracketIndex + 2, endBracket).trim()
          : str.substring(bracketIndex + 2).trim();
      final qty = int.tryParse(qtySub) ?? 1;

      final middle = str.substring(cylIndex, bracketIndex);
      final cylMatch = RegExp(r'CYL:\s*([+-]?\d+(?:\.\d+)?)').firstMatch(middle);
      final sphMatch = RegExp(r'SPH:\s*([+-]?\d+(?:\.\d+)?)').firstMatch(middle);

      double parseVal(String? s) {
        if (s == null) return 0.0;
        final clean = s.startsWith('+') ? s.substring(1) : s;
        return double.tryParse(clean) ?? 0.0;
      }

      final cylVal = parseVal(cylMatch?.group(1));
      final sphVal = parseVal(sphMatch?.group(1));

      return GlassesItem(
        type: type,
        cyl: cylVal,
        sph: sphVal,
        quantity: qty,
      );
    } catch (_) {
      return null;
    }
  }
}

class GlassesController extends GetxController {
  RxString selectedType = 'HCT 1.56'.obs;
  RxDouble cylValue = 0.0.obs;
  RxDouble sphValue = 0.0.obs;
  RxInt quantity = 1.obs;
  RxBool isSubmitting = false.obs;
  RxList<String> glassesList = <String>[].obs;

  int get totalGlassesCount {
    int total = 0;
    for (final item in glassesList) {
      final parsed = GlassesItem.fromFormattedString(item);
      total += parsed?.quantity ?? 1;
    }
    return total;
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    } else {
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.quantityCannotBeLessThan1.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void selectType(String type) {
    selectedType.value = type;
  }

  void addGlassesToList(String storeId) {
    final type = selectedType.value;
    final cyl = cylValue.value;
    final sph = sphValue.value;
    final addQty = quantity.value;

    int existingIndex = -1;
    GlassesItem? existingItem;

    for (int i = 0; i < glassesList.length; i++) {
      final parsed = GlassesItem.fromFormattedString(glassesList[i]);
      if (parsed != null && parsed.matches(type, cyl, sph)) {
        existingIndex = i;
        existingItem = parsed;
        break;
      }
    }

    if (existingIndex != -1 && existingItem != null) {
      existingItem.quantity += addQty;
      glassesList[existingIndex] = existingItem.toFormattedString();
    } else {
      final newItem = GlassesItem(
        type: type,
        cyl: cyl,
        sph: sph,
        quantity: addQty,
      );
      glassesList.add(newItem.toFormattedString());
    }

    saveGlassesListToHive(storeId);
    quantity.value = 1;
  }

  void removeGlassesFromList(int index, String storeId) {
    if (index >= 0 && index < glassesList.length) {
      glassesList.removeAt(index);
      saveGlassesListToHive(storeId);
    }
  }

  Future<void> saveGlassesListToHive(String storeId) async {
    try {
      final box = await Hive.openBox('glassesBox');
      await box.put(storeId, glassesList.toList());
    } catch (e) {
      debugPrint('Hive save error: $e');
    }
  }

  Future<void> getGlassesListFromHive(String storeId) async {
    try {
      final box = await Hive.openBox('glassesBox');
      final stored = box.get(storeId);
      if (stored != null) {
        final rawList = List<String>.from(stored);
        final consolidated = <GlassesItem>[];
        for (final str in rawList) {
          final item = GlassesItem.fromFormattedString(str);
          if (item != null) {
            final idx = consolidated.indexWhere(
              (c) => c.matches(item.type, item.cyl, item.sph),
            );
            if (idx != -1) {
              consolidated[idx].quantity += item.quantity;
            } else {
              consolidated.add(item);
            }
          }
        }

        if (consolidated.isNotEmpty) {
          glassesList.assignAll(consolidated.map((e) => e.toFormattedString()).toList());
        } else {
          glassesList.assignAll(rawList);
        }
      }
    } catch (e) {
      debugPrint('Hive get error: $e');
    }
  }
}

class GlassesScreen extends StatefulWidget {
  final Store store;
  const GlassesScreen({required this.store, super.key});

  @override
  State<GlassesScreen> createState() => _GlassesScreenState();
}

class _GlassesScreenState extends State<GlassesScreen> {
  late final GlassesController glassesController;

  @override
  void initState() {
    super.initState();
    glassesController = Get.isRegistered<GlassesController>()
        ? Get.find<GlassesController>()
        : Get.put(GlassesController());
    glassesController.getGlassesListFromHive(widget.store.storeId);
  }

  void _sendNotificationInBackground(
    AuthenticationService auth,
    String currentUserId,
    String storeOwnerUid,
  ) async {
    try {
      AppUser buyer = await auth.getUserById(currentUserId);
      await NotificationController.sendNotificationToUser(
        storeOwnerUid,
        'New Order',
        'You have a new order from ${buyer.username}',
      );
    } catch (e) {
      debugPrint('Notification background send error: $e');
    }
  }

  Future<void> _submitOrder() async {
    if (glassesController.glassesList.isEmpty) return;

    try {
      glassesController.isSubmitting.value = true;
      final AuthenticationService auth = Get.find<AuthenticationService>();
      final currentUserId = auth.getCurrentUser()?.id ?? '';

      final request = Request(
        id: '',
        storeId: widget.store.storeId,
        senderUid: currentUserId,
        receiverUid: widget.store.storeOwnerUid,
        description: List<String>.from(glassesController.glassesList),
        doneGlasses: [],
        leftGlasses: [],
        isDone: false,
        createdAt: DateTime.now(),
        doneMessage: '',
        doneAt: null,
      );

      await auth.createRequest(request);

      // Clear local list and Hive cache for this store
      glassesController.glassesList.clear();
      final box = await Hive.openBox('glassesBox');
      await box.delete(widget.store.storeId);

      // Instantly navigate back to the Store Details screen
      if (mounted) {
        Navigator.of(context).pop();
      } else {
        Get.back();
      }

      // Display success snackbar on the store details screen
      Get.snackbar(
        AppStrings.done.tr,
        AppStrings.requestSentSuccessfully.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.accent.withValues(alpha: 0.9),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Send push notification to store owner in the background without blocking UI
      _sendNotificationInBackground(auth, currentUserId, widget.store.storeOwnerUid);
    } catch (e) {
      Get.snackbar(
        AppStrings.error.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      glassesController.isSubmitting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF0F363F) : Colors.white;
    final borderColor = isDark
        ? AppColors.accent.withValues(alpha: 0.25)
        : Colors.brown.shade200;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : AppColors.primary,
            size: 20,
          ),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.back();
            }
          },
        ),
        title: Text(
          AppStrings.makeOrder.tr,
          style: GoogleFonts.abel(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? Colors.white70 : AppColors.primary,
            ),
            tooltip: AppStrings.reloadSavedItems.tr,
            onPressed: () => glassesController.getGlassesListFromHive(widget.store.storeId),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Store Header Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.storefront_rounded,
                        color: AppColors.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.store.tr,
                            style: GoogleFonts.abel(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            widget.store.storeName,
                            style: GoogleFonts.abel(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // 2. Lens Type Selection
              Text(
                AppStrings.typeOfGlasses.tr,
                style: GoogleFonts.abel(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.accentLight : AppColors.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const SizedBox(
                height: 48,
                child: ListViewWheel(),
              ),

              const SizedBox(height: 18),

              // 3. CYL & SPH Pickers
              Row(
                children: [
                  Expanded(
                    child: Picker(
                      title: AppStrings.cyl.tr,
                      overall: glassesController.cylValue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Picker(
                      title: AppStrings.sph.tr,
                      overall: glassesController.sphValue,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // 4. Parameter Preview & Quantity Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: borderColor, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.selectedParameters.tr,
                          style: GoogleFonts.abel(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.backgroundDark.withValues(alpha: 0.5)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${glassesController.selectedType.value}   |   ${AppStrings.cyl.tr}: ${glassesController.cylValue.value >= 0 ? '+' : ''}${glassesController.cylValue.value.toStringAsFixed(2)}   |   ${AppStrings.sph.tr}: ${glassesController.sphValue.value >= 0 ? '+' : ''}${glassesController.sphValue.value.toStringAsFixed(2)}',
                                style: GoogleFonts.abel(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : AppColors.primary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Quantity Stepper & Add Button Row
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.backgroundDark.withValues(alpha: 0.6)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: isDark ? Colors.white : AppColors.primary,
                                ),
                                onPressed: glassesController.decrementQuantity,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Obx(
                                  () => Text(
                                    glassesController.quantity.value.toString(),
                                    style: GoogleFonts.abel(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: isDark ? Colors.white : AppColors.primary,
                                ),
                                onPressed: glassesController.incrementQuantity,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              glassesController.addGlassesToList(widget.store.storeId);
                            },
                            icon: const Icon(Icons.add_shopping_cart_rounded, size: 20, color: Colors.white),
                            label: Text(
                              AppStrings.addGlassesToList.tr,
                              style: GoogleFonts.abel(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              elevation: 2,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 5. Glasses in Order List
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.orderItems.tr,
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.accentLight : AppColors.primary,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${glassesController.totalGlassesCount} ${glassesController.totalGlassesCount == 1 ? AppStrings.glass.tr : AppStrings.glasses.tr} (${glassesController.glassesList.length} ${glassesController.glassesList.length == 1 ? AppStrings.type.tr : AppStrings.types.tr})',
                      style: GoogleFonts.abel(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Obx(
                () {
                  if (glassesController.glassesList.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
                      decoration: BoxDecoration(
                        color: cardBg.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.playlist_add_rounded,
                            size: 40,
                            color: isDark ? Colors.white38 : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppStrings.noGlassesAddedYet.tr,
                            style: GoogleFonts.abel(
                              fontSize: 16,
                              color: isDark ? Colors.white60 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: borderColor, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: glassesController.glassesList.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: borderColor.withValues(alpha: 0.5),
                      ),
                      itemBuilder: (context, index) {
                        final itemStr = glassesController.glassesList[index];
                        final parsed = GlassesItem.fromFormattedString(itemStr);
                        final itemQty = parsed?.quantity ?? 1;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                            child: Text(
                              '$itemQty',
                              style: GoogleFonts.abel(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                          title: Text(
                            parsed?.type ?? itemStr,
                            style: GoogleFonts.abel(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.primary,
                            ),
                          ),
                          subtitle: parsed != null
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    '${AppStrings.cyl.tr}: ${parsed.cyl >= 0 ? '+' : ''}${parsed.cyl.toStringAsFixed(2)}   •   ${AppStrings.sph.tr}: ${parsed.sph >= 0 ? '+' : ''}${parsed.sph.toStringAsFixed(2)}',
                                    style: GoogleFonts.abel(
                                      fontSize: 14,
                                      color: isDark ? AppColors.accentLight : Colors.brown,
                                    ),
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.redAccent,
                              size: 22,
                            ),
                            tooltip: AppStrings.remove.tr,
                            onPressed: () {
                              glassesController.removeGlassesFromList(
                                index,
                                widget.store.storeId,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // 6. Submit Button
              Obx(
                () {
                  if (glassesController.glassesList.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return ElevatedButton.icon(
                    onPressed: glassesController.isSubmitting.value
                        ? null
                        : _submitOrder,
                    icon: glassesController.isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    label: Text(
                      AppStrings.submitSelection.tr,
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF09242A) : Colors.brown,
                      side: BorderSide(
                        color: isDark ? AppColors.accent : Colors.brown,
                        width: 1.2,
                      ),
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 3,
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
