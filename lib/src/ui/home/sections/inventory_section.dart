import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item.dart';
import '../../../state/game_state.dart';

class InventorySection extends StatefulWidget {
  const InventorySection({super.key});

  @override
  State<InventorySection> createState() => _InventorySectionState();
}

class _InventorySectionState extends State<InventorySection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final allItems = game.player.inventory;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          child: Column(
            children: [
              Row(
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
                        '容量：${allItems.length}/${game.bagCapacity}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: allItems.length >= game.bagCapacity
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
              const SizedBox(height: 8),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: const [
                  Tab(text: '全部'),
                  Tab(text: '武器'),
                  Tab(text: '防具'),
                  Tab(text: '丹药'),
                  Tab(text: '杂物'),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _PagedInventoryGrid(
                items: allItems,
                capacity: game.bagCapacity,
                showEmptySlots: true,
              ),
              _PagedInventoryGrid(
                items: allItems
                    .where((i) => i.type == ItemType.weapon)
                    .toList(),
                capacity: game.bagCapacity,
              ),
              _PagedInventoryGrid(
                items: allItems
                    .where(
                      (i) =>
                          i.type == ItemType.armor ||
                          i.type == ItemType.storage,
                    )
                    .toList(),
                capacity: game.bagCapacity,
              ),
              _PagedInventoryGrid(
                items: allItems
                    .where((i) => i.type == ItemType.consumable)
                    .toList(),
                capacity: game.bagCapacity,
              ),
              _PagedInventoryGrid(
                items: allItems.where((i) => i.type == ItemType.other).toList(),
                capacity: game.bagCapacity,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PagedInventoryGrid extends StatelessWidget {
  const _PagedInventoryGrid({
    required this.items,
    required this.capacity,
    this.showEmptySlots = false,
  });

  final List<Item> items;
  final int capacity;
  final bool showEmptySlots;

  static const int _itemsPerPage = 50;
  static const int _columns = 5;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate total slots to render
    // If showEmptySlots is true, we render up to capacity.
    // Otherwise, we just render the items.
    final int totalSlots = showEmptySlots ? capacity : items.length;

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
            const SizedBox(height: 16),
            Text(
              '暂无此类物品',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ],
        ),
      );
    }

    final int pageCount = (totalSlots / _itemsPerPage).ceil();

    if (pageCount <= 1) {
      return _buildGrid(context, 0, totalSlots);
    }

    return PageView.builder(
      itemCount: pageCount,
      itemBuilder: (context, pageIndex) {
        return _buildGrid(context, pageIndex, totalSlots);
      },
    );
  }

  Widget _buildGrid(BuildContext context, int pageIndex, int totalSlots) {
    final startIndex = pageIndex * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, totalSlots);
    final count = endIndex - startIndex;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        childAspectRatio: 0.85, // Slightly taller for text
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        final globalIndex = startIndex + index;
        if (globalIndex < items.length) {
          return _InventoryGridItem(item: items[globalIndex]);
        } else {
          return const _EmptySlotItem();
        }
      },
    );
  }
}

class _EmptySlotItem extends StatelessWidget {
  const _EmptySlotItem();

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
          color: theme.disabledColor.withValues(alpha: 0.1),
          size: 20,
        ),
      ),
    );
  }
}

class _InventoryGridItem extends StatelessWidget {
  const _InventoryGridItem({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Rarity Color
    Color borderColor;
    Color iconBgColor;

    switch (item.rarity) {
      case ItemRarity.common:
        borderColor = Colors.grey;
        iconBgColor = Colors.grey.withValues(alpha: 0.1);
        break;
      case ItemRarity.uncommon:
        borderColor = Colors.green;
        iconBgColor = Colors.green.withValues(alpha: 0.1);
        break;
      case ItemRarity.rare:
        borderColor = Colors.blue;
        iconBgColor = Colors.blue.withValues(alpha: 0.1);
        break;
      case ItemRarity.epic:
        borderColor = Colors.purple;
        iconBgColor = Colors.purple.withValues(alpha: 0.1);
        break;
      case ItemRarity.legendary:
        borderColor = Colors.amber;
        iconBgColor = Colors.amber.withValues(alpha: 0.1);
        break;
      case ItemRarity.mythic:
        borderColor = Colors.red;
        iconBgColor = Colors.red.withValues(alpha: 0.1);
        break;
    }

    return InkWell(
      onTap: () => _showItemDetails(context, item),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Stack(
          children: [
            // Background Icon
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -10), // move glyph upward a bit
                    child: Text(
                      _getItemChar(item),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: borderColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Item Name (Bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Text(
                  item.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Type/New Tag (Top Left) - Optional
          ],
        ),
      ),
    );
  }

  String _getItemChar(Item item) {
    if (item.type == ItemType.weapon) return '剑';
    if (item.type == ItemType.armor) return '甲';
    if (item.type == ItemType.consumable) return '丹';
    if (item.type == ItemType.storage) return '袋';
    return '杂';
  }

  void _showItemDetails(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
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
                  _icon(item.type),
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
                        context.read<GameState>().useConsumable(item);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('使用'),
                    ),
                  if (item.type == ItemType.weapon ||
                      item.type == ItemType.armor ||
                      item.type == ItemType.storage)
                    FilledButton.icon(
                      onPressed: () {
                        context.read<GameState>().equipItem(item);
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.shield),
                      label: const Text('装备'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () {
                      context.read<GameState>().discard(item);
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

  IconData _icon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.hardware;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.consumable:
        return Icons.local_pharmacy;
      case ItemType.storage:
        return Icons.backpack;
      case ItemType.other:
        return Icons.help_outline;
    }
  }
}
