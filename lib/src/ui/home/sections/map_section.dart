import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../models/map_node.dart';
import '../../../state/game_state.dart';

class MapSection extends StatefulWidget {
  const MapSection({super.key});

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  bool _isTraveling = false;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final theme = Theme.of(context);

    // If exploring, show Grid View
    // But we need a way to switch maps. Let's use a "Travel" button or mode.
    // Let's assume default is Exploration Grid for current node.
    // A button "Travel to..." opens the region selector.

    if (_isTraveling) {
      return _RegionSelector(
        onCancel: () => setState(() => _isTraveling = false),
        onSelect: (node) {
          game.enterRegion(node);
          setState(() => _isTraveling = false);
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header: Current Location + Travel Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          game.currentNode.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      game.currentNode.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: () => setState(() => _isTraveling = true),
                icon: const Icon(Icons.map, size: 18),
                label: const Text('御剑飞行'),
              ),
            ],
          ),
        ),

        // NPC Bar (Top of Map)
        const _NpcBar(),

        // Grid Map
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _ExplorationGrid(
                    game: game,
                    maxWidth: constraints.maxWidth,
                  ),
                ),
              );
            },
          ),
        ),
        const _Legend(),
      ],
    );
  }
}

class _NpcBar extends StatelessWidget {
  const _NpcBar();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final npcs = game.currentNpcs;
    final theme = Theme.of(context);

    if (npcs.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 5),
      child: Container(
        height: 95,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          scrollDirection: Axis.horizontal,
          itemCount: npcs.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final npc = npcs[index];
            return GestureDetector(
              onTap: () => game.startNpcInteraction(npc.id),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.5,
                            ),
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          child: Text(
                            npc.name[0],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 1.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.chat_bubble,
                            size: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    npc.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: (index * 100).ms).slideX(),
            );
          },
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(color: theme.colorScheme.primary, label: '修士'),
          const SizedBox(width: 16),
          _LegendItem(color: Colors.grey.shade300, label: '未知'),
          const SizedBox(width: 16),
          _LegendItem(
            color: theme.colorScheme.surfaceContainerHighest,
            label: '已探索',
          ),
        ],
      ),
    );
  }
}

class _ExplorationGrid extends StatelessWidget {
  const _ExplorationGrid({required this.game, required this.maxWidth});

  final GameState game;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final rows = GameState.gridRows;
    final cols = GameState.gridCols;

    // Calculate cell size to fit screen width
    // padding 16*2 = 32. spacing 4 * (cols-1)
    final availableWidth = maxWidth - 32;
    final cellSize = (availableWidth - (cols - 1) * 8) / cols;

    return Column(
      children: List.generate(rows, (row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cols, (col) {
              final p = Point(row, col);
              final isPlayer = p == game.playerGridPos;
              final isVisited = game.visitedTiles.contains(p);

              // Determine adjacency for interaction
              final playerP = game.playerGridPos;
              final dx = (p.x - playerP.x).abs();
              final dy = (p.y - playerP.y).abs();
              final isAdjacent = (dx + dy == 1);

              return GestureDetector(
                onTap: (isAdjacent || isVisited) && !game.isDead
                    ? () => context.read<GameState>().exploreMove(row, col)
                    : null,
                child: Container(
                  width: cellSize,
                  height: cellSize,
                  margin: EdgeInsets.only(right: col < cols - 1 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isPlayer
                        ? theme.colorScheme.primary
                        : isVisited
                        ? theme.colorScheme.surfaceContainerHighest
                        : (Theme.of(context).brightness == Brightness.light
                              ? Colors
                                    .grey
                                    .shade300 // 浅色模式下的迷雾：明显的灰色
                              : Colors.white12), // 深色模式下的迷雾 // Much darker fog
                    borderRadius: BorderRadius.circular(8),
                    border: isPlayer
                        ? Border.all(
                            color: theme.colorScheme.primaryContainer,
                            width: 2,
                          )
                        // : isVisited
                        // ? null
                        : Border.all(
                            color: theme.colorScheme.outline,
                            width: 1.5,
                          ), // Grid lines
                    boxShadow: isPlayer || isVisited
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 2,
                            ),
                          ],
                    gradient: isVisited
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.surfaceContainerHighest,
                              theme.colorScheme.surfaceContainerHigh,
                            ],
                          )
                        : null,
                  ),
                  child: Center(
                    child: isPlayer
                        ? Icon(
                                Icons.accessibility_new,
                                color: theme.colorScheme.onPrimary,
                                size: cellSize * 0.7,
                              )
                              .animate(onPlay: (c) => c.repeat())
                              .shimmer(
                                duration: 1200.ms,
                                color: Colors.white.withValues(alpha: 0.5),
                              )
                              .then()
                              .shake(hz: 4)
                        : isVisited
                        ? null
                        : isAdjacent
                        ? Icon(
                                Icons.help_outline,
                                color: theme
                                    .colorScheme
                                    .tertiary, // More visible color
                                size: cellSize * 0.5,
                              )
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .fade(begin: 0.5, end: 1.0, duration: 1000.ms)
                        : Icon(
                            // Subtle pattern for fog
                            Icons.cloud,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors
                                      .grey
                                      .shade600 // 浅色模式用深灰图标
                                : Colors.white38, // 深色模式用白雾
                            size: cellSize * 0.5,
                          ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _RegionSelector extends StatelessWidget {
  const _RegionSelector({required this.onCancel, required this.onSelect});

  final VoidCallback onCancel;
  final ValueChanged<MapNode> onSelect;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final theme = Theme.of(context);

    return Column(
      children: [
        AppBar(
          leading: IconButton(
            onPressed: onCancel,
            icon: const Icon(Icons.close),
          ),
          title: const Text('选择前往区域'),
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: game.mapNodes.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final node = game.mapNodes[index];
              final isCurrent = node.id == game.currentNode.id;

              return Card(
                elevation: isCurrent ? 0 : 2,
                color: isCurrent
                    ? theme.colorScheme.surfaceContainerHighest
                    : null,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? theme.disabledColor
                          : theme.colorScheme.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.place,
                      color: isCurrent
                          ? Colors.white
                          : theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(node.name),
                  subtitle: Text(node.description),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '危险 ${node.danger}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onTap: isCurrent ? null : () => onSelect(node),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
