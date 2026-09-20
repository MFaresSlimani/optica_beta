import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../authentication.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class EditProfileInfoScreen extends StatefulWidget {
  const EditProfileInfoScreen({super.key});

  @override
  State<EditProfileInfoScreen> createState() => _EditProfileInfoScreenState();
}

class _EditProfileInfoScreenState extends State<EditProfileInfoScreen> {
  final AuthenticationService _auth = AuthenticationService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _profilePictureController = TextEditingController();
  File? _pfpImage;
  bool _isLoading = true;
  bool _isSaving = false;

  // Track original values for unsaved-changes detection
  String _originalName = '';
  String _originalPhone = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUid = _auth.getCurrentUser()?.id ?? '';
    if (currentUid.isEmpty) return;
    try {
      final user = await _auth.getUserById(currentUid);
      _nameController.text = user.username;
      _phoneNumberController.text = user.phoneNumber;
      _profilePictureController.text = user.pfp;
      _originalName = user.username;
      _originalPhone = user.phoneNumber;
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  bool get _hasUnsavedChanges {
    return _nameController.text != _originalName ||
        _phoneNumberController.text != _originalPhone ||
        _pfpImage != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _profilePictureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (_hasUnsavedChanges) {
          final shouldLeave = await _showDiscardDialog();
          if (shouldLeave == true && context.mounted) {
            Navigator.of(context).pop();
          }
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppStrings.editProfile.tr,
            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.loading.tr,
                      style: GoogleFonts.outfit(
                        color: isDark ? AppColors.textMuted : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ── Profile Picture ──────────────────────
                      _buildAvatarPicker(isDark),
                      const SizedBox(height: 32),

                      // ── Name Field ───────────────────────────
                      _buildTextField(
                        controller: _nameController,
                        label: AppStrings.name.tr,
                        icon: Icons.badge_outlined,
                        isDark: isDark,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.pleaseEnterName.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // ── Email (read-only) ────────────────────
                      _buildTextField(
                        controller: null,
                        label: AppStrings.email.tr,
                        icon: Icons.email_outlined,
                        isDark: isDark,
                        readOnly: true,
                        initialValue: _auth.getCurrentUser()?.email ?? '',
                      ),
                      const SizedBox(height: 16),

                      // ── Phone Number ─────────────────────────
                      _buildTextField(
                        controller: _phoneNumberController,
                        label: AppStrings.phoneNumber.tr,
                        icon: Icons.phone_outlined,
                        isDark: isDark,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.pleaseEnterPhoneNumber.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      // ── Save Button ──────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _handleSave,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                AppColors.accent.withValues(alpha: 0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isSaving
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      AppStrings.saving.tr,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  AppStrings.save.tr,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // ─── Avatar Picker ─────────────────────────────────────────────────
  Widget _buildAvatarPicker(bool isDark) {
    final hasNetworkImage = _profilePictureController.text.isNotEmpty;
    final hasLocalImage = _pfpImage != null;

    ImageProvider? imageProvider;
    if (hasLocalImage) {
      imageProvider = FileImage(_pfpImage!);
    } else if (hasNetworkImage) {
      imageProvider = NetworkImage(_profilePictureController.text);
    }

    return GestureDetector(
      onTap: _showPhotoOptions,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 52,
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.grey[200],
              backgroundImage: imageProvider ??
                  const AssetImage('assets/profile.jpg'),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.primaryDark : Colors.white,
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Text Field Builder ────────────────────────────────────────────
  Widget _buildTextField({
    TextEditingController? controller,
    required String label,
    required IconData icon,
    required bool isDark,
    bool readOnly = false,
    String? initialValue,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      readOnly: readOnly,
      enabled: !readOnly,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.outfit(
        fontSize: 15,
        color: readOnly
            ? (isDark ? AppColors.textSubtle : Colors.grey[400])
            : (isDark ? AppColors.textLight : Colors.grey[900]),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(
          color: isDark ? AppColors.textMuted : Colors.grey[500],
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: readOnly
              ? (isDark ? AppColors.textSubtle : Colors.grey[300])
              : AppColors.accent,
        ),
        filled: true,
        fillColor: isDark ? AppColors.inputFill : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.inputBorder : Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.inputBorder : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.inputBorder.withValues(alpha: 0.3)
                : Colors.grey.shade100,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // ─── Photo Options Bottom Sheet ────────────────────────────────────
  void _showPhotoOptions() {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.textSubtle : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: Text(
                    AppStrings.takePhoto.tr,
                    style: GoogleFonts.outfit(),
                  ),
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(
                    AppStrings.chooseFromGallery.tr,
                    style: GoogleFonts.outfit(),
                  ),
                  onTap: () {
                    Get.back();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Image Picker ──────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final selectedImage = await ImagePicker().pickImage(source: source);
      if (selectedImage == null) return;
      setState(() {
        _pfpImage = File(selectedImage.path);
      });
    } on PlatformException catch (_) {
      // Image picker permission denied or not available
    }
  }

  // ─── Save Handler ──────────────────────────────────────────────────
  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    HapticFeedback.lightImpact();
    setState(() => _isSaving = true);

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                AppStrings.savingProfile.tr,
                style: GoogleFonts.outfit(),
              ),
            ),
          ],
        ),
      ),
    );

    try {
      // Upload new image if selected
      String? pfpUrl;
      if (_pfpImage != null) {
        pfpUrl = await _uploadImage(XFile(_pfpImage!.path));
      }

      if (pfpUrl != null && pfpUrl.isNotEmpty) {
        _profilePictureController.text = pfpUrl;
      }

      await _auth.updateProfile(
        username: _nameController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        pfp: _profilePictureController.text,
      );

      // Dismiss loading dialog
      if (mounted) Get.back();

      // Show success dialog
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
              size: 48,
            ),
            title: Text(
              AppStrings.success.tr,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            content: Text(
              AppStrings.updateProfileSuccess.tr,
              style: GoogleFonts.outfit(),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  AppStrings.ok.tr,
                  style: GoogleFonts.outfit(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );

        // Navigate back after success
        if (mounted) Get.back();
      }
    } catch (e) {
      // Dismiss loading dialog
      if (mounted) Get.back();

      // Show error snackbar
      Get.snackbar(
        AppStrings.error.tr,
        AppStrings.updateProfileError.tr,
        backgroundColor: AppColors.error.withValues(alpha: 0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─── Upload Image ──────────────────────────────────────────────────
  Future<String?> _uploadImage(XFile image) async {
    try {
      File file = File(image.path);
      return await _auth.uploadProfileImage(file, image.name);
    } catch (_) {
      return null;
    }
  }

  // ─── Discard Changes Dialog ────────────────────────────────────────
  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          AppStrings.discardChanges.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        content: Text(
          AppStrings.discardChangesMessage.tr,
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              AppStrings.cancel.tr,
              style: GoogleFonts.outfit(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textMuted
                    : Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              AppStrings.confirm.tr,
              style: GoogleFonts.outfit(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
