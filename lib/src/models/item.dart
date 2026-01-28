enum ItemType { weapon, armor, consumable }

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.attackBonus = 0,
    this.defenseBonus = 0,
    this.hpBonus = 0,
  });

  final String id;
  final String name;
  final String description;
  final ItemType type;
  final int attackBonus;
  final int defenseBonus;
  final int hpBonus;
}
