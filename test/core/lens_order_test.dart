import 'package:bng_optica/core/utils/lens_order.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/sample_data.dart';

void main() {
  final hmc = Sample.lens('HMC 1.61', -2.25, -0.5, 2);
  final blue = Sample.lens('Blue Block 1.56', 1, 0, 1);

  group('LensOrder.add', () {
    test('appends a new lens', () {
      expect(LensOrder.add([hmc], blue), [hmc, blue]);
    });

    test('merges quantity into an identical lens in place', () {
      final result = LensOrder.add([hmc, blue], hmc.copyWith(quantity: 3));
      expect(result, hasLength(2));
      expect(result.first.quantity, 5);
      expect(result.last, blue);
    });

    test('never mutates the input list', () {
      final lines = [hmc];
      LensOrder.add(lines, hmc);
      expect(lines.single.quantity, 2);
    });
  });

  test('consolidate folds duplicates keeping first-seen order', () {
    final result = LensOrder.consolidate([hmc, blue, hmc, blue, hmc]);
    expect(result.map((l) => l.quantity), [6, 2]);
    expect(result.first.type, 'HMC 1.61');
  });

  test('totalQuantity', () {
    expect(LensOrder.totalQuantity([hmc, blue]), 3);
    expect(LensOrder.totalQuantity(const []), 0);
  });

  test('split partitions by supplied index', () {
    final lines = Sample.orderLines;
    final split = LensOrder.split(lines, {0, 2});
    expect(split.done, [lines[0], lines[2]]);
    expect(split.left, [lines[1]]);
  });
}
