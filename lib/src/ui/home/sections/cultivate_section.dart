import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/game_state.dart';

class CultivateSection extends StatelessWidget {
  const CultivateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final theme = Theme.of(context);
    final realm = game.player.realm;
    final progress = realm.maxXp > 0 ? game.player.xp / realm.maxXp : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Realm Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    '当前境界',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    realm.name,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation(
                      theme.colorScheme.tertiary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '修为：${game.player.xp} / ${realm.maxXp}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Actions
          Text('修炼方式', style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CultivateActionCard(
                  title: '静坐修炼',
                  subtitle: '1 小时',
                  icon: Icons.self_improvement,
                  onTap: game.isDead
                      ? null
                      : () => context.read<GameState>().cultivate(hours: 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CultivateActionCard(
                  title: '闭关突破',
                  subtitle: '6 小时',
                  icon: Icons.bedtime,
                  onTap: game.isDead
                      ? null
                      : () => context.read<GameState>().cultivate(hours: 6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Debug/Info Text (kept but styled)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '当前目标 (P0)',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '跑通核心循环：修炼获取修为 -> 突破自动判定 -> 记录日志 -> 寿元倒计时',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CultivateActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const _CultivateActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: isEnabled ? theme.colorScheme.primary : theme.disabledColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (isEnabled)
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: theme.colorScheme.onPrimary, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
