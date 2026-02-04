import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../models/player.dart';
import '../../models/stats.dart';
import '../../state/game_state.dart';
import '../home/home_screen.dart';
import 'steps/identity_step.dart';
import 'steps/spirit_root_step.dart';
import 'steps/summary_step.dart';
import 'steps/traits_step.dart';

import '../../models/item.dart';
import '../../data/items_repository.dart';

class CharacterCreationScreen extends StatefulWidget {
  const CharacterCreationScreen({super.key});

  @override
  State<CharacterCreationScreen> createState() =>
      _CharacterCreationScreenState();
}

class _CharacterCreationScreenState extends State<CharacterCreationScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // --- Creation Data ---
  String _surname = '';
  String _name = '';
  String _gender = '男';
  String _appearance = '平平无奇';

  // Roots & Stats
  Map<String, int> _roots = {};
  Stats _baseStats = const Stats(
    maxHp: 100,
    hp: 100,
    maxSpirit: 50,
    spirit: 50,
    attack: 10,
    defense: 5,
    speed: 10,
    insight: 10,
    purity: 100,
  );
  String _rootDesc = '';
  int _rerollCount = 3;

  // Traits
  List<String> _selectedTraits = [];

  void _nextPage() {
    _pageController.nextPage(duration: 300.ms, curve: Curves.easeInOut);
    setState(() => _currentStep++);
  }

  void _prevPage() {
    _pageController.previousPage(duration: 300.ms, curve: Curves.easeInOut);
    setState(() => _currentStep--);
  }

  Future<void> _startGame() async {
    final game = context.read<GameState>();

    // Initial Inventory Logic
    List<Item> initialInventory = [];

    // Add default items
    // initialInventory.add(ItemsRepository.get('cloth_bag')!);

    // Process Traits for Initial Items
    for (final trait in _selectedTraits) {
      if (trait == '穿越者') {
        _addItemIfExist(initialInventory, 'primary_school_language');
      } else if (trait == '先天剑意') {
        _addItemIfExist(initialInventory, 'basic_sword_intent');
      } else if (trait == '先天丹感') {
        _addItemIfExist(initialInventory, 'pill_sutra_excerpt');
      } else if (trait == '先天阵识') {
        _addItemIfExist(initialInventory, 'array_patterns_intro');
      } else if (trait == '先天符骨') {
        _addItemIfExist(initialInventory, 'talisman_hundred_words');
      } else if (trait == '天外来书') {
        _addItemIfExist(initialInventory, 'otherworld_encyclopedia');
      } else if (trait == '世家子弟') {
        // Handled separately as Spirit Stones or just add item?
        // '初始灵石+200' -> Add to inventory or currency?
        // Game has currency items.
        _addItemIfExist(
          initialInventory,
          'spirit_stone',
          count: 200,
        ); // Assuming 'spirit_stone' is standard currency item
      }
    }

    // Create Player
    final player = Player(
      name: '$_surname$_name',
      gender: _gender,
      stageIndex: 0,
      level: 1,
      stats: _baseStats,
      xp: 0,
      lifespanDays: 80 * 365,
      inventory: initialInventory,
      equipped: [],
      traits: _selectedTraits,
    );

    // Try to register on server
    try {
      await game.apiService.createCharacter({
        'name': player.name,
        'gender': player.gender,
        'appearance': _appearance,
        'roots': {
          'metal': _roots['金'] ?? 0,
          'wood': _roots['木'] ?? 0,
          'water': _roots['水'] ?? 0,
          'fire': _roots['火'] ?? 0,
          'earth': _roots['土'] ?? 0,
        },
        'stats': {
          'maxHp': player.stats.maxHp,
          'hp': player.stats.hp,
          'maxSpirit': player.stats.maxSpirit,
          'spirit': player.stats.spirit,
          'attack': player.stats.attack,
          'defense': player.stats.defense,
          'speed': player.stats.speed,
          'insight': player.stats.insight,
          'purity': player.stats.purity,
        },
        'traits': _selectedTraits,
      }, userId: game.userId);
      
      // We don't use the result ID here as _remoteSaveId anymore,
      // because createCharacter returns Character ID, not Save ID.
      // The Save ID will be generated when saveToDisk() calls createSave() in persistence logic.
    } catch (e) {
      debugPrint('Server character creation failed: $e');
    }

    // Start game (this will trigger saveToDisk -> saveToServer)
    game.startNewGame(player);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _addItemIfExist(List<Item> inventory, String itemId, {int count = 1}) {
    final item = ItemsRepository.get(itemId);
    if (item != null) {
      // Check if stackable and already exists
      if (item.stackable) {
        final existingIndex = inventory.indexWhere((i) => i.id == itemId);
        if (existingIndex != -1) {
          final existing = inventory[existingIndex];
          inventory[existingIndex] = existing.copyWith(
            count: existing.count + count,
          );
          return;
        }
      }
      inventory.add(item.copyWith(count: count));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: Colors.white10,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  IdentityStep(
                    onConfirm: (surname, name, gender, appearance) {
                      setState(() {
                        _surname = surname;
                        _name = name;
                        _gender = gender;
                        _appearance = appearance;
                      });
                      _nextPage();
                    },
                  ),
                  SpiritRootStep(
                    rerollCount: _rerollCount,
                    onReroll: (roots, stats, desc) {
                      setState(() {
                        _roots = roots;
                        _baseStats = stats;
                        _rootDesc = desc;
                        _rerollCount--;
                      });
                    },
                    onConfirm: () => _nextPage(),
                    currentRoots: _roots,
                    currentStats: _baseStats,
                    currentDesc: _rootDesc,
                  ),
                  TraitsStep(
                    onConfirm: (traits) {
                      setState(() {
                        _selectedTraits = traits;
                      });
                      _nextPage();
                    },
                  ),
                  SummaryStep(
                    surname: _surname,
                    name: _name,
                    gender: _gender,
                    appearance: _appearance,
                    roots: _roots,
                    rootDesc: _rootDesc,
                    stats: _baseStats,
                    traits: _selectedTraits,
                    onStart: _startGame,
                    onBack: _prevPage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
