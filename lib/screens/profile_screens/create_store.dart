import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentication.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../models/store_model.dart';

class CreateNewStoreScreen extends StatefulWidget {
  const CreateNewStoreScreen({super.key});

  @override
  State<CreateNewStoreScreen> createState() => _CreateNewStoreScreenState();
}

class _CreateNewStoreScreenState extends State<CreateNewStoreScreen> {
  final AuthenticationService _auth = Get.find<AuthenticationService>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  List<XFile> imagesFileList = [];
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final List<XFile> selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages.isNotEmpty) {
      setState(() {
        imagesFileList.addAll(selectedImages);
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      imagesFileList.removeAt(index);
    });
  }

  Future<String?> uploadImage(XFile image) async {
    try {
      File file = File(image.path);
      return await _auth.uploadStoreImage(file, image.name);
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _handleCreateStore() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    // 1. Show persistent loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: [
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    AppStrings.creatingStore.tr,
                    style: GoogleFonts.abel(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Upload images if any
      List<String> urls = [];
      for (int i = 0; i < imagesFileList.length; i++) {
        String? url = await uploadImage(imagesFileList[i]);
        if (url != null) {
          urls.add(url);
        }
      }

      final currentUserId = _auth.getCurrentUser()?.id ?? '';
      final currentUser = await _auth.getUserById(currentUserId);
      final store = Store(
        storeOwnerUid: currentUser.uid,
        storeOwnerPhoneNumber: currentUser.phoneNumber,
        storeOwnerEmail: currentUser.email,
        storeName: _nameController.text.trim(),
        storeDetails: _descriptionController.text.trim(),
        storeLocation: _addressController.text.trim(),
        storePictures: urls,
        storeAdmins: [currentUser.uid],
        isApproved: true,
        isRestricted: false,
        storeId: '',
        storeOwner: currentUser.uid,
        storeOwnerPfp: currentUser.pfp,
      );

      await _auth.createStore(store);

      // Dismiss the loading dialog
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // 2. Show Success Dialog
      if (mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (successCtx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    AppStrings.storeCreated.tr,
                    style: GoogleFonts.abel(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            content: Text(
              AppStrings.storeCreatedSuccessfully.tr,
              style: GoogleFonts.abel(fontSize: 16),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.of(successCtx).pop(); // Close dialog
                },
                child: Text(
                  AppStrings.ok.tr,
                  style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        );

        // 3. Return to the Profile Screen
        if (mounted) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Get.back();
          }
        }
      }
    } catch (e) {
      // Dismiss the loading dialog if it is still showing
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      // Show error dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (errCtx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            title: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 28),
                const SizedBox(width: 10),
                Text(
                  AppStrings.error.tr,
                  style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              e.toString(),
              style: GoogleFonts.abel(fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(errCtx).pop(),
                child: Text(
                  AppStrings.ok.tr,
                  style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
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
            if (!_isCreating) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Get.back();
              }
            }
          },
        ),
        title: Text(
          AppStrings.createNewStore.tr,
          style: GoogleFonts.abel(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section: Store Images
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.images.tr,
                      style: GoogleFonts.abel(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.accentLight : AppColors.primary,
                      ),
                    ),
                    Text(
                      '${imagesFileList.length} ${imagesFileList.length == 1 ? AppStrings.item.tr : AppStrings.items.tr}',
                      style: GoogleFonts.abel(
                        fontSize: 13,
                        color: isDark ? Colors.white60 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Horizontal image picker container
                SizedBox(
                  height: 120,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: imagesFileList.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      // Add Button Card
                      if (index == imagesFileList.length) {
                        return GestureDetector(
                          onTap: _isCreating ? null : pickImage,
                          child: Container(
                            width: 110,
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_photo_alternate_rounded,
                                    size: 26,
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppStrings.addImages.tr,
                                  style: GoogleFonts.abel(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : AppColors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      // Picked Image Preview with remove badge
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: FileImage(File(imagesFileList[index].path)),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(color: borderColor),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: _isCreating ? null : () => removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Store Name
                TextFormField(
                  controller: _nameController,
                  enabled: !_isCreating,
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    labelText: AppStrings.storeName.tr,
                    labelStyle: GoogleFonts.abel(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                    prefixIcon: const Icon(Icons.storefront_rounded, color: AppColors.accent),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F363F) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.accent, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterStoreName.tr;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Store Address
                TextFormField(
                  controller: _addressController,
                  enabled: !_isCreating,
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    labelText: AppStrings.storeAddress.tr,
                    labelStyle: GoogleFonts.abel(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                    prefixIcon: const Icon(Icons.location_on_rounded, color: AppColors.accent),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F363F) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.accent, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterStoreAddress.tr;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 18),

                // Store Description
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isCreating,
                  maxLines: 4,
                  style: GoogleFonts.abel(
                    fontSize: 16,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                  decoration: InputDecoration(
                    labelText: AppStrings.storeDescription.tr,
                    labelStyle: GoogleFonts.abel(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                    ),
                    alignLabelWithHint: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(bottom: 50),
                      child: Icon(Icons.description_rounded, color: AppColors.accent),
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF0F363F) : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.accent, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppStrings.pleaseEnterStoreDescription.tr;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Submit Button
                ElevatedButton.icon(
                  onPressed: _isCreating ? null : _handleCreateStore,
                  icon: _isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.store_rounded, color: Colors.white, size: 22),
                  label: Text(
                    AppStrings.createStore.tr,
                    style: GoogleFonts.abel(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
