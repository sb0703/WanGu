enum ItemType { weapon, armor, consumable, storage, other }

enum EquipmentSlot { weapon, armor, back, waist, hand, accessory }

enum ItemRarity {
  common, // 凡 (Gray)
  uncommon, // 良 (Green)
  rare, // 优 (Blue)
  epic, // 极 (Purple)
  legendary, // 传说 (Gold)
  mythic, // 神话 (Red)
}

class Item {
  const Item({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.rarity = ItemRarity.common,
    this.slot,
    this.attackBonus = 0,
    this.defenseBonus = 0,
    this.hpBonus = 0,
    this.spiritBonus = 0,
    this.speed = 0,
    this.spaceBonus = 0,
    this.levelReq = 1,
    this.price = 0,
  });

  final String id;
  final String name;
  final String description;
  final ItemType type;
  final ItemRarity rarity;
  final EquipmentSlot? slot;
  final int attackBonus;
  final int defenseBonus;
  final int hpBonus;
  final int spiritBonus;
  final int speed;
  final int spaceBonus;
  final int levelReq;
  final int price; // Value in spirit stones/gold
}
