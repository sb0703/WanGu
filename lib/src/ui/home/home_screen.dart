import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/game_state.dart';
import 'sections/cultivate_section.dart';
import 'sections/inventory_section.dart';
import 'sections/map_section.dart';
import 'sections/sect_section.dart';
import 'sections/stats_section.dart';
import 'widgets/battle_overlay.dart';
import 'widgets/log_ticker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final theme = Theme.of(context);
    final isGameOver = game.isGameOver;
    final tabs = [
      const SectSection(),
      const CultivateSection(),
      const StatsSection(),
      const InventorySection(),
      const MapSection(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('万古墨境：红尘渡'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '日期：${game.clock.shortLabel()}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '寿元：${(game.player.lifespanDays / 365).toStringAsFixed(1)} 年',
                  style: theme.textTheme.labelSmall,
                ),
                if (isGameOver)
                  Text(
                    '已死亡/寿元耗尽',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                IndexedStack(index: _index, children: tabs),
                if (game.currentBattle != null) const BattleOverlay(),
                if (isGameOver)
                  Container(
                    color: Colors.black.withValues(alpha: 0.55),
                    alignment: Alignment.center,
                    child: _GameOverCard(
                      onReset: () => context.read<GameState>().resetGame(),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 1),
          const LogTicker(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.temple_buddhist_outlined),
            selectedIcon: Icon(Icons.temple_buddhist),
            label: '宗门',
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined),
            selectedIcon: Icon(Icons.self_improvement),
            label: '修炼',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '属性',
          ),
          NavigationDestination(
            icon: Icon(Icons.backpack_outlined),
            selectedIcon: Icon(Icons.backpack),
            label: '背包',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: '地图',
          ),
        ],
      ),
    );
  }
}

class _GameOverCard extends StatelessWidget {
  const _GameOverCard({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '寿元已尽，道消身死',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text('你可以重返凡尘，重新开始修行。', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.restart_alt),
              onPressed: onReset,
              label: const Text('重开一局'),
            ),
          ],
        ),
      ),
    );
  }
}
