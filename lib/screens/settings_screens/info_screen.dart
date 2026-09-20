import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class InfosScreen extends StatelessWidget {
  const InfosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.info.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Logo / Header
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.visibility_rounded,
                  color: AppColors.accent,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                AppStrings.aboutCompany.tr,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textLight : Colors.grey[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.aboutCompanyDescription.tr,
              style: GoogleFonts.outfit(
                fontSize: 15,
                height: 1.5,
                color: isDark ? AppColors.textMuted : Colors.grey[600],
              ),
            ),

            const SizedBox(height: 28),

            // Our Values
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.favorite_outline_rounded,
              title: AppStrings.ourValues.tr,
              body: AppStrings.ourValuesDescription.tr,
            ),

            const SizedBox(height: 16),

            // Our Strength
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.shield_outlined,
              title: AppStrings.ourStrength.tr,
              body: AppStrings.ourStrengthDescription.tr,
              extra: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppStrings.ourStrengthItems.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    height: 1.6,
                    color: isDark ? AppColors.textMuted : Colors.grey[600],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Our Vision
            _buildSectionCard(
              isDark: isDark,
              icon: Icons.remove_red_eye_outlined,
              title: AppStrings.ourVision.tr,
              body: AppStrings.ourVisionDescription.tr,
            ),

            const SizedBox(height: 28),

            // Contact Links
            _buildSectionHeader(
              AppStrings.contactUs.tr.toUpperCase(),
              isDark,
            ),
            const SizedBox(height: 12),
            _buildContactCard(isDark, [
              _buildContactTile(
                icon: Icons.language_rounded,
                title: AppStrings.onlineStore.tr,
                subtitle: 'bengherbia-optic.shop',
                isDark: isDark,
                onTap: () {
                  HapticFeedback.lightImpact();
                  launchUrl(Uri.parse('https://bengherbia-optic.shop'));
                },
              ),
              _buildDivider(isDark),
              _buildContactTile(
                icon: Icons.email_outlined,
                title: AppStrings.email.tr,
                subtitle: 'Bengherbia_optical@outlook.com',
                isDark: isDark,
                onTap: () {
                  HapticFeedback.lightImpact();
                  launchUrl(Uri.parse(
                      'mailto:Bengherbia_optical@outlook.com'));
                },
              ),
              _buildDivider(isDark),
              _buildContactTile(
                icon: Icons.facebook_rounded,
                title: 'Facebook',
                subtitle: 'Bengherbia Optique',
                isDark: isDark,
                onTap: () {
                  HapticFeedback.lightImpact();
                  launchUrl(Uri.parse(
                      'https://www.facebook.com/bengherbia.optique/'));
                },
              ),
              _buildDivider(isDark),
              _buildContactTile(
                icon: Icons.camera_alt_outlined,
                title: 'Instagram',
                subtitle: 'bengherbia_optical',
                isDark: isDark,
                onTap: () {
                  HapticFeedback.lightImpact();
                  launchUrl(Uri.parse(
                      'https://www.instagram.com/bengherbia_optical'));
                },
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ─── Section Card ──────────────────────────────────────────────────
  Widget _buildSectionCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String body,
    Widget? extra,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.surfaceCardBorder : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textLight : Colors.grey[900],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.outfit(
              fontSize: 14,
              height: 1.5,
              color: isDark ? AppColors.textMuted : Colors.grey[600],
            ),
          ),
          if (extra != null) extra,
        ],
      ),
    );
  }

  // ─── Section Header ────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? AppColors.textSubtle : Colors.grey[500],
        ),
      ),
    );
  }

  // ─── Contact Card ──────────────────────────────────────────────────
  Widget _buildContactCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.surfaceCardBorder : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ─── Contact Tile ──────────────────────────────────────────────────
  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Icon(icon, size: 22, color: AppColors.accent),
        title: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textLight : Colors.grey[900],
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.outfit(
            fontSize: 13,
            color: isDark ? AppColors.textSubtle : Colors.grey[500],
          ),
        ),
        trailing: Icon(
          Icons.open_in_new_rounded,
          size: 16,
          color: isDark ? AppColors.textSubtle : Colors.grey[400],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        onTap: onTap,
      ),
    );
  }

  // ─── Divider ───────────────────────────────────────────────────────
  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: isDark ? AppColors.surfaceCardBorder : Colors.grey.shade100,
    );
  }
}
