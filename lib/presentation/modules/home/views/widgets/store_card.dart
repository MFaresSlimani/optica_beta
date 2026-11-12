import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../data/models/store.dart';
import '../../../../widgets/brand_visuals.dart';
import '../../../../widgets/state_views.dart';
import '../../../../widgets/status_badge.dart';

/// Store row in the directory: cover photo, name, location.
class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store, required this.onTap, this.isMine = false});

  final Store store;
  final VoidCallback onTap;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surfaceRaised,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.xlAll,
        side: BorderSide(color: palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 8,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'store-cover-${store.id}',
                    child: StoreImage(url: store.coverUrl, storeName: store.name),
                  ),
                  if (isMine)
                    PositionedDirectional(
                      top: AppSpacing.md,
                      start: AppSpacing.md,
                      child: TagChip(
                        label: AppStrings.yourStore.tr,
                        icon: Icons.verified_rounded,
                        onDark: true,
                      ),
                    ),
                  if (store.pictures.length > 1)
                    PositionedDirectional(
                      top: AppSpacing.md,
                      end: AppSpacing.md,
                      child: TagChip(
                        label: '${store.pictures.length}',
                        icon: Icons.photo_library_outlined,
                        onDark: true,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.name,
                          style: context.text.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (store.location.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Icon(Icons.place_outlined, size: 16, color: palette.textMuted),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  store.location,
                                  style: context.text.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: AppSpacing.minTapTarget - AppSpacing.sm,
                    height: AppSpacing.minTapTarget - AppSpacing.sm,
                    decoration: BoxDecoration(color: palette.accentSoft, shape: BoxShape.circle),
                    // Material's arrow_forward mirrors itself in RTL.
                    child: Icon(Icons.arrow_forward_rounded, size: 20, color: palette.accent),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StoreCardSkeleton extends StatelessWidget {
  const StoreCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.palette.surfaceRaised,
        borderRadius: AppRadius.xlAll,
        border: Border.all(color: context.palette.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(aspectRatio: 16 / 8, child: Skeleton(radius: 0)),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 180, height: 18),
                SizedBox(height: AppSpacing.sm),
                Skeleton(width: 120, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
