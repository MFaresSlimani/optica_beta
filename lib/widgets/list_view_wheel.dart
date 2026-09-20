// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'wheel_item.dart';

class ListViewWheel extends StatelessWidget {
  const ListViewWheel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      children: const [
        WheelItem(title: 'HCT 1.56'),
        SizedBox(width: 8),
        WheelItem(title: 'Blue Block 1.56'),
        SizedBox(width: 8),
        WheelItem(title: 'HMC 1.56'),
        SizedBox(width: 8),
        WheelItem(title: 'HMC 1.61'),
        SizedBox(width: 8),
        WheelItem(title: 'HMC 1.67'),
        SizedBox(width: 8),
        WheelItem(title: 'HMC 1.74'),
        SizedBox(width: 8),
        WheelItem(title: 'Photochromique Gris'),
        SizedBox(width: 8),
        WheelItem(title: 'Photochromique Brun'),
        SizedBox(width: 8),
        WheelItem(title: 'Hydrophobe'),
        SizedBox(width: 8),
        WheelItem(title: 'Oléophobe'),
        SizedBox(width: 8),
        WheelItem(title: 'Blanc Organique'),
        SizedBox(width: 8),
        WheelItem(title: 'Polycarbonate'),
        SizedBox(width: 8),
        WheelItem(title: 'Transitions'),
        SizedBox(width: 8),
        WheelItem(title: 'Trivex'),
        SizedBox(width: 8),
        WheelItem(title: 'UV400'),
        SizedBox(width: 8),
        WheelItem(title: 'Polarisé'),
      ],
    );
  }
}
