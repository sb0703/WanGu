/// 角色属性模型
class Stats {
  const Stats({
    required this.maxHp,
    required this.hp,
    this.maxSpirit = 0,
    this.spirit = 0,
    required this.attack,
    required this.defense,
    required this.speed,
    this.insight = 0,
    this.purity = 0,
  });

  final int maxHp; // 最大气血
  final int hp; // 当前气血
  final int maxSpirit; // 最大灵力
  final int spirit; // 当前灵力/法力
  final int attack; // 攻击力
  final int defense; // 防御力
  final int speed; // 速度 (决定出手顺序)
  final int insight; // 悟性 (影响经验获取效率)
  final int purity; // 纯净度 (影响突破成功率等)

  /// 恢复气血
  Stats healHp(int value) => copyWith(hp: (hp + value).clamp(0, maxHp));

  /// 受到伤害
  Stats takeDamage(int value) => copyWith(hp: (hp - value).clamp(0, maxHp));

  /// 恢复灵力
  Stats healSpirit(int value) =>
      copyWith(spirit: (spirit + value).clamp(0, maxSpirit));

  /// 消耗灵力
  Stats spendSpirit(int value) =>
      copyWith(spirit: (spirit - value).clamp(0, maxSpirit));

  Stats copyWith({
    int? maxHp,
    int? hp,
    int? maxSpirit,
    int? spirit,
    int? attack,
    int? defense,
    int? speed,
    int? insight,
    int? purity,
  }) {
    return Stats(
      maxHp: maxHp ?? this.maxHp,
      hp: hp ?? this.hp,
      maxSpirit: maxSpirit ?? this.maxSpirit,
      spirit: spirit ?? this.spirit,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      insight: insight ?? this.insight,
      purity: purity ?? this.purity,
    );
  }

  /// 属性相加 (用于计算总属性)
  Stats operator +(Stats other) {
    return Stats(
      maxHp: maxHp + other.maxHp,
      hp: hp, // 当前气血通常不直接受属性修正影响 (除非特定逻辑)
      maxSpirit: maxSpirit + other.maxSpirit,
      spirit: spirit, // 当前灵力通常不直接受属性修正影响
      attack: attack + other.attack,
      defense: defense + other.defense,
      speed: speed + other.speed,
      insight: insight + other.insight,
      purity: purity + other.purity,
    );
  }
}
