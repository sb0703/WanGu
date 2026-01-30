part of '../game_state.dart';

extension InventoryLogic on GameState {
  void discard(Item item) {
    if (!_player.inventory.contains(item)) {
      return;
    }
    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(inventory: newInventory);
    _log('丢弃了 ${item.name}');
    notify();
  }

  void equipItem(Item item) {
    if (!_player.inventory.contains(item)) return;

    // Level Requirement Check
    if (_player.level < item.levelReq) {
      _log('境界未稳，无法驾驭此宝（需 ${item.levelReq}）');
      return;
    }

    // Determine slot logic
    List<Item> newEquipped = [..._player.equipped];
    List<Item> newInventory = [..._player.inventory];
    newInventory.remove(item);

    Item? unequippedItem;

    if (item.type == ItemType.equipment && item.slot != null) {
      final current = _getEquippedInSlot(item.slot!);
      if (current != null) {
        newEquipped.remove(current);
        unequippedItem = current;
      }
    } else {
      // Generic fallback or fail
      _log('无法装备 ${item.name}');
      return;
    }

    newEquipped.add(item);
    if (unequippedItem != null) {
      // Check if unequipping causes overflow?
      // For now, force add to inventory even if full (or drop? safely add)
      // Since we are swapping, space used is net 0 or +1 if storage removed.
      // If we remove a storage bag, capacity shrinks!
      // This is tricky. If capacity shrinks below current count, what happens?
      // Usually games allow over-capacity but prevent adding NEW items.
      newInventory.add(unequippedItem);
    }

    _player = _player.copyWith(inventory: newInventory, equipped: newEquipped);

    // Log result
    if (unequippedItem != null) {
      _log('装备了 ${item.name}，替换掉 ${unequippedItem.name}');
    } else {
      _log('装备了 ${item.name}');
    }
    notify();
  }

  // Deprecated specific equip methods, redirect to generic
  void equipWeapon(Item item) => equipItem(item);
  void equipArmor(Item item) => equipItem(item);

  void sortInventory() {
    // Sort logic:
    // 1. Rarity (Descending: Mythic -> Common)
    // 2. Type (Weapon -> Armor -> Storage -> Consumable -> Other)
    // 3. Level Requirement (Descending)
    // 4. ID (Alphabetical)

    final sorted = [..._player.inventory];
    sorted.sort((a, b) {
      // 1. Rarity
      if (a.rarity.index != b.rarity.index) {
        return b.rarity.index.compareTo(
          a.rarity.index,
        ); // Higher index = higher rarity
      }
      // 2. Type
      if (a.type.index != b.type.index) {
        return a.type.index.compareTo(b.type.index);
      }
      // 3. Level
      if (a.levelReq != b.levelReq) {
        return b.levelReq.compareTo(a.levelReq);
      }
      // 4. ID
      return a.id.compareTo(b.id);
    });

    _player = _player.copyWith(inventory: sorted);
    _log('背包已整理。');
    notify();
  }

  void useConsumable(Item item) {
    if (item.type != ItemType.consumable || !_player.inventory.contains(item)) {
      return;
    }
    var newStats = _player.stats.healHp(item.hpBonus);
    if (item.spiritBonus != 0) {
      newStats = newStats.healSpirit(item.spiritBonus);
    }

    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(inventory: newInventory, stats: newStats);

    final parts = <String>[];
    if (item.hpBonus > 0) parts.add('气血+${item.hpBonus}');
    if (item.spiritBonus > 0) parts.add('灵力+${item.spiritBonus}');
    final effectMsg = parts.isNotEmpty ? '，${parts.join(' ')}' : '';

    _log('服用了 ${item.name}$effectMsg');
    notify();
  }
}
