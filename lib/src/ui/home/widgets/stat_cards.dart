import 'package:flutter/material.dart';

import '../../../models/player.dart';

class StatCards extends StatelessWidget {
  const StatCards({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final stats = player.stats;
    final cards = [
      _Tile(label: '生命', value: '${stats.hp}/${stats.maxHp}'),
      _Tile(label: '灵力', value: stats.spirit.toString()),
      _Tile(label: '攻击', value: stats.attack.toString()),
      _Tile(label: '防御', value: stats.defense.toString()),
      _Tile(label: '速度', value: stats.speed.toString()),
      _Tile(label: '悟性', value: stats.insight.toString()),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 2.4,
          children: cards,
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
