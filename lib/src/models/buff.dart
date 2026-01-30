import 'stats.dart';

enum BuffType {
  positive, // 增益
  negative, // 减益 (Debuff)
  mixed, // 混合 (如: 虎臂)
}

class Buff {
  final String id;
  final String name;
  final String description;
  final BuffType type;
  final Stats statModifiers; // 属性修正 (可以是负数)

  const Buff({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.statModifiers = const Stats(
      maxHp: 0,
      hp: 0,
      maxSpirit: 0,
      spirit: 0,
      attack: 0,
      defense: 0,
      speed: 0,
      insight: 0,
      purity: 0,
    ),
  });

  bool get isDebuff => type == BuffType.negative;
}
