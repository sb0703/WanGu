import '../models/item.dart';
import 'items/currencies.dart';
import 'items/pills.dart';
import 'items/materials.dart';
import 'items/equipment.dart';
import 'items/talismans.dart';
import 'items/legacy.dart';
import 'items/containers.dart';

class ItemsRepository {
  static final Map<String, Item> _items = {
    ...currencyItems,
    ...pillItems,
    ...materialItems,
    ...equipmentItems,
    ...talismanItems,
    ...legacyItems,
    ...containerItems,
  };

  static Item? get(String id) => _items[id];

  static List<Item> getAll() => _items.values.toList();
}
