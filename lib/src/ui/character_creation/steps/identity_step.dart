import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class IdentityStep extends StatefulWidget {
  final Function(String surname, String name, String gender, String appearance)
  onConfirm;

  const IdentityStep({super.key, required this.onConfirm});

  @override
  State<IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<IdentityStep> {
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _gender = '男';
  String _appearance = '平平无奇';

  final List<String> _appearances = ['清秀', '粗犷', '平平无奇', '仙姿绝色'];

  // Random Name Database
  final List<String> _surnames = [
    '韩',
    '王',
    '叶',
    '林',
    '萧',
    '苏',
    '方',
    '李',
    '陈',
    '顾',
  ];
  final List<String> _namesM = [
    '立',
    '林',
    '凡',
    '炎',
    '动',
    '铭',
    '源',
    '尘',
    '平',
    '天',
  ];
  final List<String> _namesF = [
    '婉',
    '雪',
    '瑶',
    '灵',
    '曦',
    '月',
    '嫣',
    '清',
    '柔',
    '萱',
  ];

  void _randomName() {
    final rng = Random();
    setState(() {
      _surnameController.text = _surnames[rng.nextInt(_surnames.length)];
      _nameController.text = _gender == '男'
          ? _namesM[rng.nextInt(_namesM.length)]
          : _namesF[rng.nextInt(_namesF.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  '冥冥之中，你听到了唤魂的声音……\n"来者何人？"',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ).animate().fadeIn(duration: 1.seconds),

                const SizedBox(height: 48),

                // Name Input
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _surnameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: '姓',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: '名',
                          labelStyle: TextStyle(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton.filled(
                      onPressed: _randomName,
                      icon: const Icon(Icons.casino),
                      tooltip: '随机姓名',
                    ),
                  ],
                ).animate().fadeIn(delay: 0.5.seconds).slideX(),

                const SizedBox(height: 32),

                // Gender
                Text(
                  '性别',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _GenderCard(
                      label: '男',
                      icon: Icons.male,
                      isSelected: _gender == '男',
                      onTap: () => setState(() => _gender = '男'),
                    ),
                    const SizedBox(width: 16),
                    _GenderCard(
                      label: '女',
                      icon: Icons.female,
                      isSelected: _gender == '女',
                      onTap: () => setState(() => _gender = '女'),
                    ),
                  ],
                ).animate().fadeIn(delay: 0.8.seconds).slideX(),

                const SizedBox(height: 32),

                // Appearance
                Text(
                  '相貌',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _appearances.map((app) {
                    final isSelected = _appearance == app;
                    return ChoiceChip(
                      label: Text(app),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _appearance = app);
                      },
                      selectedColor: theme.colorScheme.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : Colors.black,
                      ),
                      backgroundColor: Colors.white10,
                    );
                  }).toList(),
                ).animate().fadeIn(delay: 1.1.seconds).slideX(),

                const Spacer(),

                // Next Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (_surnameController.text.isEmpty ||
                          _nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('请留下尊姓大名')),
                        );
                        return;
                      }
                      widget.onConfirm(
                        _surnameController.text,
                        _nameController.text,
                        _gender,
                        _appearance,
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('下一步：测灵根'),
                  ),
                ).animate().fadeIn(delay: 1.5.seconds),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.colorScheme.primary : Colors.white10;
    final contentColor = isSelected
        ? theme.colorScheme.onPrimary
        : Colors.white54;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : Colors.white24,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: contentColor, size: 32),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: contentColor,
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
