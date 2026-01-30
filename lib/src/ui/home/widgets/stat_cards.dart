import 'package:flutter/material.dart';

import '../../../models/player.dart';

class StatCards extends StatelessWidget {
  const StatCards({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = player.effectiveStats;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.3,
                  ),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.spa, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  '道体属性',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 核心状态
                _StatusProgress(
                  label: '气血',
                  value: stats.hp,
                  max: stats.maxHp,
                  color: const Color(0xFFD32F2F), // Darker Red
                  backgroundColor: const Color(0xFFFFEBEE),
                  icon: Icons.favorite,
                ),
                const SizedBox(height: 16),
                _StatusProgress(
                  label: '灵力',
                  value: stats.spirit,
                  max: stats.maxSpirit,
                  color: const Color(0xFF1976D2), // Darker Blue
                  backgroundColor: const Color(0xFFE3F2FD),
                  icon: Icons.auto_awesome,
                ),

                const SizedBox(height: 24),

                // 属性网格
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - 16) / 2;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _StatBox(
                          label: '攻击',
                          value: '${stats.attack}',
                          icon: Icons
                              .flash_on, // Revert to flash_on or use another valid icon like hardware
                          color: const Color(0xFFE65100), // Orange 900
                          width: width,
                        ),
                        _StatBox(
                          label: '防御',
                          value: '${stats.defense}',
                          icon: Icons.shield,
                          color: const Color(0xFF2E7D32), // Green 800
                          width: width,
                        ),
                        _StatBox(
                          label: '速度',
                          value: '${stats.speed}',
                          icon: Icons.wind_power, // Changed icon
                          color: const Color(0xFF00838F), // Cyan 800
                          width: width,
                        ),
                        _StatBox(
                          label: '悟性',
                          value: '${stats.insight}',
                          icon: Icons.psychology, // Changed icon
                          color: const Color(0xFF6A1B9A), // Purple 800
                          width: width,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusProgress extends StatelessWidget {
  const _StatusProgress({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.backgroundColor,
    required this.icon,
  });

  final String label;
  final int value;
  final int max;
  final Color color;
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = max > 0 ? value / max : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              '$value / $max',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Monospace',
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: const Offset(0, 1),
                // inset: true removed as it is not supported in standard BoxShadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.width,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Monospace',
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
