import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/surface_card.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/store_details_controller.dart';
import 'widgets/store_photo_header.dart';

class StoreDetailsView extends GetView<StoreDetailsController> {
  const StoreDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final store = controller.store;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            StorePhotoHeader(controller: controller),
            SliverToBoxAdapter(
              child: ConstrainedContent(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xl,
                    AppSpacing.gutter,
                    AppSpacing.xxl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(store.name, style: context.text.headlineSmall),
                      if (store.location.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          children: [
                            Icon(Icons.place_outlined, size: 18, color: context.palette.accent),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(child: Text(store.location, style: context.text.bodyMedium)),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(AppStrings.aboutStore.tr),
                      SurfaceCard(
                        child: Text(
                          store.details.trim().isEmpty
                              ? AppStrings.noDescription.tr
                              : store.details,
                          style: context.text.bodyLarge,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      SectionHeader(AppStrings.owner.tr),
                      _OwnerCard(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomActionBar(
          child: controller.isOwner
              ? Obx(
                  () => AppButton(
                    label: AppStrings.deleteStore.tr,
                    icon: Icons.delete_outline_rounded,
                    variant: AppButtonVariant.destructive,
                    isLoading: controller.isDeleting.value,
                    onPressed: controller.deleteStore,
                  ),
                )
              : AppButton(
                  label: AppStrings.makeOrder.tr,
                  icon: Icons.add_shopping_cart_rounded,
                  onPressed: controller.placeOrder,
                ),
        ),
      ),
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.controller});

  final StoreDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: controller.openOwnerProfile,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Obx(() {
        final owner = controller.owner.value;
        final name = controller.ownerName;
        return Row(
          children: [
            UserAvatar(name: name, imageUrl: owner?.pfp ?? controller.store.ownerPfp),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isEmpty ? AppStrings.owner.tr : name,
                    style: context.text.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (controller.ownerEmail.isNotEmpty)
                    Text(
                      controller.ownerEmail,
                      style: context.text.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            if (!controller.isOwner) ...[
              if (controller.ownerPhone.isNotEmpty)
                _ContactButton(
                  icon: Icons.call_outlined,
                  tooltip: AppStrings.call.tr,
                  onPressed: controller.call,
                ),
              if (controller.ownerEmail.isNotEmpty)
                _ContactButton(
                  icon: Icons.mail_outline_rounded,
                  tooltip: AppStrings.email.tr,
                  onPressed: controller.email,
                ),
            ],
          ],
        );
      }),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton({required this.icon, required this.tooltip, required this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: AppSpacing.xs),
      child: IconButton.filledTonal(
        onPressed: onPressed,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: context.palette.accentSoft,
          foregroundColor: context.palette.accent,
        ),
        icon: Icon(icon, size: 20),
      ),
    );
  }
}
