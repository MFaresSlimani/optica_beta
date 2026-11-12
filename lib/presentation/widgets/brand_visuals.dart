import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_context.dart';

/// Concentric rings: a quiet nod to lenses, used behind brand surfaces.
class LensRingsPainter extends CustomPainter {
  const LensRingsPainter({required this.color, this.center = const Alignment(0.9, -0.6)});

  final Color color;
  final Alignment center;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = center.alongSize(size);
    final maxRadius = math.max(size.width, size.height) * 0.9;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = color;
    for (var r = maxRadius * 0.18; r < maxRadius; r += maxRadius * 0.12) {
      canvas.drawCircle(origin, r, paint);
    }
  }

  @override
  bool shouldRepaint(LensRingsPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.center != center;
}

/// The BN mark inside a soft ring.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.teal800,
        border: Border.all(color: AppColors.copper500.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.copper500.withValues(alpha: 0.25),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Image.asset(
        AppAssets.brandMark,
        cacheWidth: (size * 3).round(),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(Icons.visibility_rounded, color: AppColors.copper300),
      ),
    );
  }
}

/// Branded stand-in when a store has no photo: teal gradient, rings and
/// the store's initials in copper.
class StoreCoverFallback extends StatelessWidget {
  const StoreCoverFallback({super.key, required this.name});

  final String name;

  String get _initials {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '·';
    final letters = words.take(2).map((w) => w.characters.first.toUpperCase());
    return letters.join();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: context.palette.heroGradient),
      child: CustomPaint(
        painter: LensRingsPainter(color: AppColors.copper500.withValues(alpha: 0.16)),
        // Initials scale with the tile: large on covers, small on thumbnails.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final fontSize = (constraints.biggest.shortestSide * 0.32).clamp(14.0, 44.0);
            return Center(
              child: ShaderMask(
                shaderCallback: AppColors.copperGradient.createShader,
                child: Text(
                  _initials,
                  style: context.text.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: fontSize,
                    letterSpacing: fontSize / 22,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Network image with a fade-in and a branded fallback.
class StoreImage extends StatelessWidget {
  const StoreImage({super.key, required this.url, required this.storeName});

  final String? url;
  final String storeName;

  @override
  Widget build(BuildContext context) {
    final fallback = StoreCoverFallback(name: storeName);
    if (url == null || url!.isEmpty) return fallback;
    return Image.network(
      url!,
      fit: BoxFit.cover,
      frameBuilder: (_, child, frame, wasSync) => wasSync
          ? child
          : AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: child,
            ),
      errorBuilder: (_, _, _) => fallback,
      loadingBuilder: (_, child, progress) => progress == null ? child : fallback,
    );
  }
}
