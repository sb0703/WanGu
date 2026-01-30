import 'package:flutter_test/flutter_test.dart';
import 'package:wanggu_flutter/src/models/item.dart';
import 'package:wanggu_flutter/src/utils/element_logic.dart';

void main() {
  group('ElementLogic', () {
    test('Metal beats Wood', () {
      expect(
        ElementLogic.getMultiplier(ElementType.metal, ElementType.wood),
        1.5,
      );
    });

    test('Metal loses to Fire', () {
      expect(
        ElementLogic.getMultiplier(ElementType.metal, ElementType.fire),
        0.75,
      );
    });

    test('Metal neutral to Water', () {
      expect(
        ElementLogic.getMultiplier(ElementType.metal, ElementType.water),
        1.0,
      );
    });

    test('None is neutral', () {
      expect(
        ElementLogic.getMultiplier(ElementType.none, ElementType.metal),
        1.0,
      );
      expect(
        ElementLogic.getMultiplier(ElementType.metal, ElementType.none),
        1.0,
      );
    });

    test('Cycle Completeness', () {
      // Metal > Wood > Earth > Water > Fire > Metal
      expect(
        ElementLogic.getMultiplier(ElementType.metal, ElementType.wood),
        1.5,
      );
      expect(
        ElementLogic.getMultiplier(ElementType.wood, ElementType.earth),
        1.5,
      );
      expect(
        ElementLogic.getMultiplier(ElementType.earth, ElementType.water),
        1.5,
      );
      expect(
        ElementLogic.getMultiplier(ElementType.water, ElementType.fire),
        1.5,
      );
      expect(
        ElementLogic.getMultiplier(ElementType.fire, ElementType.metal),
        1.5,
      );
    });
  });
}
