import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../state/game_state.dart';

class BreakthroughOverlay extends StatelessWidget {
  const BreakthroughOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameState>();
    final isSuccess = game.breakthroughSuccess;
    final message = game.breakthroughMessage;
    final theme = Theme.of(context);

    if (!game.showingBreakthrough) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Animation
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSuccess
                    ? Colors.amber.withValues(alpha: 0.2)
                    : Colors.red.withValues(alpha: 0.2),
                boxShadow: [
                  BoxShadow(
                    color: (isSuccess ? Colors.amber : Colors.red).withValues(
                      alpha: 0.5,
                    ),
                    blurRadius: 50,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                isSuccess ? Icons.bolt : Icons.broken_image,
                size: 80,
                color: isSuccess ? Colors.amber : Colors.white,
              ),
            )
                .animate(
                  onPlay: (c) => isSuccess ? c.repeat(reverse: true) : c.forward(),
                )
                .scale(
                  duration: 1000.ms,
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                )
                .then(delay: 200.ms)
                .shake(hz: 4, curve: Curves.easeInOut),

            const SizedBox(height: 32),

            // Title
            Text(
              isSuccess ? '突破成功' : '突破失败',
              style: theme.textTheme.displaySmall?.copyWith(
                color: isSuccess ? Colors.amber : Colors.red,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(
                    color: (isSuccess ? Colors.amber : Colors.red).withValues(
                      alpha: 0.8,
                    ),
                    blurRadius: 20,
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.5, end: 0),

            const SizedBox(height: 24),

            // Message
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSuccess
                      ? Colors.amber
                      : Colors.red.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).scale(),

            const SizedBox(height: 48),

            // Button
            FilledButton(
              onPressed: () => game.closeBreakthrough(),
              style: FilledButton.styleFrom(
                backgroundColor: isSuccess ? Colors.amber : Colors.red,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: const Text(
                '确定',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.5, end: 0),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
