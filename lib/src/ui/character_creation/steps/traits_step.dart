import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/traits_repository.dart';
import '../../../models/trait.dart';

class TraitsStep extends StatefulWidget {
  final Function(List<String> traits) onConfirm;

  const TraitsStep({super.key, required this.onConfirm});

  @override
  State<TraitsStep> createState() => _TraitsStepState();
}

class _TraitsStepState extends State<TraitsStep> {
  final List<String> _selected = [];
  late List<Trait> _availableTraits;
  int _refreshCount = 3;

  @override
  void initState() {
    super.initState();
    _rollTraits();
  }

  void _rollTraits() {
    final allTraits = TraitsRepository.getAll();
    final rng = Random();
    // Shuffle and take 5
    _availableTraits = (List<Trait>.from(allTraits)..shuffle(rng)).take(5).toList();
    _selected.clear();
  }

  void _refresh() {
    if (_refreshCount > 0) {
      setState(() {
        _refreshCount--;
        _rollTraits();
      });
    }
  }

  void _toggle(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
      } else {
        if (_selected.length < 3) {
          _selected.add(name);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('最多只能选择 3 个命格')),
          );
        }
      }
    });
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
          Row(
            children: [
              Expanded(
                child: Text(
                  '轮回通道中，几道流光钻入了你的体内……\n请选择 3 项命格融入灵魂：',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              if (_refreshCount > 0)
                TextButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: Text('刷新 ($_refreshCount)'),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.tertiary,
                  ),
                )
              else
                Text(
                  '刷新次数已尽',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
            ],
          ),
          
          const SizedBox(height: 32),

          Expanded(
            child: ListView.separated(
              itemCount: _availableTraits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final trait = _availableTraits[index];
                final isSelected = _selected.contains(trait.name);
                final color = trait.color;

                return InkWell(
                  onTap: () => _toggle(trait.name),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.2) : Colors.white10,
                      border: Border.all(
                        color: isSelected ? color : Colors.white12,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) => _toggle(trait.name),
                          activeColor: color,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trait.name,
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                trait.description,
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(key: ValueKey(trait.id)).fadeIn(delay: (index * 100).ms).slideX();
              },
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _selected.length == 3 
                  ? () => widget.onConfirm(_selected) 
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('确 定 (${_selected.length}/3)'),
            ),
          ),
        ],
      ),
    );
  }
}

