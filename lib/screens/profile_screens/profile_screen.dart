import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bng_optica/models/user_model.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../authentication.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../store_screens/store_screen.dart';
import 'create_store.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Stream<AppUser> userStream;
  final AuthenticationService _auth = AuthenticationService();

  @override
  void initState() {
    super.initState();
    userStream = _auth.getUserStream(widget.userId);
  }

  bool get _isOwnProfile =>
      _auth.getCurrentUser()?.uid == widget.userId;

  Future<void> _refreshUser() async {
    setState(() {
      userStream = _auth.getUserStream(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshUser,
        color: AppColors.accent,
        child: StreamBuilder<AppUser>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('${AppStrings.error.tr}: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData) {
              return Center(child: Text(AppStrings.loading.tr));
            }

            final user = snapshot.data!;
            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                _buildSliverAppBar(user, isDark),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restricted account banner
                        if (user.isRestricted) ...[
                          _buildRestrictedBanner(),
                          const SizedBox(height: 24),
                        ],

                        // Personal Info section
                        _buildSectionHeader(
                          AppStrings.personalInfo.tr,
                          Icons.person_outline_rounded,
                        ),
                        const SizedBox(height: 12),
                        _buildInfoCard(isDark, [
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            label: AppStrings.username.tr,
                            value: user.username,
                          ),
                          _buildDivider(isDark),
                          _buildInfoRow(
                            icon: Icons.email_outlined,
                            label: AppStrings.email.tr,
                            value: user.email,
                          ),
                          _buildDivider(isDark),
                          _buildInfoRow(
                            icon: Icons.phone_outlined,
                            label: AppStrings.phoneNumber.tr,
                            value: user.phoneNumber.isNotEmpty
                                ? user.phoneNumber
                                : '—',
                          ),
                        ]),

                        const SizedBox(height: 24),

                        // Store Info section
                        _buildSectionHeader(
                          AppStrings.storeInfo.tr,
                          Icons.storefront_outlined,
                        ),
                        const SizedBox(height: 12),
                        user.isStoreOwner
                            ? _buildStoreCard(user, isDark)
                            : _buildNoStoreCard(isDark),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // ─── Sliver App Bar with hero header ───────────────────────────────
  Widget _buildSliverAppBar(AppUser user, bool isDark) {
    return SliverAppBar(
      expandedHeight: 260,
      pinned: true,
      stretch: true,
      backgroundColor: isDark ? AppColors.primaryDark : AppColors.primary,
      foregroundColor: Colors.white,
      actions: _isOwnProfile
          ? [
              IconButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Get.to(
                    () => const EditProfileInfoScreen(),
                    transition: Transition.cupertino,
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                tooltip: AppStrings.editProfile.tr,
              ),
            ]
          : null,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [AppColors.primaryDark, AppColors.primary, AppColors.surfaceDark]
                  : [AppColors.primary, AppColors.primaryLight, const Color(0xFF1A5562)],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                // Avatar with accent ring
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.7),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.surfaceDark,
                    backgroundImage: user.pfp.isNotEmpty
                        ? NetworkImage(user.pfp)
                        : const AssetImage('assets/profile.jpg')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                // Display name
                Text(
                  user.username,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Email subtitle
                Text(
                  user.email,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Section Header ────────────────────────────────────────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: theme.brightness == Brightness.dark
                ? AppColors.textMuted
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  // ─── Info Card Container ───────────────────────────────────────────
  Widget _buildInfoCard(bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceCardBorder
              : Colors.grey.shade200,
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

  // ─── Info Row ──────────────────────────────────────────────────────
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.textSubtle
                        : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: theme.brightness == Brightness.dark
                        ? AppColors.textLight
                        : Colors.grey[900],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Divider ───────────────────────────────────────────────────────
  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 48,
      color: isDark ? AppColors.surfaceCardBorder : Colors.grey.shade100,
    );
  }

  // ─── Store Card (has store) ────────────────────────────────────────
  Widget _buildStoreCard(AppUser user, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceCardBorder
              : Colors.grey.shade200,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            HapticFeedback.lightImpact();
            final store = await _auth.getStoreById(user.storeId!);
            if (store != null) {
              Get.to(
                () => StoreScreen(store: store),
                transition: Transition.cupertino,
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FutureBuilder<String>(
                    future: _getStoreName(user.storeId!),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.accent,
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snap.data ?? '',
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textLight
                                  : Colors.grey[900],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppStrings.viewStore.tr,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.textSubtle : Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── No Store Card ─────────────────────────────────────────────────
  Widget _buildNoStoreCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? AppColors.surfaceCardBorder
              : Colors.grey.shade200,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.store_outlined,
                color: isDark ? AppColors.textSubtle : Colors.grey[400],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppStrings.noStoreYet.tr,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: isDark ? AppColors.textMuted : Colors.grey[500],
                ),
              ),
            ),
            if (_isOwnProfile)
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Get.to(
                    () => const CreateNewStoreScreen(),
                    transition: Transition.cupertino,
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  AppStrings.createStore.tr,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── Restricted Account Banner ─────────────────────────────────────
  Widget _buildRestrictedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade900.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade300.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red.shade300,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.accountRestricted.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red.shade300,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.accountRestrictedMessage.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.red.shade200,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String> _getStoreName(String storeId) async {
    final store = await _auth.getStoreById(storeId);
    return store?.storeName ?? '';
  }
}
