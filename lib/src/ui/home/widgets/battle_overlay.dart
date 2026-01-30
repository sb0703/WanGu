import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../models/battle.dart';
import '../../../state/game_state.dart';

class BattleOverlay extends StatelessWidget {
  const BattleOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final battle = game.currentBattle;
    final theme = Theme.of(context);

    if (battle == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        image: DecorationImage(
          image: const AssetImage(
            'assets/images/battle_bg_placeholder.jpg',
          ), // Future enhancement
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.85),
            BlendMode.darken,
          ),
          onError: (e, s) {}, // Handle missing asset gracefully
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top Bar: Turn & Status
            _BattleHeader(turn: battle.turn),

            const Spacer(),

            // Combat Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Enemy Unit
                  _CombatUnit(
                    name: battle.enemy.name,
                    hp: battle.enemyHp,
                    maxHp: battle.enemyMaxHp,
                    isPlayer: false,
                    icon: Icons.bug_report,
                  ),

                  const SizedBox(height: 48), // Spacing between combatants
                  // Player Unit
                  _CombatUnit(
                    name: game.player.name,
                    hp: battle.playerHp,
                    maxHp: battle.playerMaxHp,
                    spirit: battle.playerSpirit,
                    maxSpirit: battle.playerMaxSpirit,
                    isPlayer: true,
                    icon: Icons.person,
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Bottom Area: Logs & Controls
            _BattleControls(game: game, battle: battle),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _BattleHeader extends StatelessWidget {
  final int turn;
  const _BattleHeader({required this.turn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(20),
            color: Colors.black45,
          ),
          child: Text(
            '回合 $turn',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              letterSpacing: 1.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _CombatUnit extends StatelessWidget {
  final String name;
  final int hp;
  final int maxHp;
  final int? spirit;
  final int? maxSpirit;
  final bool isPlayer;
  final IconData icon;

  const _CombatUnit({
    required this.name,
    required this.hp,
    required this.maxHp,
    this.spirit,
    this.maxSpirit,
    required this.isPlayer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // final hpPercent = maxHp > 0 ? hp / maxHp : 0.0;
    final theme = Theme.of(context);
    final primaryColor = isPlayer
        ? const Color(0xFF4CAF50)
        : const Color(0xFFE57373); // Green / Red

    return Row(
      mainAxisAlignment: isPlayer
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end, // Align bottom
      children: [
        // Avatar (Left for Enemy, Right for Player)
        if (!isPlayer)
          _Avatar(icon: icon, color: primaryColor, isPlayer: false),
        if (!isPlayer) const SizedBox(width: 16),

        // Stats Block
        Expanded(
          child: Column(
            crossAxisAlignment: isPlayer
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(
                      blurRadius: 4,
                      color: Colors.black,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // HP Bar
              _StatBar(
                current: hp,
                max: maxHp,
                color: primaryColor,
                label: 'HP',
              ),

              // Spirit Bar (Player Only)
              if (isPlayer && spirit != null && maxSpirit != null) ...[
                const SizedBox(height: 6),
                _StatBar(
                  current: spirit!,
                  max: maxSpirit!,
                  color: const Color(0xFF2196F3), // Blue
                  label: 'MP',
                  height: 6,
                ),
              ],
            ],
          ),
        ),

        if (isPlayer) const SizedBox(width: 16),
        if (isPlayer) _Avatar(icon: icon, color: primaryColor, isPlayer: true),
      ],
    ).animate().fadeIn().slideX(
      begin: isPlayer ? 0.2 : -0.2,
      end: 0,
      duration: 500.ms,
      curve: Curves.easeOutQuart,
    );
  }
}

class _Avatar extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isPlayer;

  const _Avatar({
    required this.icon,
    required this.color,
    required this.isPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.black54,
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.5), width: 3),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(icon, size: 40, color: color),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 2.seconds,
        );
  }
}

class _StatBar extends StatelessWidget {
  final int current;
  final int max;
  final Color color;
  final String label;
  final double height;

  const _StatBar({
    required this.current,
    required this.max,
    required this.color,
    required this.label,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final percent = max > 0 ? current / max : 0.0;

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Stack(
            children: [
              // Background
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
              // Foreground
              AnimatedFractionallySizedBox(
                duration: 300.ms,
                widthFactor: percent.clamp(0.0, 1.0),
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            '$current/$max',
            textAlign: TextAlign.end,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }
}

class _BattleControls extends StatelessWidget {
  final GameState game;
  final Battle battle;

  const _BattleControls({required this.game, required this.battle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logs
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListView.builder(
              reverse: true,
              itemCount: battle.logs.length,
              itemBuilder: (context, index) {
                final log = battle.logs[battle.logs.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        log.isCrit ? Icons.star : Icons.circle,
                        size: 8,
                        color: log.isPlayerAction ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          log.message,
                          style: TextStyle(
                            color: log.isPlayerAction
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 13,
                            fontWeight: log.isCrit
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Buttons
          if (battle.isOver)
            SizedBox(
              width: double.infinity,
              child:
                  FilledButton(
                        onPressed: () => game.closeBattle(),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFC107), // Amber
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '离开战斗',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        duration: 1.seconds,
                      ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: '攻击',
                    icon: Icons.flash_on,
                    color: const Color(0xFFEF5350), // Red 400
                    onTap: () => game.progressBattle(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ActionButton(
                    label: '逃跑',
                    icon: Icons.directions_run,
                    color: Colors.grey,
                    onTap: () {
                      // Escape logic not implemented yet in this turn,
                      // but user can just leave if we add logic later.
                      // For now just skip turn or do nothing.
                    },
                    isOutlined: true,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isOutlined;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isOutlined ? Colors.transparent : color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isOutlined ? BorderSide(color: color) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isOutlined ? color : Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isOutlined ? color : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
