import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/game_state.dart';
import 'ui/home/home_screen.dart';

class WangGuApp extends StatelessWidget {
  const WangGuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: '万古墨境：红尘渡',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F4C3A)),
          useMaterial3: true,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(letterSpacing: 0.1),
            bodySmall: TextStyle(letterSpacing: 0.15),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
