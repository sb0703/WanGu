import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/game_state.dart';

class CultivateSection extends StatelessWidget {
  const CultivateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('境界：${game.player.realm.name}'),
          Text('修为：${game.player.xp}/${game.player.realm.maxXp}'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: game.isDead
                    ? null
                    : () => context.read<GameState>().cultivate(hours: 1),
                icon: const Icon(Icons.hourglass_bottom),
                label: const Text('静坐修炼 1 小时'),
              ),
              OutlinedButton.icon(
                onPressed: game.isDead
                    ? null
                    : () => context.read<GameState>().cultivate(hours: 6),
                icon: const Icon(Icons.nightlight_round),
                label: const Text('闭关 6 小时'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'P0 目标：跑通核心循环。\n- 修炼获取修为\n- 突破自动判定\n- 记录日志\n- 寿元倒计时',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
