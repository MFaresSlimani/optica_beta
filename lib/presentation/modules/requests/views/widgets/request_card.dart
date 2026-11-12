import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/theme_context.dart';
import '../../../../../core/utils/date_formats.dart';
import '../../../../../data/models/request_entry.dart';
import '../../../../widgets/status_badge.dart';
import '../../../../widgets/surface_card.dart';
import '../../../../widgets/user_avatar.dart';

/// One request in the inbox / outbox list.
class RequestCard extends StatelessWidget {
  const RequestCard({super.key, required this.entry, required this.incoming, required this.onTap});

  final RequestEntry entry;

  /// Incoming requests show who sent them; outgoing show the store.
  final bool incoming;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final request = entry.request;
    final counterpart = incoming ? entry.senderName : entry.storeName;
    final avatarUrl = incoming ? entry.sender?.pfp : entry.store?.coverUrl;
    final title = incoming
        ? AppStrings.fromName.trParams({'name': counterpart})
        : AppStrings.toName.trParams({'name': counterpart});

    return SurfaceCard(
      onTap: onTap,
      child: Row(
        children: [
          UserAvatar(name: counterpart, imageUrl: avatarUrl),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  counterpart.isEmpty ? AppStrings.requestDetails.tr : title,
                  style: context.text.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${DateFormats.compact(request.createdAt)}  ·  '
                  '${AppStrings.lensesCount.trParams({'count': '${request.totalQuantity}'})}',
                  style: context.text.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StatusBadge(isDone: request.isDone),
        ],
      ),
    );
  }
}
