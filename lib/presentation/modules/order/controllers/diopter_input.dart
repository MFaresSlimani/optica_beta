import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_config.dart';
import '../../../../data/models/diopter.dart';

/// State of one power picker (sphere or cylinder): a sign toggle, a wheel
/// for whole diopters (0–10) and a wheel for the decimal (.00 .25 .50 .75).
///
/// The sign is kept separately from the value so an optician can flip it to
/// minus first and then spin the wheels, exactly like the original picker.
class DiopterInput {
  DiopterInput({Diopter initial = Diopter.zero})
    : negative = initial.isNegative.obs,
      value = initial.obs,
      _whole = initial.wholePart,
      _quarter = initial.quarterPart,
      wholeWheel = FixedExtentScrollController(initialItem: initial.wholePart),
      quarterWheel = FixedExtentScrollController(initialItem: initial.quarterPart);

  static const int wholeCount = LensCatalog.maxWholeDiopters + 1;
  static const int quarterCount = 4;

  final RxBool negative;
  final Rx<Diopter> value;
  final FixedExtentScrollController wholeWheel;
  final FixedExtentScrollController quarterWheel;

  int _whole;
  int _quarter;

  void toggleSign() {
    negative.toggle();
    _update();
  }

  void onWholeChanged(int index) {
    _whole = index;
    _update();
  }

  void onQuarterChanged(int index) {
    _quarter = index;
    _update();
  }

  /// Sets all three parts at once and moves the wheels to match.
  void setValue(Diopter diopter) {
    negative.value = diopter.isNegative;
    _whole = diopter.wholePart;
    _quarter = diopter.quarterPart;
    _update();
    if (wholeWheel.hasClients) wholeWheel.jumpToItem(_whole);
    if (quarterWheel.hasClients) quarterWheel.jumpToItem(_quarter);
  }

  void _update() {
    value.value = Diopter.fromParts(negative: negative.value, whole: _whole, quarter: _quarter);
  }

  void dispose() {
    wholeWheel.dispose();
    quarterWheel.dispose();
  }
}
