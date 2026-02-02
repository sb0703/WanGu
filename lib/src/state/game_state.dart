import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/enemies_repository.dart';
import '../data/items_repository.dart';
import '../data/missions_repository.dart';
import '../data/maps_repository.dart';
import '../data/npcs_repository.dart';
import '../data/punishments_repository.dart';
import '../data/traits_repository.dart';
import '../models/battle.dart';
import '../models/enemy.dart';
import '../models/mission.dart';
import '../models/npc.dart';
import '../models/item.dart';
import '../models/log_entry.dart';
import '../models/map_node.dart';
import '../models/player.dart';
import '../models/realm_stage.dart';
import '../models/stats.dart';
import '../models/world_clock.dart';
import '../services/api_service.dart';
import '../services/npc_generator.dart';
import '../utils/element_logic.dart';

part 'game_state_parts/inventory_logic.dart';
part 'game_state_parts/battle_logic.dart';
part 'game_state_parts/cultivation_logic.dart';
part 'game_state_parts/exploration_logic.dart';
part 'game_state_parts/mission_logic.dart';
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
    _initGameData();
  }

  Future<void> _initGameData() async {
    try {
      final traits = await _apiService.fetchTraits();
      if (traits.isNotEmpty) {
        TraitsRepository.updateTraits(traits);
        notifyListeners();
        _log('已从天道（服务器）获取最新命格信息');
      }
    } catch (e) {
      debugPrint('Init game data failed: $e');
    }
  }

  static const int _baseBagCapacity = 20;
  static const String _saveKey = 'wangu_save_v1';

  final Random _rng;
  final ApiService _apiService = ApiService();
  String? _remoteSaveId;
  Map<String, dynamic>? _userId;

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
  Map<String, String> _npcLocations = {}; // npcId -> mapId
  Map<String, Npc> _npcStates = {}; // npcId -> Npc (Persisted modifications)

  // Battle State
  Battle? _currentBattle;

  // NPC Interaction State
  Npc? _currentInteractionNpc;

  // Breakthrough State
  bool _showingBreakthrough = false;
  bool _breakthroughSuccess = false;
  String _breakthroughMessage = '';

  // Mission State
  List<ActiveMission> _activeMissions = [];
  Set<String> _completedMissionIds = {};

  // Public getters
  ApiService get apiService => _apiService;
  Map<String, dynamic>? get userId => _userId;
  int get tick => _tick;
  WorldClock get clock => _clock;
  Player get player => _player;
  MapNode get currentNode => _currentNode;
  List<MapNode> get mapNodes => List.unmodifiable(_mapNodes);
  List<LogEntry> get logs => List.unmodifiable(_logs);

  List<ActiveMission> get activeMissions => List.unmodifiable(_activeMissions);
  Set<String> get completedMissionIds => Set.unmodifiable(_completedMissionIds);

  bool get isDead => _player.lifespanDays <= 0 || _player.stats.hp <= 0;
  bool get isGameOver => isDead;

  void notify() => notifyListeners();

  // --- Auth ---

  Future<String?> login(String username, String password) async {
    try {
      final user = await _apiService.login(username, password);
      _userId = user;
      _log('登录成功，用户ID: ${user['id']}');
      notify();
      return null; // Success
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<String?> register(String username, String password) async {
    try {
      await _apiService.register(username, password);
      _log('注册成功');
      // Auto login after register? Or just return success.
      return null;
    } catch (e) {
      return e.toString().replaceAll('Exception: ', '');
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (_) {
      // Ignore
    }
    _userId = null;
    _remoteSaveId = null;
    _log('已登出');
    notify();
  }

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

  void startNewGame(Player player) {
    _tick = 0;
    _clock = const WorldClock(year: 1001, month: 1, day: 1);
    _player = player;
    _mapNodes = _seedMap();
    _currentNode = _mapNodes.first;
    _logs = [LogEntry('大道争锋，我辈修士当逆天而行！', tick: 0)];
    _playerGridPos = const Point(0, 0);
    _visitedTiles = {_playerGridPos};
    _currentBattle = null;
    _currentInteractionNpc = null;
    _showingBreakthrough = false;
    _breakthroughSuccess = false;
    _activeMissions = [];
    _completedMissionIds = {};
    _remoteSaveId = null;
    saveToDisk();
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

    // NPC Movement
    _moveNpcs();

    final remainingLife = _player.lifespanDays - days;
    _player = _player.copyWith(lifespanDays: remainingLife);
    if (remainingLife <= 0) {
      _log('寿元耗尽，道途止于此。');
    }
  }

  // --- NPC Logic ---

  void _initNpcLocations() {
    _npcLocations.clear();
    // Load initial locations from MapsRepository
    for (final node in _mapNodes) {
      for (final npcId in node.npcIds) {
        _npcLocations[npcId] = node.id;
      }
    }
    // Ensure all NPCs have a location (fallback to first map if not placed)
    for (final npc in NpcsRepository.getAll()) {
      if (!_npcLocations.containsKey(npc.id)) {
        // Random map or specific spawn? Let's say random map for unplaced NPCs
        _npcLocations[npc.id] = _mapNodes[_rng.nextInt(_mapNodes.length)].id;
      }
    }
  }

  void _moveNpcs() {
    // 30% chance per day/tick for mobile NPCs to move
    // Since _advanceTime might be called with multiple days, we should technically loop
    // or just simulate one move attempt per advance call for simplicity.

    // We iterate a copy of keys to avoid modification issues if any
    final npcIds = _npcLocations.keys.toList();
    for (final npcId in npcIds) {
      final npc = NpcsRepository.get(npcId);
      if (npc == null) continue;

      if (npc.isMobile) {
        // 20% chance to move each time time advances
        if (_rng.nextDouble() < 0.2) {
          final newMap = _mapNodes[_rng.nextInt(_mapNodes.length)];
          _npcLocations[npcId] = newMap.id;

          // Optional: Log if nearby?
          // if (newMap.id == _currentNode.id) {
          //   _log('${npc.name} 来到了此地。');
          // } else if (_npcLocations[npcId] == _currentNode.id && newMap.id != _currentNode.id) {
          //   _log('${npc.name} 离开了此地。');
          // }
        }
      }
    }
  }

  // --- Inventory Shared ---

  int get bagCapacity {
    int bonus = 0;
    for (final item in _player.equipped) {
      bonus += item.spaceBonus;
    }
    return _baseBagCapacity + bonus;
  }

  Item? get equippedSoulbound => _getEquippedInSlot(EquipmentSlot.soulbound);
  Item? get equippedMainHand => _getEquippedInSlot(EquipmentSlot.mainHand);
  Item? get equippedBody => _getEquippedInSlot(EquipmentSlot.body);
  Item? get equippedAccessory => _getEquippedInSlot(EquipmentSlot.accessory);
  Item? get equippedGuard => _getEquippedInSlot(EquipmentSlot.guard);
  Item? get equippedMount => _getEquippedInSlot(EquipmentSlot.mount);

  // Legacy getters for compatibility if needed, or remove them
  Item? get equippedWeapon => equippedMainHand;
  Item? get equippedArmor => equippedBody;

  Item? _getEquippedInSlot(EquipmentSlot slot) {
    for (final item in _player.equipped) {
      if (item.type == ItemType.equipment && item.slot == slot) return item;
    }
    return null;
  }

  bool _addItemById(String id) {
    final item = ItemsRepository.get(id);
    if (item == null) return false;
    return _addItem(item);
  }

  bool _addItem(Item item) {
    // 1. Check for stackable existing item
    if (item.stackable) {
      final index = _player.inventory.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        final existing = _player.inventory[index];
        final newCount = existing.count + item.count;
        // Limit max stack? For now let's say 999 or unlimited.
        // Let's go with unlimited for simplicity or 999.
        final newItem = existing.copyWith(count: newCount);

        final newInventory = [..._player.inventory];
        newInventory[index] = newItem;
        _player = _player.copyWith(inventory: newInventory);

        updateAllCollectionProgress();
        return true;
      }
    }

    // 2. New slot required
    if (_player.inventory.length >= bagCapacity) {
      _log('包裹已满，放弃了 ${item.name}');
      return false;
    }

    _player = _player.copyWith(inventory: [..._player.inventory, item]);
    updateAllCollectionProgress();
    return true;
  }

  // --- Battle Shared ---

  double _itemAttackBonus() {
    return _player.equipped.fold<double>(
      0,
      (sum, item) => sum + item.attackBonus,
    );
  }

  // Moved to battle_logic.dart to be closer to usage
  // double _itemDefenseBonus() { ... }

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
              '天道酬勤，突破大境界！\n晋升 ${next.getName(_player.race)}！\n气血+${next.hpBonus} 攻击+${next.attackBonus}';
          _log('突破成功，晋升 ${next.getName(_player.race)}！');
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
