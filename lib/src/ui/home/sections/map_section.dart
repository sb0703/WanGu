import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/map_node.dart';
import '../../../state/game_state.dart';

class MapSection extends StatelessWidget {
  const MapSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final currentId = game.currentNode.id;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '当前位置：${game.currentNode.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: game.mapNodes.length,
              itemBuilder: (context, index) {
                final node = game.mapNodes[index];
                final selected = node.id == currentId;
                return Card(
                  color: selected
                      ? Theme.of(context).colorScheme.secondaryContainer
                      : null,
                  child: ListTile(
                    title: Text(node.name),
                    subtitle: Text(node.description),
                    trailing: Text('危险值 ${node.danger}'),
                    selected: selected,
                    onTap: selected ? null : () => _move(context, node),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _move(BuildContext context, MapNode node) {
    context.read<GameState>().moveTo(node);
  }
}
