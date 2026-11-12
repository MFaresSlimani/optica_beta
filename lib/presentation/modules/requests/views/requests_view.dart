import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/load_status.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/state_views.dart';
import '../controllers/requests_controller.dart';
import 'widgets/request_card.dart';

class RequestsView extends GetView<RequestsController> {
  const RequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.load,
      edgeOffset: MediaQuery.paddingOf(context).top,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverSafeArea(
            bottom: false,
            sliver: SliverToBoxAdapter(
              child: ConstrainedContent(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    AppSpacing.xl,
                    AppSpacing.gutter,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(AppStrings.requests.tr, style: context.text.headlineMedium),
                      const SizedBox(height: AppSpacing.lg),
                      Obx(() {
                        if (!controller.isStoreOwner) return const SizedBox.shrink();
                        final pending = controller.pendingReceivedCount;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: SegmentedButton<RequestsBox>(
                            showSelectedIcon: false,
                            segments: [
                              ButtonSegment(
                                value: RequestsBox.received,
                                icon: const Icon(Icons.move_to_inbox_outlined, size: 18),
                                label: Text(
                                  pending > 0
                                      ? '${AppStrings.tabReceived.tr} · $pending'
                                      : AppStrings.tabReceived.tr,
                                ),
                              ),
                              ButtonSegment(
                                value: RequestsBox.sent,
                                icon: const Icon(Icons.outbox_outlined, size: 18),
                                label: Text(AppStrings.tabSent.tr),
                              ),
                            ],
                            selected: {controller.box.value},
                            onSelectionChanged: (selection) {
                              HapticFeedback.selectionClick();
                              controller.selectBox(selection.first);
                            },
                          ),
                        );
                      }),
                      _FilterChips(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            switch (controller.status.value) {
              case LoadStatus.loading:
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                );
              case LoadStatus.error:
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(onRetry: controller.load),
                );
              case LoadStatus.ready:
                final entries = controller.visible;
                final inbox =
                    controller.box.value == RequestsBox.received && controller.isStoreOwner;
                if (entries.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: inbox ? Icons.move_to_inbox_outlined : Icons.receipt_long_outlined,
                      title: AppStrings.noRequestsTitle.tr,
                      message: inbox
                          ? AppStrings.noReceivedRequestsMessage.tr
                          : AppStrings.noSentRequestsMessage.tr,
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.gutter,
                    0,
                    AppSpacing.gutter,
                    AppSpacing.xxl,
                  ),
                  sliver: SliverList.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, index) => ConstrainedContent(
                      child: RequestCard(
                        entry: entries[index],
                        incoming: inbox,
                        onTap: () => controller.open(entries[index]),
                      ),
                    ),
                  ),
                );
            }
          }),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.controller});

  final RequestsController controller;

  @override
  Widget build(BuildContext context) {
    final labels = {
      RequestsFilter.all: AppStrings.filterAll.tr,
      RequestsFilter.pending: AppStrings.pending.tr,
      RequestsFilter.done: AppStrings.done.tr,
    };
    return Obx(
      () => Wrap(
        spacing: AppSpacing.sm,
        children: [
          for (final entry in labels.entries)
            ChoiceChip(
              label: Text(entry.value),
              selected: controller.filter.value == entry.key,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                controller.selectFilter(entry.key);
              },
              labelStyle: context.text.labelMedium?.copyWith(
                color: controller.filter.value == entry.key
                    ? context.colors.onPrimary
                    : context.palette.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
