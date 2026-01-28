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
    if (items.isEmpty) {
      return const Center(child: Text('背包空空如也，去探索获取材料吧。'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: Icon(_icon(item.type)),
          title: Text(item.name),
          subtitle: Text(item.description),
          trailing: item.type == ItemType.consumable
              ? TextButton(
                  onPressed: () =>
                      context.read<GameState>().useConsumable(item),
                  child: const Text('使用'),
                )
              : null,
        );
      },
      separatorBuilder: (context, _) => const Divider(height: 1),
      itemCount: items.length,
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
