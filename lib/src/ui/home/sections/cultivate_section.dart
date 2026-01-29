import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/game_state.dart';

class CultivateSection extends StatelessWidget {
  const CultivateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final theme = Theme.of(context);
    final player = game.player;
    final maxXp = player.currentMaxXp;
    final progress = maxXp > 0 ? player.xp / maxXp : 0.0;

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
                    player.realmLabel,
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
                    '修为：${player.xp} / $maxXp',
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

          if (progress >= 1.0)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: game.isDead
                    ? null
                    : () => context.read<GameState>().attemptBreakthrough(),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.amber[700],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                ),
                icon: const Icon(Icons.bolt, size: 28),
                label: const Text(
                  '尝试突破',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _CultivateActionCard(
                        title: '静坐修炼',
                        subtitle: '1 天 (纯度-)',
                        icon: Icons.self_improvement,
                        onTap: game.isDead
                            ? null
                            : () =>
                                  context.read<GameState>().cultivate(days: 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CultivateActionCard(
                        title: '深度闭关',
                        subtitle: '7 天 (纯度---)',
                        icon: Icons.bedtime,
                        onTap: game.isDead
                            ? null
                            : () =>
                                  context.read<GameState>().cultivate(days: 7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _CultivateActionCard(
                        title: '运功排毒',
                        subtitle: '1 天 (纯度+)',
                        icon: Icons.water_drop,
                        color: Colors.teal,
                        onTap: game.isDead
                            ? null
                            : () => context.read<GameState>().purify(days: 1),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CultivateActionCard(
                        title: '洗髓伐骨',
                        subtitle: '7 天 (纯度+++)',
                        icon: Icons.spa,
                        color: Colors.teal[700],
                        onTap: game.isDead
                            ? null
                            : () => context.read<GameState>().purify(days: 7),
                      ),
                    ),
                  ],
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
  final Color? color;

  const _CultivateActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEnabled = onTap != null;
    final cardColor = color ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          decoration: BoxDecoration(
            color: isEnabled ? cardColor : theme.disabledColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              if (isEnabled)
                BoxShadow(
                  color: cardColor.withValues(alpha: 0.3),
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
