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
          _PlayerHeader(player: player, game: game),
          const SizedBox(height: 24),
          Text('属性概览', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          StatCards(player: player),
          const SizedBox(height: 24),
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
}

class _PlayerHeader extends StatelessWidget {
  const _PlayerHeader({required this.player, required this.game});

  final Player player;
  final GameState game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  player.realm.name.characters.first,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(label: '境界', value: player.realm.name),
                  const SizedBox(height: 4),
                  _InfoRow(
                    label: '寿元',
                    value:
                        '${(player.lifespanHours / 24 / 365).toStringAsFixed(1)} 年',
                  ),
                  const SizedBox(height: 4),
                  _InfoRow(
                    label: '武器',
                    value: game.equippedWeapon?.name ?? '未装备',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          '$label：',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(value, style: theme.textTheme.bodyMedium),
      ],
    );
  }
}
