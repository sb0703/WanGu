import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/game_state.dart';
import 'map_section.dart';

class SectSection extends StatelessWidget {
  const SectSection({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final theme = Theme.of(context);

    // 宗门设施数据
    final facilities = [
      _FacilityData(
        name: '外出游历',
        description: '探索世界，寻找机缘',
        icon: Icons.explore,
        color: const Color(0xFF29B6F6),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MapScreen()),
          );
        },
      ),
      _FacilityData(
        name: '宗门大殿',
        description: '处理宗门事务，查看宗门信息',
        icon: Icons.account_balance,
        color: const Color(0xFF8D6E63),
        onTap: () {},
      ),
      _FacilityData(
        name: '藏经阁',
        description: '研习功法，参悟秘籍',
        icon: Icons.menu_book,
        color: const Color(0xFF5D4037),
        onTap: () {},
      ),
      _FacilityData(
        name: '炼丹房',
        description: '炼制丹药，提升修为',
        icon: Icons.science, // Flask icon not available, using science
        color: const Color(0xFFEF5350),
        onTap: () {},
      ),
      _FacilityData(
        name: '炼器室',
        description: '锻造法宝，强化装备',
        icon: Icons.handyman, // Hammer icon
        color: const Color(0xFFFFA726),
        onTap: () {},
      ),
      _FacilityData(
        name: '灵田',
        description: '种植灵草，培育灵兽',
        icon: Icons.grass,
        color: const Color(0xFF66BB6A),
        onTap: () {},
      ),
      _FacilityData(
        name: '弟子居',
        description: '休息恢复，打坐静修',
        icon: Icons.hotel,
        color: const Color(0xFF78909C),
        onTap: () {
          if (!game.isDead) {
            context.read<GameState>().rest();
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(const SnackBar(content: Text('休息了一会儿，体力已恢复。')));
          }
        },
      ),
      _FacilityData(
        name: '任务堂',
        description: '领取宗门任务，赚取贡献',
        icon: Icons.assignment,
        color: const Color(0xFFAB47BC),
        onTap: () {},
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 宗门头部信息
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  '无名宗', // 暂定宗门名称
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '宗门等级：一品  |  弟子：1人',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Text('宗门建设中...', style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        Text(
          '宗门设施',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // 设施网格
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: facilities.length,
          itemBuilder: (context, index) {
            return _FacilityCard(data: facilities[index]);
          },
        ),
      ],
    );
  }
}

class _FacilityData {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _FacilityData({
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _FacilityCard extends StatelessWidget {
  final _FacilityData data;

  const _FacilityCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, color: data.color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                data.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.description,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
