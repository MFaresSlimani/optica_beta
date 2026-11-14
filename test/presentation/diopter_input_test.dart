import 'package:bng_optica/data/models/diopter.dart';
import 'package:bng_optica/presentation/modules/order/controllers/diopter_input.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late DiopterInput input;

  setUp(() => input = DiopterInput());
  tearDown(() => input.dispose());

  test('starts at +0.00 with wheels for 0–10 and four quarters', () {
    expect(input.value.value, Diopter.zero);
    expect(input.negative.value, isFalse);
    expect(DiopterInput.wholeCount, 11);
    expect(DiopterInput.quarterCount, 4);
  });

  test('the wheels compose the power', () {
    input
      ..onWholeChanged(3)
      ..onQuarterChanged(1);
    expect(input.value.value.format(), '+3.25');
  });

  test('the sign can be set first, before spinning the wheels', () {
    input.toggleSign();
    expect(input.negative.value, isTrue, reason: 'sign is kept even while the value is zero');
    input
      ..onWholeChanged(2)
      ..onQuarterChanged(2);
    expect(input.value.value.format(), '-2.50');
  });

  test('flipping the sign keeps the magnitude', () {
    input
      ..onWholeChanged(1)
      ..onQuarterChanged(3)
      ..toggleSign();
    expect(input.value.value.format(), '-1.75');
    input.toggleSign();
    expect(input.value.value.format(), '+1.75');
  });

  test('setValue updates all parts', () {
    input.setValue(Diopter.fromValue(-10.75));
    expect(input.negative.value, isTrue);
    expect(input.value.value.format(), '-10.75');
    input.onQuarterChanged(0);
    expect(input.value.value.format(), '-10.00');
  });

  test('an initial value seeds the wheels', () {
    final seeded = DiopterInput(initial: Diopter.fromValue(-4.5));
    addTearDown(seeded.dispose);
    expect(seeded.wholeWheel.initialItem, 4);
    expect(seeded.quarterWheel.initialItem, 2);
    expect(seeded.negative.value, isTrue);
  });
}
