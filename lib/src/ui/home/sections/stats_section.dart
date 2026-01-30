import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/item.dart';
import '../../../models/player.dart';
import '../../../state/game_state.dart';
import '../widgets/stat_cards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          _EquipmentGrid(player: player),
          const SizedBox(height: 24),
          StatCards(player: player),
        ],
      ),
    );
  }
}

class _EquipmentGrid extends StatelessWidget {
  const _EquipmentGrid({required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Helper to find item
    Item? getItem(EquipmentSlot slot) {
      for (final item in player.equipped) {
        if (item.type == ItemType.equipment && item.slot == slot) return item;
      }
      return null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.shield_moon, size: 18, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              '装备',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.8,
          children: [
            _EquipSlot(
              slot: EquipmentSlot.soulbound,
              label: '本命',
              item: getItem(EquipmentSlot.soulbound),
            ),
            _EquipSlot(
              slot: EquipmentSlot.mainHand,
              label: '主手',
              item: getItem(EquipmentSlot.mainHand),
            ),
            _EquipSlot(
              slot: EquipmentSlot.body,
              label: '身甲',
              item: getItem(EquipmentSlot.body),
            ),
            _EquipSlot(
              slot: EquipmentSlot.accessory,
              label: '饰品',
              item: getItem(EquipmentSlot.accessory),
            ),
            _EquipSlot(
              slot: EquipmentSlot.guard,
              label: '护身',
              item: getItem(EquipmentSlot.guard),
            ),
            _EquipSlot(
              slot: EquipmentSlot.mount,
              label: '座驾',
              item: getItem(EquipmentSlot.mount),
            ),
          ],
        ),
      ],
    );
  }
}

class _EquipSlot extends StatelessWidget {
  const _EquipSlot({required this.slot, required this.label, this.item});

  final EquipmentSlot slot;
  final String label;
  final Item? item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEquipped = item != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEquipped
              ? _getRarityColor(item!.rarity)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isEquipped ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const Spacer(),
          if (isEquipped) ...[
            Icon(
              _getSlotIcon(slot),
              color: _getRarityColor(item!.rarity),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              item!.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            Icon(
              _getSlotIcon(slot),
              color: theme.disabledColor.withValues(alpha: 0.2),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              '空',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.disabledColor,
              ),
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }

  Color _getRarityColor(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return Colors.grey;
      case ItemRarity.uncommon:
        return Colors.green;
      case ItemRarity.rare:
        return Colors.blue;
      case ItemRarity.epic:
        return Colors.purple;
      case ItemRarity.legendary:
        return Colors.amber;
      case ItemRarity.mythic:
        return Colors.red;
    }
  }

  IconData _getSlotIcon(EquipmentSlot slot) {
    switch (slot) {
      case EquipmentSlot.soulbound:
        return Icons.auto_awesome;
      case EquipmentSlot.mainHand:
        return Icons.hardware;
      case EquipmentSlot.body:
        return Icons.shield;
      case EquipmentSlot.accessory:
        return Icons.diamond;
      case EquipmentSlot.guard:
        return Icons.security;
      case EquipmentSlot.mount:
        return FontAwesomeIcons.horse;
    }
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
            value: (purity / 100.0).clamp(0.0, 1.0),
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
    final activeBuffs = player.activeBuffs;

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
                          _PurityBar(
                            purity: player.effectiveStats.purity,
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Buffs Display
                if (activeBuffs.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 32,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: activeBuffs.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final buff = activeBuffs[index];
                        return Tooltip(
                          message: '${buff.name}: ${buff.description}',
                          child: Chip(
                            label: Text(
                              buff.name,
                              style: const TextStyle(fontSize: 10),
                            ),
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            backgroundColor: buff.isDebuff
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.green.withValues(alpha: 0.1),
                            side: BorderSide.none,
                          ),
                        );
                      },
                    ),
                  ),
                ],
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
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          stageName.characters.take(1).toString(),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
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
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
