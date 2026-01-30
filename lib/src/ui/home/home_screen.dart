import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/game_state.dart';
import '../../state/settings_state.dart';
import 'sections/cultivate_section.dart';
import 'sections/inventory_section.dart';
import 'sections/sect_section.dart';
import 'sections/stats_section.dart';
import 'widgets/battle_overlay.dart';
import 'widgets/breakthrough_overlay.dart';
import 'widgets/log_ticker.dart';
import 'widgets/npc_overlay.dart';

enum _StorageAction { save, load, reset, clear, theme, about }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  bool _didRestoreOnce = false;

  @override
  void initState() {
    super.initState();
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

  Future<void> _handleStorageAction(_StorageAction action) async {
    final game = context.read<GameState>();
    final messenger = ScaffoldMessenger.of(context);

    switch (action) {
      case _StorageAction.save:
        await game.saveToDisk();
        messenger.showSnackBar(const SnackBar(content: Text('存档已保存')));
        break;
      case _StorageAction.load:
        final confirm = await _confirm(context, '读档会覆盖当前进度，继续吗？');
        if (!confirm) return;
        final restored = await game.loadFromDisk();
        messenger.showSnackBar(
          SnackBar(content: Text(restored ? '读档成功' : '没有可用存档')),
        );
        break;
      case _StorageAction.reset:
        final confirm = await _confirm(context, '确定要重新开始游戏吗？\n当前未保存的进度将丢失。');
        if (!confirm) return;
        game.resetGame();
        messenger.showSnackBar(const SnackBar(content: Text('游戏已重置')));
        break;
      case _StorageAction.clear:
        final confirm = await _confirm(context, '确定要删除本地存档吗？');
        if (!confirm) return;
        final cleared = await game.clearSave();
        messenger.showSnackBar(
          SnackBar(content: Text(cleared ? '存档已删除' : '没有可删除的存档')),
        );
        break;
      case _StorageAction.theme:
        context.read<SettingsState>().toggleTheme();
        break;
      case _StorageAction.about:
        showDialog(
          context: context,
          builder: (context) => const AboutDialog(
            applicationName: '万古墨境：红尘渡',
            applicationVersion: '1.0.0',
            applicationLegalese: '© 2024 WanGu Project',
            children: [
              SizedBox(height: 16),
              Text('一个基于 Flutter 开发的文字修仙 MUD 游戏。'),
              SizedBox(height: 8),
              Text('大道争锋，我辈修士当逆天而行。'),
            ],
          ),
        );
        break;
    }
  }

  Future<bool> _confirm(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('确认操作'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
    return result ?? false;
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
          PopupMenuButton<_StorageAction>(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onSelected: _handleStorageAction,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _StorageAction.save,
                child: ListTile(
                  leading: Icon(Icons.save_outlined),
                  title: Text('保存进度'),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: _StorageAction.load,
                child: ListTile(
                  leading: Icon(Icons.history_toggle_off),
                  title: Text('读取进度'),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: _StorageAction.reset,
                child: ListTile(
                  leading: Icon(Icons.restart_alt),
                  title: Text('重新开始'),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: _StorageAction.clear,
                child: ListTile(
                  leading: Icon(Icons.delete_outline),
                  title: Text('删除存档'),
                  dense: true,
                ),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _StorageAction.theme,
                child: ListTile(
                  leading: Icon(Icons.brightness_6),
                  title: Text('切换主题'),
                  dense: true,
                ),
              ),
              PopupMenuItem(
                value: _StorageAction.about,
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('关于游戏'),
                  dense: true,
                ),
              ),
            ],
          ),
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
