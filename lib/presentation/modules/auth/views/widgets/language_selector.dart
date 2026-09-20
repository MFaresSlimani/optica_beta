import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../controllers/auth_controller.dart';

class LanguageSelector extends StatelessWidget {
  final AuthController controller;

  const LanguageSelector({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale?.languageCode ?? 'fr';
    final currentText = _getLocaleCodeLabel(currentLocale);

    return PopupMenuButton<Locale>(
      offset: const Offset(0, 36),
      color: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.surfaceCardBorder, width: 1),
      ),
      onSelected: (locale) {
        controller.changeLocale(locale.languageCode, locale.countryCode ?? '');
      },
      itemBuilder: (context) => [
        _buildMenuItem(const Locale('fr', 'FR'), 'Français (FR)'),
        _buildMenuItem(const Locale('en', 'UK'), 'English (EN)'),
        _buildMenuItem(const Locale('ar', 'AR'), 'العربية (AR)'),
        _buildMenuItem(const Locale('kab', 'KAB'), 'ⵜⴰⵎⴰⵣⵉⵖⵜ (Tamazight)'),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.surfaceCardBorder, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.language_rounded,
              color: AppColors.accent,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              currentText,
              style: GoogleFonts.abel(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_drop_down,
              color: AppColors.accent,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<Locale> _buildMenuItem(Locale locale, String title) {
    return PopupMenuItem<Locale>(
      value: locale,
      child: Text(
        title,
        style: GoogleFonts.abel(
          color: AppColors.textLight,
          fontSize: 14,
          textStyle: TextStyle(
            fontFamilyFallback: [
              GoogleFonts.notoSansTifinagh().fontFamily ?? 'Noto Sans Tifinagh',
            ],
          ),
        ),
      ),
    );
  }

  String _getLocaleCodeLabel(String code) {
    switch (code) {
      case 'fr':
        return 'FR';
      case 'en':
        return 'EN';
      case 'ar':
        return 'AR';
      case 'kab':
      case 'zgh':
        return 'TZM';
      default:
        return code.toUpperCase();
    }
  }
}
