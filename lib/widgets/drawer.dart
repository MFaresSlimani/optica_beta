import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../authentication.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../models/user_model.dart';
import '../screens/auth_screens/login_screen.dart';
import '../screens/profile_screens/profile_screen.dart';
import '../screens/request_screen/requests_list.dart';
import '../screens/settings_screens/settings_screen.dart';

class ADrawer extends StatelessWidget {
  const ADrawer({super.key, required this.auth});
  final AuthenticationService auth;

  @override
  Widget build(BuildContext context) {
    final currentUserId = auth.getCurrentUser()?.id ?? '';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Column(
        children: [
          // ── User Header ──────────────────────────────
          FutureBuilder<AppUser>(
            future: currentUserId.isNotEmpty
                ? auth.getUserById(currentUserId)
                : null,
            builder: (context, snapshot) {
              final user = snapshot.data;
              return DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppColors.primaryDark, AppColors.primary]
                        : [AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                margin: EdgeInsets.zero,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.6),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.surfaceDark,
                          backgroundImage: (user != null && user.pfp.isNotEmpty)
                              ? NetworkImage(user.pfp)
                              : const AssetImage('assets/profile.jpg')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.username ?? '',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? '',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // ── Navigation Items ─────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildDrawerTile(
                  icon: Icons.home_outlined,
                  title: AppStrings.home.tr,
                  isDark: isDark,
                  onTap: () => Get.back(),
                ),
                _buildDrawerTile(
                  icon: Icons.person_outline_rounded,
                  title: AppStrings.profile.tr,
                  isDark: isDark,
                  onTap: () {
                    Get.back();
                    Get.to(
                      () => ProfileScreen(userId: currentUserId),
                      transition: Transition.cupertino,
                    );
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.receipt_long_outlined,
                  title: AppStrings.requests.tr,
                  isDark: isDark,
                  onTap: () {
                    Get.back();
                    Get.to(
                      () => RequestsScreen(),
                      transition: Transition.cupertino,
                    );
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.settings_outlined,
                  title: AppStrings.settings.tr,
                  isDark: isDark,
                  onTap: () {
                    Get.back();
                    Get.to(
                      () => const SettingsScreen(),
                      transition: Transition.cupertino,
                    );
                  },
                ),
              ],
            ),
          ),

          // ── Logout at bottom ─────────────────────────
          Divider(
            height: 1,
            color: isDark ? AppColors.surfaceCardBorder : Colors.grey.shade200,
          ),
          _buildDrawerTile(
            icon: Icons.logout_rounded,
            title: AppStrings.logout.tr,
            isDark: isDark,
            isDestructive: true,
            onTap: () => _showLogoutConfirmation(context, isDark),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ─── Drawer Tile ───────────────────────────────────────────────────
  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.textLight : Colors.grey[800]);
    final iconColor = isDestructive
        ? AppColors.error
        : AppColors.accent;

    return ListTile(
      leading: Icon(icon, size: 22, color: iconColor),
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
    );
  }

  // ─── Logout Confirmation ───────────────────────────────────────────
  void _showLogoutConfirmation(BuildContext context, bool isDark) {
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
