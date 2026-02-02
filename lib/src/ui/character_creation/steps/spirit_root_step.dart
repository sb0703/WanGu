import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/stats.dart';

class SpiritRootStep extends StatefulWidget {
  final int rerollCount;
  final Function(Map<String, int> roots, Stats stats, String desc) onReroll;
  final VoidCallback onConfirm;
  final Map<String, int> currentRoots;
  final Stats currentStats;
  final String currentDesc;

  const SpiritRootStep({
    super.key,
    required this.rerollCount,
    required this.onReroll,
    required this.onConfirm,
    required this.currentRoots,
    required this.currentStats,
    required this.currentDesc,
  });

  @override
  State<SpiritRootStep> createState() => _SpiritRootStepState();
}

class _SpiritRootStepState extends State<SpiritRootStep> {
  bool _isRolling = false;

  void _roll() async {
    if (widget.rerollCount <= 0 && widget.currentRoots.isNotEmpty) return;

    setState(() => _isRolling = true);

    // Simulate rolling animation
    await Future.delayed(500.ms);

    final rng = Random();

    // Roots
    final roots = {
      '金': rng.nextInt(100),
      '木': rng.nextInt(100),
      '水': rng.nextInt(100),
      '火': rng.nextInt(100),
      '土': rng.nextInt(100),
    };

    // Determine Best Root
    String bestRoot = '金';
    int maxVal = -1;
    roots.forEach((k, v) {
      if (v > maxVal) {
        maxVal = v;
        bestRoot = k;
      }
    });

    String desc = '';
    if (maxVal >= 90) {
      desc = '【$bestRoot系天灵根】天资绝世，万中无一。';
    } else if (maxVal >= 80) {
      desc = '【$bestRoot系地灵根】资质上佳，宗门争抢。';
    } else if (maxVal >= 60) {
      desc = '【$bestRoot系真灵根】资质尚可，有望大道。';
    } else {
      desc = '【五行杂灵根】资质平平，需勤能补拙。';
    }

    // Base Stats
    final stats = Stats(
      maxHp: 80 + rng.nextInt(40),
      hp: 80 + rng.nextInt(40),
      maxSpirit: 40 + rng.nextInt(20),
      spirit: 40 + rng.nextInt(20),
      attack: 8 + rng.nextInt(5),
      defense: 4 + rng.nextInt(4),
      speed: 8 + rng.nextInt(5),
      insight: 5 + rng.nextInt(10), // Important for XP
      purity: 80 + rng.nextInt(20), // Initial purity
    );

    widget.onReroll(roots, stats, desc);

    setState(() => _isRolling = false);
  }

  @override
  void initState() {
    super.initState();
    if (widget.currentRoots.isEmpty) {
      _roll(); // Auto roll first time
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            '触摸测灵碑，你的掌心泛起光芒……',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 32),

          // Roots Display
          if (widget.currentRoots.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: widget.currentRoots.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            e.key,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: e.value / 100,
                            backgroundColor: Colors.black26,
                            color: _getRootColor(e.key),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${e.value}',
                          style: TextStyle(
                            color: _getQualityColor(e.value),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate(target: _isRolling ? 0 : 1).fadeIn().slideY(),

          const SizedBox(height: 16),

          // Description
          if (widget.currentDesc.isNotEmpty)
            Text(
              widget.currentDesc,
              style: TextStyle(
                color: Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ).animate(target: _isRolling ? 0 : 1).fadeIn(),

          const SizedBox(height: 24),

          // Stats
          if (widget.currentRoots.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(label: '根骨', value: widget.currentStats.maxHp ~/ 10),
                _StatItem(label: '悟性', value: widget.currentStats.insight),
                _StatItem(
                  label: '机缘',
                  value: Random().nextInt(100),
                ), // Fake luck for now
                _StatItem(label: '纯度', value: widget.currentStats.purity),
              ],
            ).animate(target: _isRolling ? 0 : 1).fadeIn().slideX(),

          const Spacer(),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.rerollCount > 0 ? _roll : null,
                  icon: const Icon(Icons.refresh),
                  label: Text('逆天改命 (${widget.rerollCount})'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: widget.currentRoots.isNotEmpty
                      ? widget.onConfirm
                      : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('下一步：定命格'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRootColor(String root) {
    switch (root) {
      case '金':
        return Colors.amber;
      case '木':
        return Colors.green;
      case '水':
        return Colors.blue;
      case '火':
        return Colors.red;
      case '土':
        return Colors.brown;
      default:
        return Colors.white;
    }
  }

  Color _getQualityColor(int val) {
    if (val >= 90) return Colors.orange;
    if (val >= 80) return Colors.purple;
    if (val >= 60) return Colors.blue;
    return Colors.grey;
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final int value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white54),
        ),
      ],
    );
  }
}
