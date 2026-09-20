import 'package:bng_optica/screens/settings_screens/change_language.dart';
import 'package:bng_optica/screens/settings_screens/help_screen.dart';
import 'package:bng_optica/screens/settings_screens/info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../auth_screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.settingsScreen.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        children: [
          // ── Appearance Section ─────────────────────
          _buildSectionHeader(AppStrings.appearance.tr, isDark),
          const SizedBox(height: 8),
          _buildCard(isDark, [
            _buildSwitchTile(
              icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              title: isDark ? AppStrings.darkMode.tr : AppStrings.lightMode.tr,
              isDark: isDark,
              value: isDark,
              onChanged: (value) {
                HapticFeedback.lightImpact();
                Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                setState(() {});
              },
            ),
          ]),

          const SizedBox(height: 24),

          // ── General Section ────────────────────────
          _buildSectionHeader(AppStrings.general.tr, isDark),
          const SizedBox(height: 8),
          _buildCard(isDark, [
            _buildNavTile(
              icon: Icons.language_rounded,
              title: AppStrings.changeLanguage.tr,
              isDark: isDark,
              onTap: () {
                Get.to(
                  () => const ChangeLanguage(),
                  transition: Transition.cupertino,
                );
              },
            ),
            _buildTileDivider(isDark),
            _buildNavTile(
              icon: Icons.help_outline_rounded,
              title: AppStrings.help.tr,
              isDark: isDark,
              onTap: () {
                Get.to(
                  () => const HelpScreen(),
                  transition: Transition.cupertino,
                );
              },
            ),
          ]),

          const SizedBox(height: 24),

          // ── About Section ──────────────────────────
          _buildSectionHeader(AppStrings.about.tr, isDark),
          const SizedBox(height: 8),
          _buildCard(isDark, [
            _buildNavTile(
              icon: Icons.info_outline_rounded,
              title: AppStrings.info.tr,
              isDark: isDark,
              onTap: () {
                Get.to(
                  () => const InfosScreen(),
                  transition: Transition.cupertino,
                );
              },
            ),
            _buildTileDivider(isDark),
            _buildInfoTile(
              icon: Icons.verified_outlined,
              title: AppStrings.version.tr,
              subtitle: '1.0.0',
              isDark: isDark,
            ),
          ]),

          const SizedBox(height: 32),

          // ── Logout Button ──────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutConfirmation(isDark),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: Text(
                AppStrings.logout.tr,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
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

  // ─── Card Container ────────────────────────────────────────────────
  Widget _buildCard(bool isDark, List<Widget> children) {
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

  // ─── Navigation Tile ───────────────────────────────────────────────
  Widget _buildNavTile({
    required IconData icon,
    required String title,
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
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.textLight : Colors.grey[900],
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: isDark ? AppColors.textSubtle : Colors.grey[400],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      ),
    );
  }

  // ─── Switch Tile ───────────────────────────────────────────────────
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool isDark,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, size: 22, color: AppColors.accent),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textLight : Colors.grey[900],
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppColors.accent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  // ─── Info Tile (no navigation) ─────────────────────────────────────
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: AppColors.accent),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.textLight : Colors.grey[900],
        ),
      ),
      trailing: Text(
        subtitle,
        style: GoogleFonts.outfit(
          fontSize: 14,
          color: isDark ? AppColors.textSubtle : Colors.grey[500],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
    );
  }

  // ─── Tile Divider ──────────────────────────────────────────────────
  Widget _buildTileDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: isDark ? AppColors.surfaceCardBorder : Colors.grey.shade100,
    );
  }

  // ─── Logout Confirmation Dialog ────────────────────────────────────
  void _showLogoutConfirmation(bool isDark) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(
          Icons.logout_rounded,
          color: AppColors.error,
          size: 40,
        ),
        title: Text(
          AppStrings.logoutConfirmTitle.tr,
          style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
        ),
        content: Text(
          AppStrings.logoutConfirmMessage.tr,
          style: GoogleFonts.outfit(),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.cancel.tr,
              style: GoogleFonts.outfit(
                color: isDark ? AppColors.textMuted : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              final auth = AuthenticationService();
              auth.signOut();
              Get.offAll(() => const LoginScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              elevation: 0,
            ),
            child: Text(
              AppStrings.logout.tr,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
