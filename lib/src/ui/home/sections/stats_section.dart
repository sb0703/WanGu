import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/player.dart';
import '../../../state/game_state.dart';
import '../widgets/stat_cards.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final player = game.player;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _CharacterStatusCard(player: player, game: game),
          const SizedBox(height: 24),
          StatCards(player: player),
        ],
      ),
    );
  }
}

class _PurityBar extends StatelessWidget {
  const _PurityBar({required this.purity, required this.theme});

  final int purity;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    // Determine color based on purity
    Color color;
    if (purity >= 80) {
      color = Colors.green;
    } else if (purity >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.water_drop,
              size: 16,
              color: theme.colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            Text(
              '灵气纯度',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              '$purity%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: purity / 100.0,
            minHeight: 6,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _CharacterStatusCard extends StatelessWidget {
  const _CharacterStatusCard({required this.player, required this.game});

  final Player player;
  final GameState game;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final realm = player.realm;
    final lifeYears = (player.lifespanDays / 365).toStringAsFixed(1);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainer,
            theme.colorScheme.surfaceContainerHigh,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Stack(
        children: [
          // 背景装饰纹理（可选，这里用简单的圆形模拟）
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 头像区域
                    _Avatar(stageName: realm.name),
                    const SizedBox(width: 20),

                    // 核心信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                player.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  player.realmLabel,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _StatusRow(
                            icon: Icons.access_time,
                            label: '寿元 $lifeYears 年',
                            theme: theme,
                          ),
                          const SizedBox(height: 4),
                          _StatusRow(
                            icon: Icons.bolt,
                            label: '修为 ${player.xp}/${player.currentMaxXp}',
                            theme: theme,
                          ),
                          const SizedBox(height: 4),
                          _PurityBar(purity: player.stats.purity, theme: theme),
                          if (player.afflictions.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: player.afflictions.map((a) {
                                return _AfflictionChip(affliction: a);
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // 装备栏
                Row(
                  children: [
                    Expanded(
                      child: _EquipmentItem(
                        label: '武器',
                        name: game.equippedWeapon?.name ?? '暂无装备',
                        icon: Icons.hardware, // Better sword icon alternative
                        isEquipped: game.equippedWeapon != null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _EquipmentItem(
                        label: '护甲',
                        name: game.equippedArmor?.name ?? '暂无装备',
                        icon: Icons.shield,
                        isEquipped: game.equippedArmor != null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.secondary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EquipmentItem extends StatelessWidget {
  const _EquipmentItem({
    required this.label,
    required this.name,
    required this.icon,
    required this.isEquipped,
  });

  final String label;
  final String name;
  final IconData icon;
  final bool isEquipped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isEquipped ? theme.colorScheme.primary : theme.disabledColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isEquipped
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: isEquipped
                        ? theme.colorScheme.onSurface
                        : theme.disabledColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.stageName});

  final String stageName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: theme.colorScheme.primary, width: 3),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          stageName.characters.first,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
      ),
    );
  }
}

class _AfflictionChip extends StatelessWidget {
  const _AfflictionChip({required this.affliction});

  final String affliction;

  @override
  Widget build(BuildContext context) {
    final info = _getAfflictionInfo(affliction);
    final color = info.color;

    return InkWell(
      onTap: () => _showAfflictionDetails(context, info),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(info.icon, size: 12, color: color),
            const SizedBox(width: 4),
            Text(
              info.label,
              style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAfflictionDetails(BuildContext context, _AfflictionInfo info) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(info.icon, color: info.color),
            const SizedBox(width: 8),
            Text(info.label, style: TextStyle(color: info.color)),
          ],
        ),
        content: Text(info.description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  _AfflictionInfo _getAfflictionInfo(String id) {
    switch (id) {
      case 'one_arm':
        return _AfflictionInfo(
          label: '肉身残缺',
          description: '失去一臂，身体不再完整。\n效果：攻击力永久降低 30%。\n来源：突破失败遭受雷劫轰击。',
          color: Colors.red[800]!,
          icon: Icons.accessibility_new,
        );
      case 'blind':
        return _AfflictionInfo(
          label: '五感尽失',
          description: '双目失明，世界归于黑暗。\n效果：悟性永久降低 50%。\n来源：突破失败遭受反噬。',
          color: Colors.grey[800]!,
          icon: Icons.visibility_off,
        );
      case 'broken_heart':
        return _AfflictionInfo(
          label: '道心破碎',
          description: '心魔入侵，道心不再稳固。\n效果：悟性永久降低 5 点。\n来源：突破失败被心魔所趁。',
          color: Colors.purple[800]!,
          icon: Icons.broken_image,
        );
      default:
        return _AfflictionInfo(
          label: '未知诅咒',
          description: '来源不明的神秘诅咒。',
          color: Colors.black,
          icon: Icons.error,
        );
    }
  }
}

class _AfflictionInfo {
  final String label;
  final String description;
  final Color color;
  final IconData icon;

  _AfflictionInfo({
    required this.label,
    required this.description,
    required this.color,
    required this.icon,
  });
}
