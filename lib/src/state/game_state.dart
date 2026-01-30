import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enemies_repository.dart';
import '../data/items_repository.dart';
import '../data/maps_repository.dart';
import '../data/npcs_repository.dart';
import '../data/punishments_repository.dart';
import '../models/battle.dart';
import '../models/enemy.dart';
import '../models/npc.dart';
import '../models/item.dart';
import '../models/log_entry.dart';
import '../models/map_node.dart';
import '../models/player.dart';
import '../models/realm_stage.dart';
import '../models/stats.dart';
import '../models/world_clock.dart';

part 'game_state_parts/inventory_logic.dart';
part 'game_state_parts/battle_logic.dart';
part 'game_state_parts/cultivation_logic.dart';
part 'game_state_parts/exploration_logic.dart';
part 'game_state_parts/persistence_logic.dart';

class GameState extends ChangeNotifier {
  GameState()
    : _rng = Random(),
      _tick = 0,
      _clock = const WorldClock(year: 1001, month: 1, day: 1),
      _player = const Player(
        name: '无名散修',
        stageIndex: 0,
        xp: 0,
        lifespanDays: 80 * 365, // 80年寿元（按天计）
        stats: Stats(
          maxHp: 80,
          hp: 80,
          maxSpirit: 50,
          spirit: 50,
          attack: 12,
          defense: 6,
          speed: 8,
          insight: 4,
          purity: 100,
        ),
        inventory: [],
        equipped: [],
      ),
      _logs = const [] {
    _mapNodes = _seedMap();
    _currentNode = _mapNodes.first;
    _log('踏入修真界，起点：${_currentNode.name}');
  }

  static const int _baseBagCapacity = 20;
  static const String _saveKey = 'wangu_save_v1';

  final Random _rng;
  int _tick;
  WorldClock _clock;
  Player _player;
  late List<MapNode> _mapNodes;
  late MapNode _currentNode;
  List<LogEntry> _logs;

  // Grid Exploration State
  static const int gridRows = 8;
  static const int gridCols = 6;
  Point<int> _playerGridPos = const Point(0, 0);
  Set<Point<int>> _visitedTiles = {};

  // Battle State
  Battle? _currentBattle;

  // NPC Interaction State
  Npc? _currentInteractionNpc;

  // Breakthrough State
  bool _showingBreakthrough = false;
  bool _breakthroughSuccess = false;
  String _breakthroughMessage = '';

  // Public getters
  int get tick => _tick;
  WorldClock get clock => _clock;
  Player get player => _player;
  MapNode get currentNode => _currentNode;
  List<MapNode> get mapNodes => List.unmodifiable(_mapNodes);
  List<LogEntry> get logs => List.unmodifiable(_logs);

  bool get isDead => _player.lifespanDays <= 0 || _player.stats.hp <= 0;
  bool get isGameOver => isDead;

  void notify() => notifyListeners();

  void resetGame() {
    _tick = 0;
    _clock = const WorldClock(year: 1001, month: 1, day: 1);
    _player = const Player(
      name: '韩立',
      stageIndex: 0,
      level: 1,
      stats: Stats(
        maxHp: 100,
        hp: 100,
        maxSpirit: 50,
        spirit: 50,
        attack: 10,
        defense: 5,
        speed: 10,
        insight: 10,
        purity: 100,
      ),
      xp: 0,
      lifespanDays: 36500, // 100 years
      inventory: [],
      equipped: [],
    );
    _mapNodes = _seedMap();
    _currentNode = _mapNodes.first;
    _logs = [LogEntry('大道争锋，我辈修士当逆天而行！', tick: 0)];
    _playerGridPos = const Point(0, 0);
    _visitedTiles = {_playerGridPos};
    _currentBattle = null;
    _currentInteractionNpc = null;
    _showingBreakthrough = false;
    _breakthroughSuccess = false;
    notifyListeners();
  }

  // --- Shared Utility Methods ---

  void _log(String message) {
    final stamped = '[${_clock.shortLabel()}] $message';
    final newLogs = [..._logs, LogEntry(stamped, tick: _tick)];
    // 只保留最近 80 条
    _logs = newLogs.length > 80
        ? newLogs.sublist(newLogs.length - 80)
        : newLogs;
  }

  void _advanceTime(num days) {
    _tick += (days * 1).toInt();
    _clock = _clock.tickDays(days);
    final remainingLife = _player.lifespanDays - days;
    _player = _player.copyWith(lifespanDays: remainingLife);
    if (remainingLife <= 0) {
      _log('寿元耗尽，道途止于此。');
    }
  }

  // --- Inventory Shared ---

  int get bagCapacity {
    int bonus = 0;
    for (final item in _player.equipped) {
      if (item.type == ItemType.storage) {
        bonus += item.spaceBonus;
      }
    }
    return _baseBagCapacity + bonus;
  }

  Item? get equippedWeapon => _firstEquipped(ItemType.weapon);
  Item? get equippedArmor => _firstEquipped(ItemType.armor);

  Item? _firstEquipped(ItemType type) {
    for (final item in _player.equipped) {
      if (item.type == type) return item;
    }
    return null;
  }

  bool _addItemById(String id) {
    final item = ItemsRepository.get(id);
    if (item == null) return false;
    return _addItem(item);
  }

  bool _addItem(Item item) {
    if (_player.inventory.length >= bagCapacity) {
      _log('包裹已满，放弃了 ${item.name}');
      return false;
    }
    _player = _player.copyWith(inventory: [..._player.inventory, item]);
    return true;
  }

  // --- Battle Shared ---

