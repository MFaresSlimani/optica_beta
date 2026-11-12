import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/date_formats.dart';
import '../../../../../core/utils/ticket.dart';

/// On-screen rendering of the thermal ticket: same [Ticket], paper styling.
class TicketPreview extends StatelessWidget {
  const TicketPreview({super.key, required this.ticket, required this.labels});

  final Ticket ticket;
  final TicketLabels labels;

  static const Color _paper = AppColors.ticketPaper;
  static const Color _ink = AppColors.ticketInk;

  @override
  Widget build(BuildContext context) {
    final mono = context.text.bodySmall?.copyWith(
      color: _ink,
      fontFeatures: const [FontFeature.tabularFigures()],
      height: 1.5,
    );
    final bold = mono?.copyWith(fontWeight: FontWeight.w800);

    String statusOf(TicketLineStatus s) => switch (s) {
      TicketLineStatus.pending => labels.pending,
      TicketLineStatus.supplied => labels.supplied,
      TicketLineStatus.notSupplied => labels.notSupplied,
    };

    Widget kv(String k, String v) => Row(
      children: [
        Text(k, style: mono),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Text(v, style: bold, textAlign: TextAlign.end, overflow: TextOverflow.ellipsis),
        ),
      ],
    );

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 340),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: _paper,
          borderRadius: AppRadius.smAll,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              ticket.storeName,
              textAlign: TextAlign.center,
              style: context.text.titleLarge?.copyWith(color: _ink, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            kv(labels.client, ticket.clientName),
            kv(labels.storeOwner, ticket.ownerName),
            kv(labels.created, DateFormats.ticket(ticket.createdAt)),
            if (ticket.doneAt != null) kv(labels.completed, DateFormats.ticket(ticket.doneAt!)),
            const _Dashes(),
            Text(labels.lenses.toUpperCase(), textAlign: TextAlign.center, style: bold),
            const _Dashes(),
            for (final line in ticket.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(line.item.type, style: bold)),
                        Text(statusOf(line.status), style: bold),
                      ],
                    ),
                    if (line.item.isParsed)
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'SPH ${line.item.sphere.format()}   CYL ${line.item.cylinder.format()}',
                              style: mono,
                            ),
                          ),
                          Text('×${line.item.quantity}', style: mono),
                        ],
                      ),
                  ],
                ),
              ),
            const _Dashes(),
            if (ticket.note.isNotEmpty) ...[
              Text('${labels.note}:', style: bold),
              Text(ticket.note, style: mono),
              const SizedBox(height: AppSpacing.md),
            ],
            Text(labels.thanks, textAlign: TextAlign.center, style: mono),
            const SizedBox(height: AppSpacing.sm),
            Text('#${ticket.reference}', textAlign: TextAlign.end, style: mono),
          ],
        ),
      ),
    );
  }
}

class _Dashes extends StatelessWidget {
  const _Dashes();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: LayoutBuilder(
        builder: (_, constraints) {
          final count = (constraints.maxWidth / 8).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              count,
              (_) =>
                  Container(width: 4, height: 1, color: TicketPreview._ink.withValues(alpha: 0.4)),
            ),
          );
        },
      ),
    );
  }
}
