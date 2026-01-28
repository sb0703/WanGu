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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text('容量：${items.length}/${game.bagCapacity}'),
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Expanded(child: Center(child: Text('背包空空如也，去探索获取材料吧。')))
        else
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(_icon(item.type)),
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      if (item.type == ItemType.consumable)
                        TextButton(
                          onPressed: () =>
                              context.read<GameState>().useConsumable(item),
                          child: const Text('使用'),
                        ),
                      if (item.type == ItemType.weapon)
                        TextButton(
                          onPressed: () =>
                              context.read<GameState>().equipWeapon(item),
                          child: const Text('装备'),
                        ),
                      TextButton(
                        onPressed: () =>
                            context.read<GameState>().discard(item),
                        child: const Text('丢弃'),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, _) => const Divider(height: 1),
              itemCount: items.length,
            ),
          ),
      ],
    );
  }

  IconData _icon(ItemType type) {
    switch (type) {
      case ItemType.weapon:
        return Icons.gavel;
      case ItemType.armor:
        return Icons.shield;
      case ItemType.consumable:
        return Icons.medical_services;
    }
  }
}
