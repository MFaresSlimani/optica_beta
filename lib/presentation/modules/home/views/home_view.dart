import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../../core/utils/load_status.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/state_views.dart';
import '../controllers/home_controller.dart';
import 'widgets/store_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

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
                  child: _Header(controller: controller),
                ),
              ),
            ),
          ),
          Obx(() {
            switch (controller.status.value) {
              case LoadStatus.loading:
                return const _LoadingList();
              case LoadStatus.error:
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorState(onRetry: controller.load),
                );
              case LoadStatus.ready:
                final stores = controller.visibleStores;
                if (stores.isEmpty) {
                  final searching = controller.query.value.isNotEmpty;
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: searching ? Icons.search_off_rounded : Icons.storefront_outlined,
                      title: searching
                          ? AppStrings.noSearchResults.trParams({'query': controller.query.value})
                          : AppStrings.noStoresTitle.tr,
                      message: AppStrings.noStoresMessage.tr,
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
                    itemCount: stores.length,
                    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
                    itemBuilder: (_, index) {
                      final store = stores[index];
                      return ConstrainedContent(
                        child: StoreCard(
                          store: store,
                          isMine: controller.isMine(store),
                          onTap: () => controller.openStore(store),
                        ),
                      );
                    },
                  ),
                );
            }
          }),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.homeEyebrow.tr.toUpperCase(), style: context.text.labelSmall),
        const SizedBox(height: AppSpacing.sm),
        Obx(() {
          final name = controller.firstName;
          return Text(
            name.isEmpty ? AppStrings.findAStore.tr : AppStrings.helloName.trParams({'name': name}),
            style: context.text.headlineMedium,
          );
        }),
        const SizedBox(height: AppSpacing.xs),
        Text(AppStrings.findAStore.tr, style: context.text.bodyLarge),
        const SizedBox(height: AppSpacing.xl),
        Obx(
          () => TextField(
            controller: controller.searchController,
            onChanged: controller.onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: AppStrings.searchStores.tr,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: controller.query.value.isEmpty
                  ? null
                  : IconButton(
                      onPressed: controller.clearSearch,
                      icon: const Icon(Icons.close_rounded),
                      tooltip: AppStrings.close.tr,
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Obx(() {
          if (controller.status.value != LoadStatus.ready) return const SizedBox.shrink();
          return Text(
            AppStrings.storesCount.trParams({'count': '${controller.visibleStores.length}'}),
            style: context.text.bodySmall,
          );
        }),
      ],
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: AppSpacing.screen,
      sliver: SliverList.separated(
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.lg),
        itemBuilder: (_, _) => const ConstrainedContent(child: StoreCardSkeleton()),
      ),
    );
  }
}
