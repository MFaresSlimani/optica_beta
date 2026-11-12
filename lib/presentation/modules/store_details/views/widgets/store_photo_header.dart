import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../widgets/brand_visuals.dart';
import '../../controllers/store_details_controller.dart';

/// Collapsing photo header: swipeable gallery with page dots.
class StorePhotoHeader extends StatelessWidget {
  const StorePhotoHeader({super.key, required this.controller});

  final StoreDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final store = controller.store;
    final pictures = store.pictures;
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: context.colors.primary,
      foregroundColor: Colors.white,
      leading: const Padding(padding: EdgeInsets.all(AppSpacing.sm), child: _GlassBackButton()),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (pictures.isEmpty)
              Hero(
                tag: 'store-cover-${store.id}',
                child: StoreCoverFallback(name: store.name),
              )
            else
              PageView.builder(
                itemCount: pictures.length,
                onPageChanged: controller.onPhotoChanged,
                itemBuilder: (_, index) {
                  final image = StoreImage(url: pictures[index], storeName: store.name);
                  return GestureDetector(
                    onTap: () => controller.openGallery(index),
                    child: index == 0 ? Hero(tag: 'store-cover-${store.id}', child: image) : image,
                  );
                },
              ),
            // Top scrim keeps the back button legible on bright photos.
            const IgnorePointer(
              child: DecoratedBox(decoration: BoxDecoration(gradient: AppColors.photoTopScrim)),
            ),
            if (pictures.length > 1)
              Positioned(
                bottom: AppSpacing.lg,
                left: 0,
                right: 0,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < pictures.length; i++)
                        AnimatedContainer(
                          duration: AppDurations.medium,
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
                          width: i == controller.photoIndex.value
                              ? AppSpacing.lg + AppSpacing.xs
                              : AppSpacing.sm - 2,
                          height: AppSpacing.sm - 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(
                              alpha: i == controller.photoIndex.value ? 1 : 0.5,
                            ),
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GlassBackButton extends StatelessWidget {
  const _GlassBackButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.28),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: Get.back<void>,
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        icon: const BackButtonIcon(),
        color: Colors.white,
      ),
    );
  }
}
