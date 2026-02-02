import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/game_state.dart';
import '../character_creation/character_creation_screen.dart';
import '../settings/settings_screen.dart';
import 'sections/cultivate_section.dart';
import 'sections/inventory_section.dart';
import 'sections/sect_section.dart';
import 'sections/stats_section.dart';
import 'widgets/battle_overlay.dart';
import 'widgets/breakthrough_overlay.dart';
import 'widgets/log_ticker.dart';
import 'widgets/npc_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _index = 0;
  bool _didRestoreOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_didRestoreOnce || !mounted) return;
      _didRestoreOnce = true;
      final restored = await context.read<GameState>().loadFromDisk();
      if (!mounted) return;
      if (restored) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('已自动读取存档')));
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      context.read<GameState>().saveToDisk();
    }
  }

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
                    '已陨落：寿元耗尽',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                IndexedStack(index: _index, children: tabs),
                if (game.showingBreakthrough) const BreakthroughOverlay(),
                if (game.currentInteractionNpc != null) const NpcOverlay(),
                if (game.currentBattle != null) const BattleOverlay(),
                if (isGameOver)
                  Container(
                    color: Colors.black.withValues(alpha: 0.55),
                    alignment: Alignment.center,
                    child: _GameOverCard(
                      onReset: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const CharacterCreationScreen(),
                          ),
                          (route) => false,
                        );
                      },
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
              '寿元已尽，道途到此结束',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text('你可以重走凡尘，重新开始修行。', style: theme.textTheme.bodyMedium),
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
