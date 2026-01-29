class RealmStage {
  const RealmStage({
    required this.name,
    required this.maxXp,
    required this.hpBonus,
    required this.attackBonus,
    required this.spiritBonus,
  });

  final String name;
  final int maxXp;
  final int hpBonus;
  final int attackBonus;
  final int spiritBonus;

  static const stages = <RealmStage>[
    RealmStage(
      name: '练气',
      maxXp: 200,
      hpBonus: 0,
      attackBonus: 0,
      spiritBonus: 0,
    ),
    RealmStage(
      name: '筑基',
      maxXp: 1000,
      hpBonus: 30,
      attackBonus: 5,
      spiritBonus: 20,
    ),
    RealmStage(
      name: '金丹',
      maxXp: 5000,
      hpBonus: 80,
      attackBonus: 12,
      spiritBonus: 60,
    ),
    RealmStage(
      name: '元婴',
      maxXp: 20000,
      hpBonus: 150,
      attackBonus: 25,
      spiritBonus: 120,
    ),
  ];
}
