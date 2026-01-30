import 'package:flutter/material.dart';
import '../models/item.dart';

class ElementLogic {
  /// 获取五行克制倍率
  /// 金克木，木克土，土克水，水克火，火克金
  static double getMultiplier(ElementType attacker, ElementType defender) {
    if (attacker == ElementType.none || defender == ElementType.none) {
      return 1.0;
    }

    switch (attacker) {
      case ElementType.metal:
        if (defender == ElementType.wood) return 1.5;
        if (defender == ElementType.fire) return 0.75;
        break;
      case ElementType.wood:
        if (defender == ElementType.earth) return 1.5;
        if (defender == ElementType.metal) return 0.75;
        break;
      case ElementType.water:
        if (defender == ElementType.fire) return 1.5;
        if (defender == ElementType.earth) return 0.75;
        break;
      case ElementType.fire:
        if (defender == ElementType.metal) return 1.5;
        if (defender == ElementType.water) return 0.75;
        break;
      case ElementType.earth:
        if (defender == ElementType.water) return 1.5;
        if (defender == ElementType.wood) return 0.75;
        break;
      case ElementType.none:
        return 1.0;
    }
    return 1.0;
  }

  static String getName(ElementType type) {
    switch (type) {
      case ElementType.metal:
        return '金';
      case ElementType.wood:
        return '木';
      case ElementType.water:
        return '水';
      case ElementType.fire:
        return '火';
      case ElementType.earth:
        return '土';
      case ElementType.none:
        return '无';
    }
  }

  static Color getColor(ElementType type) {
    switch (type) {
      case ElementType.metal:
        return Colors.amberAccent;
      case ElementType.wood:
        return Colors.green;
      case ElementType.water:
        return Colors.blue;
      case ElementType.fire:
        return Colors.red;
      case ElementType.earth:
        return Colors.brown;
      case ElementType.none:
        return Colors.grey;
    }
  }
}
