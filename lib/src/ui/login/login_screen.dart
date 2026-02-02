import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../state/game_state.dart';
import '../character_creation/character_creation_screen.dart';
import '../home/home_screen.dart';
import '../auth/auth_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _slogan1;
  late String _slogan2;

  final List<List<String>> _slogans = const [
    ['仙路尽头谁为峰', '一见无始道成空'],
    ['天地不仁', '以万物为刍狗'],
    ['顺为凡', '逆则仙'],
    ['大道争锋', '我辈修士当逆天而行'],
    ['红尘万丈', '唯我独尊'],
  ];

  String _connectionStatus = '[未连接]';

  @override
  void initState() {
    super.initState();
    final random = Random();
    final pair = _slogans[random.nextInt(_slogans.length)];
    _slogan1 = pair[0];
    _slogan2 = pair[1];
    _checkServer();

    // Auto show login dialog after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && context.read<GameState>().userId == null) {
          _showAuthDialog();
        }
      });
    });
  }

  Future<void> _checkServer() async {
    final game = context.read<GameState>();
    final isOnline = await game.apiService.checkHealth();
    if (mounted) {
      setState(() {
        _connectionStatus = isOnline ? '[在线]' : '[离线]';
      });
    }
  }

  void _showAuthDialog() {
    showDialog(context: context, builder: (_) => const AuthDialog()).then((
      success,
    ) async {
      if (success == true) {
        setState(() {}); // Refresh to show logged in status
        if (!mounted) return;

        // Auto load save logic
        final game = context.read<GameState>();

        // Show loading
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        final cloudSaves = await game.fetchCloudSaves();

        if (!mounted) return;
        Navigator.pop(context); // Close loading

        if (cloudSaves.isNotEmpty) {
          // Auto load the first save
          // Ideally we should pick the latest one if we had timestamps
          final firstSave = cloudSaves.first;
          final loadSuccess = await game.loadFromServer(firstSave['id']);

          if (!mounted) return;
          if (loadSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('发现云端存档，已自动读取')));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            return;
          }
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('登录成功，请创建角色或读取存档')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Effects (Optional: Particles or subtle flow)
          // For now, just black is fine as per design doc.
          Positioned(
            top: 40,
            right: 20,
            child: Consumer<GameState>(
              builder: (context, game, _) {
                if (game.userId != null) {
                  return InkWell(
                    onTap: () {
                      game.logout();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('已退出登录')));
                    },
                    child: Text(
                      '已登录 ',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.login, color: Colors.white70),
                    tooltip: '登录/注册',
                    onPressed: _showAuthDialog,
                  );
                }
              },
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                const Text(
                  '万 古 墨 境',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    fontFamily: 'Serif', // Fallback
                  ),
                ).animate().fadeIn(duration: 2.seconds).scale(),

                const SizedBox(height: 16),

                const Text(
                  '----------------',
                  style: TextStyle(color: Colors.white24),
                ).animate().fadeIn(delay: 1.seconds),

                const SizedBox(height: 16),

                const Text(
                      '红  尘  渡',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 24,
                        letterSpacing: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 1.5.seconds)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 80),

                // Slogans
                Text(
                  '" $_slogan1 "',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Serif',
                  ),
                ).animate().fadeIn(delay: 2.5.seconds),

                const SizedBox(height: 16),

                Text(
                  '" $_slogan2 "',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Serif',
                  ),
                ).animate().fadeIn(delay: 3.5.seconds),

                const SizedBox(height: 100),

                // Buttons
                _LoginButton(
                  label: '踏 入 仙 途',
                  onTap: () {
                    // Navigate to Character Creation
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CharacterCreationScreen(),
                      ),
                    );
                  },
                  delay: 4.seconds,
                ),

                const SizedBox(height: 24),

                _LoginButton(
                  label: '再 续 前 缘',
                  isSecondary: true,
                  onTap: () async {
                    final game = context.read<GameState>();

                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final cloudSaves = await game.fetchCloudSaves();
                    final hasLocalSave = await game.hasSave();

                    if (!context.mounted) return;
                    Navigator.pop(context); // Close loading

                    if (!hasLocalSave && cloudSaves.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('未发现存档，请先踏入仙途。')),
                      );
                      return;
                    }

                    if (cloudSaves.isNotEmpty) {
                      if (!context.mounted) return;
                      _showSaveSelectionDialog(
                        context,
                        game,
                        hasLocalSave,
                        cloudSaves,
                      );
                    } else {
                      await game.loadFromDisk();
                      if (!context.mounted) return;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    }
                  },
                  delay: 4.5.seconds,
                ),
              ],
            ),
          ),

          // Bottom Info
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'v0.1.0_Alpha | ID: $_connectionStatus',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 12,
                ),
              ),
            ).animate().fadeIn(delay: 5.seconds),
          ),
        ],
      ),
    );
  }

  void _showSaveSelectionDialog(
    BuildContext context,
    GameState game,
    bool hasLocal,
    List<dynamic> cloudSaves,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择存档'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              if (hasLocal)
                ListTile(
                  leading: const Icon(Icons.save),
                  title: const Text('本地存档'),
                  subtitle: const Text('继续本地进度'),
                  onTap: () async {
                    Navigator.pop(context);
                    await game.loadFromDisk();
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),
              if (hasLocal && cloudSaves.isNotEmpty) const Divider(),
              ...cloudSaves.map(
                (save) => ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: Text(save['name'] ?? '云端存档'),
                  subtitle: Text('ID: ${save['id']}'),
                  onTap: () async {
                    Navigator.pop(context);
                    // Show loading
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    final success = await game.loadFromServer(save['id']);

                    if (!context.mounted) return;
                    Navigator.pop(context); // Close loading

                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('读取云端存档失败')));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSecondary;
  final Duration delay;

  const _LoginButton({
    required this.label,
    required this.onTap,
    this.isSecondary = false,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: isSecondary ? Colors.white54 : Colors.white,
        side: BorderSide(color: isSecondary ? Colors.white24 : Colors.white70),
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSecondary ? Colors.white54 : Colors.white,
          fontSize: 16,
          letterSpacing: 4,
        ),
      ),
    ).animate().fadeIn(delay: delay).scale();
  }
}
