// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/constants/app_colors.dart';
import '../screens/request_screen/make_request.dart';

class WheelItem extends StatelessWidget {
  final String title;

  const WheelItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final GlassesController glassesController = Get.find<GlassesController>();

    return GestureDetector(
      onTap: () {
        glassesController.selectType(title);
      },
      child: Obx(
        () {
          final isSelected = glassesController.selectedType.value == title;
          final isDark = Theme.of(context).brightness == Brightness.dark;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.accent
                  : (isDark ? const Color(0xFF0F363F) : Colors.white),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.accentLight
                    : (isDark
                        ? AppColors.accent.withValues(alpha: 0.25)
                        : Colors.brown.shade200),
                width: isSelected ? 1.8 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? AppColors.accent.withValues(alpha: 0.35)
                      : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: isSelected ? 8 : 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              title,
              style: GoogleFonts.abel(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.primary),
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
