/// 物品类型枚举
enum ItemType {
  equipment, // 装备
  consumable, // 消耗品
  storage, // 储物
  other, // 其他
}

/// 装备部位枚举
enum EquipmentSlot {
  soulbound, // 本命
  mainHand, // 主手
  body, // 身甲
  accessory, // 饰品
  guard, // 护身
  mount, // 座驾
}

/// 元素类型枚举
enum ElementType {
  none, // 无
  metal, // 金
  wood, // 木
  water, // 水
  fire, // 火
  earth, // 土
}

/// 物品稀有度枚举
enum ItemRarity {
  common, // 凡 (Gray)
  uncommon, // 良 (Green)
  rare, // 优 (Blue)
  epic, // 极 (Purple)
  legendary, // 传说 (Gold)
  mythic, // 神话 (Red)
}

/// 物品模型
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

  final String id; // ID
  final String name; // 名称
  final String description; // 描述
  final ItemType type; // 类型
  final ItemRarity rarity; // 稀有度
  final EquipmentSlot? slot; // 装备部位 (如果是装备)
  final ElementType element; // 五行属性
  final int attackBonus; // 攻击加成
  final int defenseBonus; // 防御加成
  final int hpBonus; // 气血加成
  final int spiritBonus; // 灵力加成
  final int speed; // 速度加成
  final int spaceBonus; // 空间加成 (用于储物袋)
  final int levelReq; // 等级要求
  final int price; // 价格 (灵石/金币)
}
