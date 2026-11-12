import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/lens_line_tile.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/surface_card.dart';
import '../controllers/order_controller.dart';
import 'widgets/diopter_wheel.dart';
import 'widgets/quantity_stepper.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.newOrder.tr),
            Text(
              controller.store.name,
              style: context.text.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
        children: [
          SectionHeader(
            AppStrings.typeOfGlasses.tr,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.gutter + AppSpacing.xs,
              AppSpacing.sm,
              AppSpacing.gutter,
              AppSpacing.sm,
            ),
          ),
          _LensTypeSelector(controller: controller),
          const SizedBox(height: AppSpacing.xl),
          ConstrainedContent(
            child: Padding(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(AppStrings.prescription.tr),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DiopterWheel(
                            label: AppStrings.sphere.tr,
                            values: OrderController.powers,
                            selected: controller.sphere.value,
                            scrollController: controller.sphereWheel,
                            onChanged: controller.onSphereIndexChanged,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Obx(
                          () => DiopterWheel(
                            label: AppStrings.cylinder.tr,
                            values: OrderController.powers,
                            selected: controller.cylinder.value,
                            scrollController: controller.cylinderWheel,
                            onChanged: controller.onCylinderIndexChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Obx(
                        () => QuantityStepper(
                          value: controller.quantity.value,
                          onIncrement: controller.incrementQuantity,
                          onDecrement: controller.quantity.value > 1
                              ? controller.decrementQuantity
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: AppButton(
                          label: AppStrings.addGlassesToList.tr,
                          icon: Icons.add_rounded,
                          variant: AppButtonVariant.accent,
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            controller.addLine();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  SectionHeader(AppStrings.orderItems.tr),
                  Obx(() {
                    if (controller.lines.isEmpty) {
                      return SurfaceCard(
                        child: EmptyState(
                          compact: true,
                          icon: Icons.playlist_add_rounded,
                          title: AppStrings.noGlassesAddedYet.tr,
                          message: AppStrings.emptyOrderHint.tr,
                        ),
                      );
                    }
                    return SurfaceCard(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                      child: Column(
                        children: [
                          for (var i = 0; i < controller.lines.length; i++) ...[
                            if (i > 0) const Divider(indent: 68, endIndent: AppSpacing.lg),
                            Dismissible(
                              key: ValueKey(controller.lines[i].encode()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) => controller.removeLine(i),
                              background: const _DismissBackground(),
                              child: LensLineTile(
                                item: controller.lines[i],
                                trailing: IconButton(
                                  onPressed: () => controller.removeLine(i),
                                  tooltip: AppStrings.remove.tr,
                                  icon: Icon(Icons.close_rounded, color: context.palette.textMuted),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        leading: Obx(
          () => Row(
            children: [
              Text(AppStrings.orderItems.tr, style: context.text.bodyMedium),
              const Spacer(),
              Text(
                AppStrings.orderSummary.trParams({
                  'lenses': '${controller.totalQuantity}',
                  'lines': '${controller.lines.length}',
                }),
                style: context.text.titleSmall,
              ),
            ],
          ),
        ),
        child: Obx(
          () => AppButton(
            label: AppStrings.submitOrder.tr,
            icon: Icons.send_rounded,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.canSubmit ? controller.submit : null,
          ),
        ),
      ),
    );
  }
}

class _LensTypeSelector extends StatelessWidget {
  const _LensTypeSelector({required this.controller});

  final OrderController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.minTapTarget,
      child: Obx(() {
        final selected = controller.lensType.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: AppSpacing.screen,
          itemCount: LensCatalog.types.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, index) {
            final type = LensCatalog.types[index];
            final isSelected = type == selected;
            return ChoiceChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (_) {
                HapticFeedback.selectionClick();
                controller.selectLensType(type);
              },
              labelStyle: context.text.labelMedium?.copyWith(
                color: isSelected ? context.colors.onPrimary : context.palette.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
              side: BorderSide(color: isSelected ? context.colors.primary : context.palette.border),
            );
          },
        );
      }),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerEnd,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      color: context.palette.dangerSoft,
      child: Icon(Icons.delete_outline_rounded, color: context.palette.danger),
    );
  }
}
