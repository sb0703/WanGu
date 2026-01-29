class Stats {
  const Stats({
    required this.maxHp,
    required this.hp,
    required this.maxSpirit,
    required this.spirit,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.insight,
    this.purity = 100, // 灵气纯度 0-100
  });

  final int maxHp;
  final int hp;
  final int maxSpirit;
  final int spirit; // 灵力/法力
  final int attack;
  final int defense;
  final int speed;
  final int insight; // 悟性或经验效率
  final int purity;

  Stats healHp(int value) => copyWith(hp: (hp + value).clamp(0, maxHp));

  Stats takeDamage(int value) => copyWith(hp: (hp - value).clamp(0, maxHp));

  Stats healSpirit(int value) =>
      copyWith(spirit: (spirit + value).clamp(0, maxSpirit));

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
}
