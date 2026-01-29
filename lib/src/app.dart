import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/game_state.dart';
import 'ui/home/home_screen.dart';
import 'ui/theme/app_theme.dart';

class WangGuApp extends StatelessWidget {
  const WangGuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: MaterialApp(
        title: '万古墨境：红尘渡',
        theme: AppTheme.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
