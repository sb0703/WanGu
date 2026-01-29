import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item.dart';
import '../../../state/game_state.dart';

class InventorySection extends StatelessWidget {
  const InventorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final items = game.player.inventory;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              Text(
                '容量：${items.length}/${game.bagCapacity}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: items.length >= game.bagCapacity
                      ? theme.colorScheme.error
                      : theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
        if (items.isEmpty)
          Expanded(
            child: Center(
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
                    '背包空空如也',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                  Text(
                    '去探索获得材料吧',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          _icon(item.type),
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.description),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          switch (value) {
                            case 'use':
                              context.read<GameState>().useConsumable(item);
                              break;
                            case 'equip':
                              context.read<GameState>().equipWeapon(item);
                              break;
                            case 'equip_armor':
                              context.read<GameState>().equipArmor(item);
                              break;
                            case 'discard':
                              context.read<GameState>().discard(item);
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            if (item.type == ItemType.consumable)
                              const PopupMenuItem(
                                value: 'use',
                                child: Text('使用'),
                              ),
                            if (item.type == ItemType.weapon)
                              const PopupMenuItem(
                                value: 'equip',
                                child: Text('装备'),
                              ),
                            if (item.type == ItemType.armor)
                              const PopupMenuItem(
                                value: 'equip_armor',
                                child: Text('装备'),
                              ),
                            const PopupMenuItem(
                              value: 'discard',
                              child: Text('丢弃'),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, _) => const SizedBox(height: 4),
              itemCount: items.length,
            ),
          ),
      ],
    );
  }

  IconData _icon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.hardware; // Better sword icon alternative
      case ItemType.armor:
        return Icons.shield;
      case ItemType.consumable:
        return Icons.local_pharmacy; // Better pill/medicine icon
      case ItemType.other:
        return Icons.help_outline;
    }
  }
}
