import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item.dart';
import '../../../state/game_state.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({super.key});

  static const _tabs = [
    _TabConfig('全部', ItemTypeFilter.all),
    _TabConfig('装备', ItemTypeFilter.equipment),
    _TabConfig('消耗', ItemTypeFilter.consumables),
    _TabConfig('杂物', ItemTypeFilter.others),
  ];

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final items = game.player.inventory;
    final theme = Theme.of(context);

    return DefaultTabController(
      length: _tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '背包',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '容量：${items.length}/${game.bagCapacity}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: items.length >= game.bagCapacity
                            ? theme.colorScheme.error
                            : theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () =>
                          context.read<GameState>().sortInventory(),
                      icon: const Icon(Icons.sort, size: 20),
                      tooltip: '一键整理',
                    ),
                  ],
                ),
              ],
            ),
          ),
          TabBar(
            isScrollable: true,
            tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: _tabs.map((t) {
                final filtered = t.apply(items);
                return _InventoryGrid(
                  items: filtered,
                  capacity: game.bagCapacity,
                  showEmptySlots: t.filter == ItemTypeFilter.all,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryGrid extends StatelessWidget {
  const _InventoryGrid({
    required this.items,
    required this.capacity,
    this.showEmptySlots = false,
  });

  final List<Item> items;
  final int capacity;
  final bool showEmptySlots;

  static const int _columns = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalSlots = showEmptySlots ? capacity : items.length;

    if (totalSlots == 0) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.backpack_outlined,
              size: 64,
              color: theme.disabledColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text('暂无此类物品', style: theme.textTheme.bodyMedium),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        childAspectRatio: 0.9,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < items.length) {
          return _InventoryTile(item: items[index]);
        }
        return const _EmptyTile();
      },
    );
  }
}

class _EmptyTile extends StatelessWidget {
  const _EmptyTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.disabledColor.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.add,
          size: 20,
          color: theme.disabledColor.withValues(alpha: 0.1),
        ),
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  const _InventoryTile({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _rarityColors(item.rarity);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _showDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colors.border.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.fill,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -6),
                    child: Text(
                      _glyph(item),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colors.border,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Text(
                  item.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (item.count > 1)
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${item.count}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final game = context.read<GameState>();
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                child: Icon(
                  _icon(item),
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                item.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (item.type == ItemType.consumable)
                    FilledButton.icon(
                      onPressed: () {
                        game.useConsumable(item);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('使用'),
                    ),
                  if (item.type == ItemType.equipment)
                    FilledButton.icon(
                      onPressed: () {
                        game.equipItem(item);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shield),
                      label: const Text('装备'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () {
                      game.discard(item);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('丢弃'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _RarityColors _rarityColors(ItemRarity r) {
    switch (r) {
      case ItemRarity.common:
        return _RarityColors(Colors.grey, Colors.grey.withValues(alpha: 0.12));
      case ItemRarity.uncommon:
        return _RarityColors(
          Colors.green,
          Colors.green.withValues(alpha: 0.12),
        );
      case ItemRarity.rare:
        return _RarityColors(Colors.blue, Colors.blue.withValues(alpha: 0.12));
      case ItemRarity.epic:
        return _RarityColors(
          Colors.purple,
          Colors.purple.withValues(alpha: 0.12),
        );
      case ItemRarity.legendary:
        return _RarityColors(
          Colors.amber,
          Colors.amber.withValues(alpha: 0.12),
        );
      case ItemRarity.mythic:
        return _RarityColors(Colors.red, Colors.red.withValues(alpha: 0.12));
    }
  }

  String _glyph(Item item) {
    switch (item.type) {
      case ItemType.equipment:
        switch (item.slot) {
          case EquipmentSlot.soulbound:
            return '灵';
          case EquipmentSlot.mainHand:
            return '兵';
          case EquipmentSlot.body:
            return '甲';
          case EquipmentSlot.accessory:
            return '饰';
          case EquipmentSlot.guard:
            return '护';
          case EquipmentSlot.mount:
            return '驾';
          default:
            return '器';
        }
      case ItemType.consumable:
        return '丹';
      case ItemType.storage:
        return '囊';
      case ItemType.other:
        return '杂';
    }
  }

  IconData _icon(Item item) {
    switch (item.type) {
      case ItemType.equipment:
        switch (item.slot) {
          case EquipmentSlot.soulbound:
            return Icons.auto_awesome;
          case EquipmentSlot.mainHand:
            return Icons.hardware;
          case EquipmentSlot.body:
            return Icons.shield;
          case EquipmentSlot.accessory:
            return Icons.diamond;
          case EquipmentSlot.guard:
            return Icons.security;
          case EquipmentSlot.mount:
            return Icons.flight;
          default:
            return Icons.hardware;
        }
      case ItemType.consumable:
        return Icons.local_pharmacy;
      case ItemType.storage:
        return Icons.backpack;
      case ItemType.other:
        return Icons.help_outline;
    }
  }
}

class _RarityColors {
  const _RarityColors(this.border, this.fill);
  final Color border;
  final Color fill;
}

class _TabConfig {
  const _TabConfig(this.label, this.filter);
  final String label;
  final ItemTypeFilter filter;

  List<Item> apply(List<Item> all) {
    switch (filter) {
      case ItemTypeFilter.equipment:
        return all.where((i) => i.type == ItemType.equipment).toList();
      case ItemTypeFilter.consumables:
        return all.where((i) => i.type == ItemType.consumable).toList();
      case ItemTypeFilter.others:
        return all
            .where(
              (i) => i.type == ItemType.other || i.type == ItemType.storage,
            )
            .toList();
      case ItemTypeFilter.all:
        return all;
    }
  }
}

enum ItemTypeFilter { all, equipment, consumables, others }
