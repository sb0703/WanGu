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

  Stats operator +(Stats other) {
    return Stats(
      maxHp: maxHp + other.maxHp,
      hp: hp, // Current HP is not affected by stat modifiers directly in this calculation
      maxSpirit: maxSpirit + other.maxSpirit,
      spirit: spirit, // Current Spirit is not affected
      attack: attack + other.attack,
      defense: defense + other.defense,
      speed: speed + other.speed,
      insight: insight + other.insight,
      purity: purity + other.purity,
    );
  }
}
