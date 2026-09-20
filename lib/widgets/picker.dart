import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wheel_picker/wheel_picker.dart';

import '../core/constants/app_colors.dart';

class Picker extends StatefulWidget {
  final String title;
  final RxDouble overall;

  const Picker({
    super.key,
    required this.title,
    required this.overall,
  });

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  double _integerPart = 0.0;
  double _decimalPart = 0.0;
  int _sign = 1;

  late final WheelPickerController _intController;
  late final WheelPickerController _decController;

  @override
  void initState() {
    super.initState();
    _intController = WheelPickerController(itemCount: 11);
    _decController = WheelPickerController(itemCount: 4);

    // Initialize from current overall value if any
    final current = widget.overall.value;
    if (current < 0) {
      _sign = -1;
    } else {
      _sign = 1;
    }
    final absVal = current.abs();
    _integerPart = absVal.truncateToDouble();
    _decimalPart = ((absVal - _integerPart) * 100).roundToDouble();

    final intIndex = _integerPart.toInt().clamp(0, 10);
    final decIndex = (_decimalPart / 25).round().clamp(0, 3);
    _intController.setCurrent(intIndex);
    _decController.setCurrent(decIndex);
  }

  void _updateOverall() {
    widget.overall.value = (_integerPart + (_decimalPart * 0.01)) * _sign;
  }

  void _toggleSign() {
    setState(() {
      _sign = -_sign;
      _updateOverall();
    });
  }

  @override
  void dispose() {
    _intController.dispose();
    _decController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.primary;
    final cardBg = isDark ? const Color(0xFF0F363F) : Colors.white;
    final borderColor = isDark ? AppColors.accent.withValues(alpha: 0.35) : Colors.brown.shade200;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: GoogleFonts.abel(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.accentLight : AppColors.primary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 80,
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sign Toggle Button (+ / -)
              GestureDetector(
                onTap: _toggleSign,
                child: Container(
                  width: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _sign >= 0 ? '+' : '-',
                      style: GoogleFonts.abel(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Integer Wheel (0..10)
              Expanded(
                flex: 5,
                child: WheelPicker(
                  looping: false,
                  controller: _intController,
                  style: const WheelPickerStyle(
                    itemExtent: 32,
                    squeeze: 1.3,
                    diameterRatio: 0.85,
                    surroundingOpacity: 0.35,
                    magnification: 1.15,
                  ),
                  builder: (context, index) => Center(
                    child: Text(
                      index.toString(),
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  onIndexChanged: (index, _) {
                    _integerPart = index.toDouble();
                    _updateOverall();
                  },
                ),
              ),

              // Decimal Point Separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Center(
                  child: Text(
                    '.',
                    style: GoogleFonts.abel(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),

              // Decimal Wheel (.00, .25, .50, .75)
              Expanded(
                flex: 5,
                child: WheelPicker(
                  looping: false,
                  controller: _decController,
                  style: const WheelPickerStyle(
                    itemExtent: 32,
                    squeeze: 1.3,
                    diameterRatio: 0.85,
                    surroundingOpacity: 0.35,
                    magnification: 1.15,
                  ),
                  builder: (context, index) => Center(
                    child: Text(
                      index == 0 ? '00' : (index * 25).toString(),
                      style: GoogleFonts.abel(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                  ),
                  onIndexChanged: (index, _) {
                    _decimalPart = (index * 25).toDouble();
                    _updateOverall();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
