import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await controller.confirmLeave()) Get.back<void>();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.editProfile.tr)),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.lg,
            AppSpacing.gutter,
            AppSpacing.xxl,
          ),
          child: ConstrainedContent(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: _AvatarPicker(controller: controller)),
                  const SizedBox(height: AppSpacing.xxl),
                  AppTextField(
                    controller: controller.nameController,
                    label: AppStrings.name.tr,
                    icon: Icons.person_outline_rounded,
                    textCapitalization: TextCapitalization.words,
                    onChanged: controller.onEdited,
                    validator: (v) => Validators.required(v, AppStrings.pleaseEnterName),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: AppStrings.email.tr,
                    initialValue: controller.original.email,
                    icon: Icons.alternate_email_rounded,
                    readOnly: true,
                    enabled: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    controller: controller.phoneController,
                    label: AppStrings.phoneNumber.tr,
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onChanged: controller.onEdited,
                    validator: Validators.optionalPhone,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomActionBar(
          child: Obx(
            () => AppButton(
              label: AppStrings.save.tr,
              icon: Icons.check_rounded,
              isLoading: controller.isSaving.value,
              onPressed: controller.hasChanges ? controller.save : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.controller});

  final EditProfileController controller;

  Future<void> _chooseSource() async {
    final source = await Get.bottomSheet<ImageSource>(
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: Text(AppStrings.takePhoto.tr),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(AppStrings.chooseFromGallery.tr),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
    if (source != null) await controller.pickImage(source);
  }

  @override
  Widget build(BuildContext context) {
    final original = controller.original;
    return GestureDetector(
      onTap: _chooseSource,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Obx(() {
            final picked = controller.pickedImagePath.value;
            if (picked == null) {
              return Hero(
                tag: 'avatar-${original.uid}',
                child: UserAvatar(
                  name: original.displayName,
                  imageUrl: original.pfp,
                  radius: 52,
                  ring: true,
                ),
              );
            }
            return Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: context.palette.accent, width: 2),
              ),
              child: CircleAvatar(radius: 52, backgroundImage: FileImage(File(picked))),
            );
          }),
          PositionedDirectional(
            bottom: 0,
            end: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: context.palette.accent,
                shape: BoxShape.circle,
                border: Border.all(color: context.colors.surface, width: 3),
              ),
              child: Icon(Icons.photo_camera_rounded, size: 18, color: context.palette.onAccent),
            ),
          ),
        ],
      ),
    );
  }
}
