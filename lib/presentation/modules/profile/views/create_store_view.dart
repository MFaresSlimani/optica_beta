import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/validators.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/section_header.dart';
import '../controllers/create_store_controller.dart';

class CreateStoreView extends GetView<CreateStoreController> {
  const CreateStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.createNewStore.tr)),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: AppSpacing.sm, bottom: AppSpacing.xxl),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppSpacing.screen,
                child: Obx(
                  () => SectionHeader(
                    AppStrings.images.tr,
                    trailing: Text(
                      '${controller.photoPaths.length}/${CreateStoreController.maxPhotos}',
                      style: context.text.labelSmall,
                    ),
                  ),
                ),
              ),
              _PhotoStrip(controller: controller),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.gutter,
                  AppSpacing.sm,
                  AppSpacing.gutter,
                  0,
                ),
                child: Text(AppStrings.storePhotosHint.tr, style: context.text.bodySmall),
              ),
              const SizedBox(height: AppSpacing.xl),
              ConstrainedContent(
                child: Padding(
                  padding: AppSpacing.screen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        controller: controller.nameController,
                        label: AppStrings.storeName.tr,
                        icon: Icons.storefront_outlined,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => Validators.required(v, AppStrings.pleaseEnterStoreName),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: controller.addressController,
                        label: AppStrings.storeAddress.tr,
                        icon: Icons.place_outlined,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) =>
                            Validators.required(v, AppStrings.pleaseEnterStoreAddress),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppTextField(
                        controller: controller.descriptionController,
                        label: AppStrings.storeDescription.tr,
                        icon: Icons.notes_rounded,
                        maxLines: 5,
                        minLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (v) =>
                            Validators.required(v, AppStrings.pleaseEnterStoreDescription),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        child: Obx(
          () => AppButton(
            label: AppStrings.createStore.tr,
            icon: Icons.storefront_rounded,
            isLoading: controller.isCreating.value,
            onPressed: controller.create,
          ),
        ),
      ),
    );
  }
}

class _PhotoStrip extends StatelessWidget {
  const _PhotoStrip({required this.controller});

  final CreateStoreController controller;

  static const double _tile = 112;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SizedBox(
      height: _tile,
      child: Obx(() {
        final paths = controller.photoPaths;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: AppSpacing.screen,
          itemCount: paths.length + (controller.canAddPhotos ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
          itemBuilder: (_, index) {
            if (index == paths.length) {
              return Material(
                color: palette.accentSoft,
                borderRadius: AppRadius.lgAll,
                child: InkWell(
                  borderRadius: AppRadius.lgAll,
                  onTap: controller.addPhotos,
                  child: SizedBox(
                    width: _tile,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: palette.accent),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          AppStrings.addImages.tr,
                          style: context.text.labelMedium?.copyWith(color: palette.accent),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.lgAll,
                  child: Image.file(
                    File(paths[index]),
                    width: _tile,
                    height: _tile,
                    fit: BoxFit.cover,
                  ),
                ),
                PositionedDirectional(
                  top: AppSpacing.xs,
                  end: AppSpacing.xs,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => controller.removePhoto(index),
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.xs),
                        child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
