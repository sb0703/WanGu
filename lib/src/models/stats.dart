class Stats {
  const Stats({
    required this.maxHp,
    required this.hp,
    required this.spirit,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.insight,
  });

  final int maxHp;
  final int hp;
  final int spirit; // 灵力/法力
  final int attack;
  final int defense;
  final int speed;
  final int insight; // 悟性或经验效率

  Stats healHp(int value) => copyWith(hp: (hp + value).clamp(0, maxHp));

  Stats takeDamage(int value) => copyWith(hp: (hp - value).clamp(0, maxHp));

  Stats copyWith({
    int? maxHp,
    int? hp,
    int? spirit,
    int? attack,
    int? defense,
    int? speed,
    int? insight,
  }) {
    return Stats(
      maxHp: maxHp ?? this.maxHp,
      hp: hp ?? this.hp,
      spirit: spirit ?? this.spirit,
      attack: attack ?? this.attack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
      insight: insight ?? this.insight,
    );
  }
}
