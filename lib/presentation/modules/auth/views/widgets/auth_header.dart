import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Minimalist Logo Container
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceDark,
            border: Border.all(
              color: AppColors.accent,
              width: 1.5,
            ),
          ),
          child: ClipOval(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(
                AppAssets.pic,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.visibility_rounded,
                  color: AppColors.accent,
                  size: 34,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        // App Name
        Text(
          AppStrings.appName.tr,
          style: GoogleFonts.abel(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
            color: AppColors.textLight,
          ),
        ),
        const SizedBox(height: 6),
        // Screen Title & Subtitle
        Text(
          title,
          style: GoogleFonts.abel(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: AppColors.accentLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.abel(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
