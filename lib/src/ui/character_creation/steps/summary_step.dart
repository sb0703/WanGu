import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../models/stats.dart';

class SummaryStep extends StatelessWidget {
  final String surname;
  final String name;
  final String gender;
  final String appearance;
  final Map<String, int> roots;
  final String rootDesc;
  final Stats stats;
  final List<String> traits;
  final VoidCallback onStart;
  final VoidCallback onBack;

  const SummaryStep({
    super.key,
    required this.surname,
    required this.name,
    required this.gender,
    required this.appearance,
    required this.roots,
    required this.rootDesc,
    required this.stats,
    required this.traits,
    required this.onStart,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            '生 辰 八 字 帖',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
              color: Colors.amber,
            ),
          ).animate().fadeIn().scale(),

          const SizedBox(height: 32),

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D2D),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.amber.withValues(alpha: 0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Row('姓名', '$surname$name'),
                  _Row('性别', gender),
                  _Row('相貌', appearance),
                  const Divider(color: Colors.white12, height: 32),
                  _Row('灵根', rootDesc),
                  _Row(
                    '资质',
                    '根骨${stats.maxHp ~/ 10} / 悟性${stats.insight} / 纯度${stats.purity}',
                  ),
                  const Divider(color: Colors.white12, height: 32),
                  const Text(
                    '命格',
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: traits
                        .map(
                          (t) => Chip(
                            label: Text(t),
                            backgroundColor: Colors.white10,
                            labelStyle: const TextStyle(color: Colors.black54),
                          ),
                        )
                        .toList(),
                  ),
                  const Spacer(),
                  const Center(
                    child: Text(
                      '" 此去红尘，生死由命，富贵在天 "',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 0.3.seconds).slideY(begin: 0.1, end: 0),
          ),

          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onStart,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                backgroundColor: Colors.amber[800],
                foregroundColor: Colors.black,
              ),
              child: const Text(
                '破 碎 虚 空',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 0.6.seconds).shimmer(duration: 2.seconds),

          const SizedBox(height: 16),

          TextButton(
            onPressed: onBack,
            child: const Text('返回重塑', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(label, style: const TextStyle(color: Colors.white54)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
