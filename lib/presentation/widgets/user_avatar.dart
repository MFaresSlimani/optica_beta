import 'package:flutter/material.dart';

import '../../core/theme/theme_context.dart';

/// Circular avatar: photo when available, otherwise the person's initial
/// on a tinted background (never a stock placeholder photo).
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 24,
    this.ring = false,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  /// Adds a copper ring (used on profile headers).
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final initial = name.trim().isEmpty ? '?' : name.trim().characters.first.toUpperCase();
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: palette.accentSoft,
      foregroundImage: hasImage ? NetworkImage(imageUrl!) : null,
      onForegroundImageError: hasImage ? (_, _) {} : null,
      child: Text(
        initial,
        style: context.text.titleMedium?.copyWith(
          color: palette.accent,
          fontSize: radius * 0.8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );

    if (!ring) return avatar;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: palette.accent.withValues(alpha: 0.7), width: 2),
      ),
      child: avatar,
    );
  }
}
