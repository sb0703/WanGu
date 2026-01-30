import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/game_state.dart';
import '../../state/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final settings = context.watch<SettingsState>();
    final messenger = ScaffoldMessenger.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('系统设置')),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(context, '存档管理'),
          ListTile(
            leading: const Icon(Icons.save_outlined),
            title: const Text('保存进度'),
            subtitle: const Text('手动保存当前游戏进度'),
            onTap: () async {
              await game.saveToDisk();
              messenger.showSnackBar(const SnackBar(content: Text('存档已保存')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_toggle_off),
            title: const Text('读取进度'),
            subtitle: const Text('读取上次保存的进度'),
            onTap: () async {
              final confirm = await _confirm(context, '读档会覆盖当前进度，继续吗？');
              if (!confirm) return;
              final restored = await game.loadFromDisk();
              messenger.showSnackBar(
                SnackBar(content: Text(restored ? '读档成功' : '没有可用存档')),
              );
              if (restored && context.mounted) {
                Navigator.pop(context); // Go back to game after load
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('删除存档'),
            subtitle: const Text('删除本地存档记录'),
            onTap: () async {
              final confirm = await _confirm(context, '确定要删除本地存档吗？');
              if (!confirm) return;
              final cleared = await game.clearSave();
              messenger.showSnackBar(
                SnackBar(content: Text(cleared ? '存档已删除' : '没有可删除的存档')),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader(context, '游戏设置'),
          SwitchListTile(
            secondary: const Icon(Icons.brightness_6),
            title: const Text('暗黑模式'),
            subtitle: const Text('切换日间/夜间主题'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (_) {
              settings.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('重新开始'),
            subtitle: const Text('重置所有进度，从头开始'),
            onTap: () async {
              final confirm = await _confirm(
                context,
                '确定要重新开始游戏吗？\n当前未保存的进度将丢失。',
              );
              if (!confirm) return;
              game.resetGame();
              messenger.showSnackBar(const SnackBar(content: Text('游戏已重置')));
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          const Divider(),
          _buildSectionHeader(context, '关于'),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于游戏'),
            onTap: () {
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
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
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
}
