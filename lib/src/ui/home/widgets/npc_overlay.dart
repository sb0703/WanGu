import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../state/game_state.dart';

class NpcOverlay extends StatefulWidget {
  const NpcOverlay({super.key});

  @override
  State<NpcOverlay> createState() => _NpcOverlayState();
}

class _NpcOverlayState extends State<NpcOverlay> {
  String? _currentDialog;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final npc = game.currentInteractionNpc;
    final theme = Theme.of(context);

    if (npc == null) return const SizedBox.shrink();

    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Text(
                        npc.name[0],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(npc.name, style: theme.textTheme.titleLarge),
                          Text(
                            npc.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => game.endNpcInteraction(),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      _currentDialog ?? npc.description,
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(),

                    const SizedBox(height: 24),

                    if (_currentDialog != null) ...[
                      Text(
                        '好感度: ${npc.friendship}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Actions
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        FilledButton.icon(
                          onPressed: () {
                            game.talkToNpc();
                            setState(() {
                              _currentDialog = (List<String>.from(
                                npc.dialogues,
                              )..shuffle()).first;
                            });
                          },
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: const Text('交谈'),
                        ),
                        FilledButton.icon(
                          onPressed: () => _showGiftDialog(context, game),
                          icon: const Icon(Icons.card_giftcard),
                          label: const Text('赠送'),
                        ),
                        FilledButton.icon(
                          onPressed: () => game.stealFromNpc(),
                          icon: const Icon(Icons.back_hand),
                          label: const Text('窃取'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentDialog =
                                  npc.description; // Back to description
                            });
                          },
                          icon: const Icon(Icons.info_outline),
                          label: const Text('查看'),
                        ),
                        FilledButton.icon(
                          onPressed: () => game.attackNpc(npc),
                          icon: const Icon(Icons.flash_on),
                          label: const Text('攻击'),
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }

  void _showGiftDialog(BuildContext context, GameState game) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final inventory = game.player.inventory;
        if (inventory.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('背包空空如也')),
          );
        }
        return Container(
          height: 400,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('选择赠送的物品', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: inventory.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = inventory[index];
                    return ListTile(
                      leading: const Icon(Icons.inventory_2_outlined),
                      title: Text(item.name),
                      subtitle: Text(item.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text('x${item.count}'),
                      onTap: () {
                        game.giftNpc(item);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
