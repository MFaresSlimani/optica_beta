import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/load_status.dart';
import '../../../../data/models/app_user.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/brand_visuals.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_badge.dart';
import '../../../widgets/surface_card.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/profile_controller.dart';

/// Own profile (as a tab) or another user's profile (pushed, with [tag]).
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key, this.controllerTag});

  final String? controllerTag;

  @override
  String? get tag => controllerTag;

  @override
  Widget build(BuildContext context) {
    final pushed = controllerTag != null;
    return Scaffold(
      body: Obx(() {
        if (controller.status.value == LoadStatus.error) {
          return ErrorState(onRetry: controller.load);
        }
        final user = controller.user.value;
        if (user == null) {
          if (controller.status.value == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return EmptyState(
            icon: Icons.person_off_outlined,
            title: AppStrings.userNotFound.tr,
            message: '',
          );
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              _ProfileHeader(user: user, showBack: pushed, controller: controller),
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
                        if (user.isRestricted) ...[
                          const _RestrictedBanner(),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                        SectionHeader(AppStrings.personalInfo.tr),
                        GroupedCard(
                          dividerIndent: 68,
                          children: [
                            InfoRow(
                              icon: Icons.person_outline_rounded,
                              label: AppStrings.username.tr,
                              value: user.displayName,
                            ),
                            InfoRow(
                              icon: Icons.alternate_email_rounded,
                              label: AppStrings.email.tr,
                              value: user.email.isEmpty ? '—' : user.email,
                            ),
                            InfoRow(
                              icon: Icons.phone_outlined,
                              label: AppStrings.phoneNumber.tr,
                              value: user.phoneNumber.isEmpty ? '—' : user.phoneNumber,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        SectionHeader(AppStrings.storeInfo.tr),
                        _StoreSection(controller: controller),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.showBack, required this.controller});

  final AppUser user;
  final bool showBack;
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(gradient: context.palette.heroGradient),
        child: CustomPaint(
          painter: LensRingsPainter(color: AppColors.copper500.withValues(alpha: 0.12)),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.xl,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      if (showBack) const BackButton(color: Colors.white),
                      const Spacer(),
                      if (controller.isMe)
                        IconButton(
                          onPressed: controller.editProfile,
                          tooltip: AppStrings.editProfile.tr,
                          color: Colors.white,
                          icon: const Icon(Icons.edit_outlined),
                        ),
                    ],
                  ),
                  Hero(
                    tag: 'avatar-${user.uid}',
                    child: UserAvatar(
                      name: user.displayName,
                      imageUrl: user.pfp,
                      radius: 44,
                      ring: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    user.displayName,
                    style: context.text.headlineSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TagChip(
                    onDark: true,
                    icon: user.isStoreOwner ? Icons.storefront_rounded : Icons.visibility_outlined,
                    label:
                        (user.isStoreOwner ? AppStrings.storeOwnerBadge : AppStrings.opticianBadge)
                            .tr,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoreSection extends StatelessWidget {
  const _StoreSection({required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final store = controller.store.value;
      if (store != null) {
        return SurfaceCard(
          onTap: controller.openStore,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.mdAll,
                child: SizedBox.square(
                  dimension: 56,
                  child: StoreImage(url: store.coverUrl, storeName: store.name),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      store.name,
                      style: context.text.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      AppStrings.viewStore.tr,
                      style: context.text.bodySmall?.copyWith(color: context.palette.accent),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: context.palette.textMuted),
            ],
          ),
        );
      }
      return SurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: context.palette.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.add_business_outlined, color: context.palette.accent),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.noStoreYet.tr, style: context.text.titleSmall),
                      if (controller.isMe) ...[
                        const SizedBox(height: AppSpacing.xxs),
                        Text(AppStrings.createStoreHint.tr, style: context.text.bodySmall),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (controller.isMe) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: AppStrings.createStore.tr,
                icon: Icons.add_rounded,
                variant: AppButtonVariant.accent,
                onPressed: controller.createStore,
              ),
            ],
          ],
        ),
      );
    });
  }
}

class _RestrictedBanner extends StatelessWidget {
  const _RestrictedBanner();

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SurfaceCard(
      color: palette.dangerSoft,
      borderColor: palette.danger.withValues(alpha: 0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.gpp_maybe_outlined, color: palette.danger),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.accountRestricted.tr,
                  style: context.text.titleSmall?.copyWith(color: palette.danger),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(AppStrings.accountRestrictedMessage.tr, style: context.text.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
