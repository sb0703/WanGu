enum ItemType { equipment, consumable, storage, other }

enum EquipmentSlot {
  soulbound, // 本命
  mainHand, // 主手
  body, // 身甲
  accessory, // 饰品
  guard, // 护身
  mount, // 座驾
}

enum ElementType {
  none,
  metal, // 金
  wood, // 木
  water, // 水
  fire, // 火
  earth, // 土
}

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
    this.element = ElementType.none,
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
  final ElementType element;
  final int attackBonus;
  final int defenseBonus;
  final int hpBonus;
  final int spiritBonus;
  final int speed;
  final int spaceBonus;
  final int levelReq;
  final int price; // Value in spirit stones/gold
}
