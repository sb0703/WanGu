import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/game_state.dart';
import 'sections/cultivate_section.dart';
import 'sections/inventory_section.dart';
import 'sections/map_section.dart';
import 'sections/overview_section.dart';
import 'widgets/log_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final tabs = [
      const OverviewSection(),
      const CultivateSection(),
      const MapSection(),
      const InventorySection(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('万古墨境：红尘渡'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('时刻：${game.clock.shortLabel()}'),
                Text(
                  '寿元剩余：${(game.player.lifespanHours / 24 / 365).toStringAsFixed(1)} 年',
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(index: _index, children: tabs),
          ),
          const SizedBox(height: 8),
          const LogPanel(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.assessment), label: '概览'),
          NavigationDestination(
            icon: Icon(Icons.self_improvement),
            label: '修炼',
          ),
          NavigationDestination(icon: Icon(Icons.map), label: '地图'),
          NavigationDestination(icon: Icon(Icons.backpack), label: '背包'),
        ],
      ),
    );
  }
}
