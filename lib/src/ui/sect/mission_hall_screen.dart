import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/missions_repository.dart';
import '../../models/mission.dart';
import '../../state/game_state.dart';

class MissionHallScreen extends StatelessWidget {
  const MissionHallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('任务堂'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '可接任务'),
              Tab(text: '进行中'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_AvailableMissionsList(), _ActiveMissionsList()],
        ),
      ),
    );
  }
}

class _AvailableMissionsList extends StatelessWidget {
  const _AvailableMissionsList();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final activeIds = game.activeMissions.map((m) => m.missionId).toSet();
    final completedIds = game.completedMissionIds;

    final availableMissions = MissionsRepository.missions.where((m) {
      return !activeIds.contains(m.id) && !completedIds.contains(m.id);
    }).toList();

    if (availableMissions.isEmpty) {
      return const Center(child: Text('当前暂无新任务'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableMissions.length,
      itemBuilder: (context, index) {
        final mission = availableMissions[index];
        return _MissionCard(mission: mission);
      },
    );
  }
}

class _ActiveMissionsList extends StatelessWidget {
  const _ActiveMissionsList();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final activeMissions = game.activeMissions;

    if (activeMissions.isEmpty) {
      return const Center(child: Text('当前没有进行中的任务'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeMissions.length,
      itemBuilder: (context, index) {
        final active = activeMissions[index];
        final mission = MissionsRepository.getMissionById(active.missionId);
        if (mission == null) return const SizedBox.shrink();
        return _ActiveMissionCard(active: active, mission: mission);
      },
    );
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.mission});

  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mission.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _DifficultyBadge(difficulty: mission.difficulty),
              ],
            ),
            const SizedBox(height: 8),
            Text(mission.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            _RewardPreview(reward: mission.reward),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  context.read<GameState>().acceptMission(mission);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('已接取任务：${mission.title}')),
                  );
                },
                child: const Text('接取任务'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveMissionCard extends StatelessWidget {
  const _ActiveMissionCard({required this.active, required this.mission});

  final ActiveMission active;
  final Mission mission;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = active.currentCount / mission.targetCount;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        side: active.isCompleted
            ? BorderSide(color: theme.colorScheme.primary, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mission.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: active.isCompleted
                        ? theme.colorScheme.primary
                        : null,
                  ),
                ),
                if (active.isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '可提交',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(mission.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              '进度: ${active.currentCount} / ${mission.targetCount} (${mission.targetName})',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: progress.clamp(0.0, 1.0)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<GameState>().abandonMission(active);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                    ),
                    child: const Text('放弃'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: active.isCompleted
                        ? () {
                            context.read<GameState>().submitMission(active);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('任务完成：${mission.title}')),
                            );
                          }
                        : null,
                    child: const Text('提交'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  const _DifficultyBadge({required this.difficulty});

  final int difficulty;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
      ),
      child: Text(
        '难度 $difficulty',
        style: const TextStyle(color: Colors.deepOrange, fontSize: 10),
      ),
    );
  }
}

class _RewardPreview extends StatelessWidget {
  const _RewardPreview({required this.reward});

  final MissionReward reward;

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = [];
    if (reward.contribution > 0) {
      items.add(
        _RewardItem(icon: Icons.groups, text: '贡献 ${reward.contribution}'),
      );
    }
    if (reward.exp > 0) {
      items.add(
        _RewardItem(icon: Icons.auto_awesome, text: '修为 ${reward.exp}'),
      );
    }
    if (reward.itemIds.isNotEmpty) {
      items.add(
        _RewardItem(
          icon: Icons.inventory_2,
          text: '物品 x${reward.itemIds.length}',
        ),
      );
    }

    return Wrap(spacing: 12, runSpacing: 8, children: items);
  }
}

class _RewardItem extends StatelessWidget {
  const _RewardItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Theme.of(context).hintColor),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
