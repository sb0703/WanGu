part of '../game_state.dart';

extension InventoryLogic on GameState {
  void discard(Item item) {
    final index = _player.inventory.indexOf(item);
    if (index == -1) return;

    final existing = _player.inventory[index];
    List<Item> newInventory = [..._player.inventory];

    if (existing.count > 1) {
      newInventory[index] = existing.copyWith(count: existing.count - 1);
      _log('丢弃了 1 个 ${item.name}，剩余 ${existing.count - 1}');
    } else {
      newInventory.removeAt(index);
      _log('丢弃了 ${item.name}');
    }

    _player = _player.copyWith(inventory: newInventory);
    updateAllCollectionProgress();
    notify();
  }

  void equipItem(Item item) {
    final index = _player.inventory.indexOf(item);
    if (index == -1) return;

    // Level Requirement Check
    if (_player.level < item.levelReq) {
      _log('境界未稳，无法驾驭此宝（需 ${item.levelReq}）');
      return;
    }

    // Determine slot logic
    List<Item> newEquipped = [..._player.equipped];
    List<Item> newInventory = [..._player.inventory];

    // Handle stack splitting
    Item itemToEquip;
    if (item.count > 1) {
      // Split stack
      newInventory[index] = item.copyWith(count: item.count - 1);
      itemToEquip = item.copyWith(count: 1);
    } else {
      // Remove entirely
      newInventory.removeAt(index);
      itemToEquip = item;
    }

    Item? unequippedItem;

    if (itemToEquip.type == ItemType.equipment && itemToEquip.slot != null) {
      final current = _getEquippedInSlot(itemToEquip.slot!);
      if (current != null) {
        newEquipped.remove(current);
        unequippedItem = current;
      }
    } else if (itemToEquip.type == ItemType.storage) {
      // Storage logic... simplified for now, assuming similar slot or logic?
      // Current code doesn't explicitly handle storage slot differently in _getEquippedInSlot
      // unless storage has a slot assigned.
      // Assuming storage items have slot (e.g. accessory/mount/etc or special logic)
      if (itemToEquip.slot != null) {
        final current = _getEquippedInSlot(itemToEquip.slot!);
        if (current != null) {
          newEquipped.remove(current);
          unequippedItem = current;
        }
      }
    } else {
      // Generic fallback or fail
      _log('无法装备 ${itemToEquip.name}');
      // If we split the stack, we need to revert?
      // Actually, if we fail here, we should just return and do nothing.
      // But we already modified newInventory local var.
      // So just returning is fine, _player is not updated yet.
      return;
    }

    newEquipped.add(itemToEquip);

    // Handle unequipped item returning to inventory
    if (unequippedItem != null) {
      // Add back to inventory (using _addItem logic effectively, but we are inside logic)
      // We should check stacking for the returned item too!
      // But _addItem is on GameState. Here we are manipulating lists directly.
      // We should replicate stacking logic or call a helper?
      // Replicating simple stacking for unequipped item:
      if (unequippedItem.stackable) {
        final existingIndex = newInventory.indexWhere(
          (i) => i.id == unequippedItem!.id,
        );
        if (existingIndex != -1) {
          final existing = newInventory[existingIndex];
          newInventory[existingIndex] = existing.copyWith(
            count: existing.count + unequippedItem.count,
          );
          unequippedItem = null; // Mark as merged
        }
      }

      if (unequippedItem != null) {
        newInventory.add(unequippedItem);
      }
    }

    _player = _player.copyWith(inventory: newInventory, equipped: newEquipped);

    // Log result
    if (unequippedItem != null) {
      // We might have merged it, but we can still say we replaced it.
      // If merged, unequippedItem var is null locally, so we need original ref for logging?
      // Or just simplified log.
      _log('装备了 ${itemToEquip.name}');
    } else {
      _log('装备了 ${itemToEquip.name}');
    }
    updateAllCollectionProgress();
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
    updateAllCollectionProgress();
    notify();
  }
}
