import 'package:flutter/material.dart';

import '../../../models/player.dart';

class StatCards extends StatelessWidget {
  const StatCards({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final stats = player.stats;
    final cards = [
      _Tile(
        label: '生命',
        value: '${stats.hp}/${stats.maxHp}',
        icon: Icons.favorite,
        color: Colors.red,
      ),
      _Tile(
        label: '灵力',
        value: stats.spirit.toString(),
        icon: Icons.auto_awesome,
        color: Colors.blue,
      ),
      _Tile(
        label: '攻击',
        value: stats.attack.toString(),
        icon: Icons.flash_on,
        color: Colors.orange,
      ),
      _Tile(
        label: '防御',
        value: stats.defense.toString(),
        icon: Icons.shield,
        color: Colors.green,
      ),
      _Tile(
        label: '速度',
        value: stats.speed.toString(),
        icon: Icons.directions_run,
        color: Colors.cyan,
      ),
      _Tile(
        label: '悟性',
        value: stats.insight.toString(),
        icon: Icons.lightbulb,
        color: Colors.purple,
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 10,
          childAspectRatio: 2.0,
          children: cards,
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color.withValues(alpha: 0.8)),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
