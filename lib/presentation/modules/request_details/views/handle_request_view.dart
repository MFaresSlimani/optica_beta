import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/lens_line_tile.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/surface_card.dart';
import '../controllers/handle_request_controller.dart';

class HandleRequestView extends GetView<HandleRequestController> {
  const HandleRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    final items = controller.entry.request.items;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.handleRequest.tr)),
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
                Text(AppStrings.handleRequestHint.tr, style: context.text.bodyLarge),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(
                  AppStrings.orderedLenses.tr,
                  trailing: Obx(
                    () => TextButton(
                      onPressed: controller.toggleAll,
                      child: Text(
                        controller.allSelected ? AppStrings.cancel.tr : AppStrings.selectAll.tr,
                      ),
                    ),
                  ),
                ),
                SurfaceCard(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Obx(
                    () => Column(
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          if (i > 0) const Divider(indent: 68, endIndent: AppSpacing.lg),
                          InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              controller.toggle(i);
                            },
                            child: LensLineTile(
                              item: items[i],
                              leading: _CheckCircle(checked: controller.supplied.contains(i)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                AppTextField(
                  controller: controller.notesController,
                  label: AppStrings.notes.tr,
                  hint: AppStrings.enterNotesHere.tr,
                  icon: Icons.sticky_note_2_outlined,
                  maxLines: 4,
                  minLines: 3,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        leading: Obx(
          () => Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: controller.total == 0
                        ? 0
                        : controller.supplied.length / controller.total,
                    minHeight: 6,
                    color: context.palette.success,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                AppStrings.readyCount.trParams({
                  'done': '${controller.supplied.length}',
                  'total': '${controller.total}',
                }),
                style: context.text.labelMedium,
              ),
            ],
          ),
        ),
        child: Obx(
          () => AppButton(
            label: AppStrings.completeRequest.tr,
            icon: Icons.task_alt_rounded,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.complete,
          ),
        ),
      ),
    );
  }
}

class _CheckCircle extends StatelessWidget {
  const _CheckCircle({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return AnimatedContainer(
      duration: AppDurations.medium,
      curve: Curves.easeOutBack,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: checked ? palette.success : palette.surfaceSunken,
        shape: BoxShape.circle,
        border: Border.all(color: checked ? palette.success : palette.borderStrong, width: 1.5),
      ),
      child: AnimatedScale(
        scale: checked ? 1 : 0,
        duration: AppDurations.medium,
        curve: Curves.easeOutBack,
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
