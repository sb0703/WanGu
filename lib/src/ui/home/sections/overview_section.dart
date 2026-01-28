import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/player.dart';
import '../../../state/game_state.dart';
import '../widgets/stat_cards.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final player = game.player;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _header(player),
          const SizedBox(height: 12),
          StatCards(player: player),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: game.isDead
                ? null
                : () => context.read<GameState>().rest(),
            icon: const Icon(Icons.local_hotel),
            label: const Text('休息 (恢复体力)'),
          ),
        ],
      ),
    );
  }

  Widget _header(Player player) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.green.shade200,
          child: Text(player.realm.name.characters.first),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              player.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text('境界：${player.realm.name}'),
            Text('修为：${player.xp}/${player.realm.maxXp}'),
          ],
        ),
      ],
    );
  }
}