  double _itemAttackBonus() {
    return _player.equipped.fold<double>(
      0,
      (sum, item) => sum + item.attackBonus,
    );
  }

  double _itemDefenseBonus() {
    return _player.equipped.fold<double>(
      0,
      (sum, item) => sum + item.defenseBonus,
    );
  }

  double _itemSpeedBonus() {
    return _player.equipped.fold<double>(0, (sum, item) => sum + item.speed);
  }

  Enemy _rollEnemy(int danger) {
    return EnemiesRepository.rollEnemy(danger);
  }

  void _encounterEnemy(MapNode node) {
    final enemy = _rollEnemy(node.danger);
    _log('遭遇 ${enemy.name}！准备战斗！');

    // Start Battle State (Use effective stats for max values)
    _currentBattle = Battle(
      enemy: enemy,
      playerHp: _player.stats.hp,
      playerMaxHp: _player.effectiveStats.maxHp,
      playerSpirit: _player.stats.spirit,
      playerMaxSpirit: _player.effectiveStats.maxSpirit,
    );
    notify();
  }

  // --- Cultivation Shared ---

  double get estimatedBreakthroughChance {
    final isMajorBreakthrough = _player.level >= 10;
    double rate;

    // Use effectiveStats for insight/purity calculations
    if (isMajorBreakthrough) {
      // Major Breakthrough Base
      rate = 0.6 * (0.72 + _player.effectiveStats.insight * 0.02);

      // Check pills
      final hasPill =
          _player.inventory.any(
            (i) => i.id == 'foundation_pill' && _player.stageIndex == 0,
          ) ||
          _player.inventory.any(
            (i) => i.id == 'qi_pill' && _player.stageIndex == -1,
          );
      if (hasPill) rate += 0.3;
    } else {
      // Minor Breakthrough Base
      rate = 0.9 + _player.effectiveStats.insight * 0.01;
    }

    // Apply Purity Factor to EVERYTHING
    final purityFactor = _player.effectiveStats.purity / 100.0;
    rate *= purityFactor;

    return rate.clamp(0.01, 0.95);
  }

  void _checkBreakthrough() {
    final maxXp = _player.currentMaxXp;
    if (_player.xp < maxXp) return;

    final successRate = estimatedBreakthroughChance;
    final success = _rng.nextDouble() < successRate;

    _showingBreakthrough = true;
    _breakthroughSuccess = success;

    final isMajorBreakthrough = _player.level >= 10;

    if (success) {
      if (isMajorBreakthrough) {
        if (_player.stageIndex < RealmStage.stages.length - 1) {
          final nextStageIndex = _player.stageIndex + 1;
          final next = RealmStage.stages[nextStageIndex];
          _player = _player.copyWith(
            stageIndex: nextStageIndex,
            level: 1,
            xp: 0,
            stats: _player.stats.copyWith(
              maxHp: _player.stats.maxHp + next.hpBonus,
              hp: _player.stats.maxHp + next.hpBonus,
              attack: _player.stats.attack + next.attackBonus,
              maxSpirit: _player.stats.maxSpirit + next.spiritBonus,
              spirit: (_player.stats.spirit + next.spiritBonus).clamp(
                0,
                _player.stats.maxSpirit + next.spiritBonus,
              ),
            ),
          );
          _breakthroughMessage =
              '天道酬勤，突破大境界！\n晋升 ${next.name}！\n气血+${next.hpBonus} 攻击+${next.attackBonus}';
          _log('突破成功，晋升 ${next.name}！');
        } else {
          _breakthroughMessage = '已至世界巅峰，无法再进！';
        }
      } else {
        final newLevel = _player.level + 1;
        final hpBoost = 10 + _player.stageIndex * 5;
        final atkBoost = 2 + _player.stageIndex;

        _player = _player.copyWith(
          level: newLevel,
          xp: 0,
          stats: _player.stats.copyWith(
            maxHp: _player.stats.maxHp + hpBoost,
            hp: _player.stats.maxHp + hpBoost,
            attack: _player.stats.attack + atkBoost,
          ),
        );
        _breakthroughMessage =
            '突破成功，达到 ${_player.realmLabel}！\n气血+$hpBoost 攻击+$atkBoost';
        _log('小境界突破成功，达到 ${_player.realmLabel}！');
      }
    } else {
      _handleBreakthroughFailure(maxXp, isMajorBreakthrough);
    }
    notify();
    saveToDisk();
  }

  void _handleBreakthroughFailure(int maxXp, bool isMajor) {
    final result = PunishmentsRepository.applyPunishment(
      player: _player,
      maxXp: maxXp,
      isMajorBreakthrough: isMajor,
      rng: _rng,
    );

    _player = result.player;
    _breakthroughMessage = result.message;

    if (result.logMessage.isNotEmpty) {
      _log(result.logMessage);
    }

    if (result.teleportToDanger) {
      if (_mapNodes.isNotEmpty) {
        final dangerousNode = _mapNodes.reduce(
          (curr, next) => curr.danger > next.danger ? curr : next,
        );
        if (dangerousNode != _currentNode) {
          _currentNode = dangerousNode;
          _playerGridPos = const Point(0, 0);
          _visitedTiles = {_playerGridPos};
          _log('空间裂缝撕裂，你被强制传送到了 ${dangerousNode.name}！');
        }
      }
    }

    if (result.spawnNemesis) {
      _encounterEnemy(_currentNode);
    }

    if (result.daysPassed > 0) {
      _advanceTime(result.daysPassed);
    }
  }

  // --- Exploration Shared ---

  List<MapNode> _seedMap() {
    return MapsRepository.getAll();
  }
}
