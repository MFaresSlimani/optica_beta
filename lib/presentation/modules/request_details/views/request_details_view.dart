import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/date_formats.dart';
import '../../../../data/models/lens_item.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/lens_line_tile.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/status_badge.dart';
import '../../../widgets/surface_card.dart';
import '../../../widgets/user_avatar.dart';
import '../controllers/request_details_controller.dart';

class RequestDetailsView extends GetView<RequestDetailsController> {
  const RequestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.close();
      },
      child: Obx(() {
        final entry = controller.entry.value;
        final request = entry.request;
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: controller.close),
            title: Text(AppStrings.requestDetails.tr),
            actions: [
              IconButton(
                onPressed: controller.printTicket,
                tooltip: AppStrings.printTicket.tr,
                icon: const Icon(Icons.print_outlined),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter,
              AppSpacing.sm,
              AppSpacing.gutter,
              AppSpacing.xxl,
            ),
            children: [
              ConstrainedContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StatusCard(
                      isDone: request.isDone,
                      createdAt: request.createdAt,
                      doneAt: request.doneAt,
                      total: request.totalQuantity,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SectionHeader(AppStrings.orderedBy.tr),
                    SurfaceCard(
                      onTap: controller.openSender,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          UserAvatar(name: entry.senderName, imageUrl: entry.sender?.pfp),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.senderName, style: context.text.titleSmall),
                                if ((entry.sender?.email ?? '').isNotEmpty)
                                  Text(entry.sender!.email, style: context.text.bodySmall),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: context.palette.textMuted),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SurfaceCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: context.palette.accentSoft,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.storefront_rounded, color: context.palette.accent),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppStrings.store.tr, style: context.text.bodySmall),
                                Text(entry.storeName, style: context.text.titleSmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (request.isDone) ...[
                      _LinesSection(
                        title: AppStrings.supplied.tr,
                        items: request.doneItems,
                        icon: Icons.check_circle_rounded,
                        color: context.palette.success,
                      ),
                      if (request.leftItems.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        _LinesSection(
                          title: AppStrings.notSupplied.tr,
                          items: request.leftItems,
                          icon: Icons.cancel_rounded,
                          color: context.palette.danger,
                          muted: true,
                        ),
                      ],
                      if (request.doneMessage.trim().isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xl),
                        SectionHeader(AppStrings.storeNote.tr),
                        SurfaceCard(
                          color: context.palette.accentSoft,
                          borderColor: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.format_quote_rounded, color: context.palette.accent),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(request.doneMessage, style: context.text.bodyLarge),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ] else
                      _LinesSection(title: AppStrings.orderedLenses.tr, items: request.items),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: controller.canProcess
              ? BottomActionBar(
                  child: AppButton(
                    label: AppStrings.processRequest.tr,
                    icon: Icons.fact_check_outlined,
                    onPressed: controller.process,
                  ),
                )
              : null,
        );
      }),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.isDone,
    required this.createdAt,
    required this.doneAt,
    required this.total,
  });

  final bool isDone;
  final DateTime createdAt;
  final DateTime? doneAt;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: context.palette.heroGradient,
        borderRadius: AppRadius.xlAll,
        border: Border.all(color: context.palette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(isDone: isDone),
              const Spacer(),
              Text(
                AppStrings.lensesCount.trParams({'count': '$total'}),
                style: context.text.labelLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            DateFormats.longDate(createdAt),
            style: context.text.titleLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.requestedOn.trParams({'date': DateFormats.dateTime(createdAt)}),
            style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
          ),
          if (doneAt != null)
            Text(
              AppStrings.completedOn.trParams({'date': DateFormats.dateTime(doneAt!)}),
              style: context.text.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.72)),
            ),
        ],
      ),
    );
  }
}

class _LinesSection extends StatelessWidget {
  const _LinesSection({
    required this.title,
    required this.items,
    this.icon,
    this.color,
    this.muted = false,
  });

  final String title;
  final List<LensItem> items;
  final IconData? icon;
  final Color? color;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title, trailing: Text('${items.length}', style: context.text.labelSmall)),
        SurfaceCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) const Divider(indent: 68, endIndent: AppSpacing.lg),
                LensLineTile(
                  item: items[i],
                  muted: muted,
                  trailing: icon == null ? null : Icon(icon, color: color, size: 20),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
