import '../models/item.dart';

class ItemsRepository {
  static const Map<String, Item> _items = {
    'herb': Item(
      id: 'herb',
      name: '疗伤草',
      description: '服用可恢复气血。',
      type: ItemType.consumable,
      hpBonus: 25,
    ),
    'rusty_sword': Item(
      id: 'rusty_sword',
      name: '生锈铁剑',
      description: '旧铁剑，聊胜于无。',
      type: ItemType.weapon,
      attackBonus: 5,
    ),
    'cloth_robe': Item(
      id: 'cloth_robe',
      name: '粗布护衣',
      description: '最简单的护身布衣，略有防护。',
      type: ItemType.armor,
      defenseBonus: 3,
    ),
  };

  static Item? get(String id) => _items[id];

  static List<Item> getAll() => _items.values.toList();
}
