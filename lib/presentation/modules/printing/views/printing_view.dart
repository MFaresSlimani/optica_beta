import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/theme_context.dart';
import '../../../widgets/layout.dart';
import '../../../widgets/section_header.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/surface_card.dart';
import '../controllers/printing_controller.dart';
import 'widgets/ticket_preview.dart';

class PrintingView extends GetView<PrintingController> {
  const PrintingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.printTicket.tr)),
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
                SectionHeader(AppStrings.ticketPreview.tr),
                TicketPreview(ticket: controller.ticket, labels: controller.labels),
                const SizedBox(height: AppSpacing.xl),
                SectionHeader(
                  AppStrings.printers.tr,
                  trailing: Obx(
                    () => controller.isScanning.value
                        ? const Padding(
                            padding: EdgeInsets.all(AppSpacing.md),
                            child: SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : TextButton.icon(
                            onPressed: controller.scan,
                            icon: const Icon(Icons.refresh_rounded, size: 18),
                            label: Text(AppStrings.scan.tr),
                          ),
                  ),
                ),
                Obx(() {
                  final devices = controller.devices;
                  if (devices.isEmpty) {
                    return SurfaceCard(
                      child: controller.isScanning.value
                          ? Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bluetooth_searching_rounded,
                                    color: context.palette.accent,
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Text(
                                      AppStrings.scanning.tr,
                                      style: context.text.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : EmptyState(
                              compact: true,
                              icon: Icons.print_disabled_outlined,
                              title: AppStrings.noPrintersTitle.tr,
                              message: AppStrings.noPrintersMessage.tr,
                            ),
                    );
                  }
                  return GroupedCard(
                    children: [
                      for (final printer in devices)
                        ListTile(
                          onTap: () => controller.printTo(printer),
                          leading: Icon(
                            printer.isConnected ?? false
                                ? Icons.print_rounded
                                : Icons.print_outlined,
                          ),
                          title: Text(printer.name ?? ''),
                          subtitle: Text(
                            printer.isConnected ?? false
                                ? AppStrings.connected.tr
                                : AppStrings.tapToPrint.tr,
                          ),
                          trailing: controller.printingTo.value == (printer.address ?? printer.name)
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(Icons.chevron_right_rounded, color: context.palette.textMuted),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
