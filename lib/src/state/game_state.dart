import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/enemies_repository.dart';
import '../data/items_repository.dart';
import '../data/maps_repository.dart';
import '../models/battle.dart';
import '../models/enemy.dart';
import '../models/item.dart';
import '../models/log_entry.dart';
import '../models/map_node.dart';
import '../models/player.dart';
import '../models/realm_stage.dart';
import '../models/stats.dart';
import '../models/world_clock.dart';

class GameState extends ChangeNotifier {
  GameState()
    : _rng = Random(),
      _tick = 0,
      _clock = const WorldClock(year: 1001, month: 1, day: 1),
      _player = Player(
        name: '无名散修',
        stageIndex: 0,
        xp: 0,
        lifespanDays: 80 * 365, // 80年寿元（按天）
        stats: const Stats(
          maxHp: 80,
          hp: 80,
          maxSpirit: 50,
          spirit: 50,
          attack: 12,
          defense: 6,
          speed: 8,
          insight: 4,
        ),
        inventory: const [],
        equipped: const [],
      ),
      _logs = const [] {
    _mapNodes = _seedMap();
    _currentNode = _mapNodes.first;
    _log('踏入修真界，起点：${_currentNode.name}');
  }

  static const int _bagCapacity = 20;

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
  Battle? get currentBattle => _currentBattle;

  // Getters for exploration
  Point<int> get playerGridPos => _playerGridPos;
  Set<Point<int>> get visitedTiles => _visitedTiles;

  // Public getters
  int get tick => _tick;
  WorldClock get clock => _clock;
  Player get player => _player;
  MapNode get currentNode => _currentNode;
  List<MapNode> get mapNodes => List.unmodifiable(_mapNodes);
  List<LogEntry> get logs => List.unmodifiable(_logs);
  Item? get equippedWeapon => _firstEquipped(ItemType.weapon);
  Item? get equippedArmor => _firstEquipped(ItemType.armor);
  int get bagCapacity => _bagCapacity;

  bool get isDead => _player.lifespanDays <= 0 || _player.stats.hp <= 0;
  bool get isGameOver => isDead;

  Item? _firstEquipped(ItemType type) {
    for (final item in _player.equipped) {
      if (item.type == type) return item;
    }
    return null;
  }

  void cultivate({int days = 1}) {
    if (isDead) return;
    final gainedXp = 6 + _player.stats.insight;
    _player = _player.copyWith(xp: _player.xp + gainedXp);
    _advanceTime(days);
    _log('闭关修炼，获得 $gainedXp 修为');
    _checkBreakthrough();
    notifyListeners();
  }

  /// Enter a new region (travel)
  void enterRegion(MapNode node) {
    if (isDead) return;
    if (_currentNode == node) return; // Already here

    _currentNode = node;
    _advanceTime(1); // Travel takes time
    _log('抵达 ${_currentNode.name}，开始探索。');

    // Reset exploration state
    _playerGridPos = const Point(0, 0); // Start at top-left or random
    _visitedTiles = {_playerGridPos};

    notifyListeners();
  }

  /// Move within the grid
  void exploreMove(int row, int col) {
    if (isDead) return;

    final target = Point(row, col);
    if (_visitedTiles.contains(target) && target != _playerGridPos) {
      // Just moving to already visited tile
      _playerGridPos = target;
      notifyListeners();
      return;
    }

    // Moving to new tile or current tile (if logic requires)
    // Validate adjacency? For now allow click any adjacent
    final dx = (target.x - _playerGridPos.x).abs();
    final dy = (target.y - _playerGridPos.y).abs();
    if (dx + dy != 1) {
      // Only allow adjacent moves
      return;
    }

    _playerGridPos = target;
    _visitedTiles.add(target);

    // Trigger Event
    _advanceTime(
      0,
    ); // 0 days, maybe add hours later. For now just tick internally if needed.
    // Let's say 2 hours per step?
    // _clock = _clock.tickHours(2); // Need to implement tickHours in WorldClock or just ignore for now

    _triggerNodeEvent(_currentNode);
    notifyListeners();
  }

  // Deprecated: moveTo used to be direct travel+event
  // Keeping for compatibility if needed, but should use enterRegion + exploreMove
  void moveTo(MapNode node) {
    enterRegion(node);
  }

  void rest({int days = 2}) {
    if (isDead) return;
    final newHp = (_player.stats.hp + 10 * days).clamp(0, _player.stats.maxHp);
    final newSpirit = (_player.stats.spirit + 8 * days).clamp(
      0,
      _player.stats.maxSpirit,
    );
    _player = _player.copyWith(
      stats: _player.stats.copyWith(hp: newHp, spirit: newSpirit),
    );
    _advanceTime(days);
    _log('调息恢复，气血/灵力回复');
    notifyListeners();
  }

  bool _addItemById(String id) {
    final item = ItemsRepository.get(id);
    if (item == null) return false;
    return _addItem(item);
  }

  bool _addItem(Item item) {
    if (_player.inventory.length >= _bagCapacity) {
      _log('包裹已满，放弃了 ${item.name}');
      return false;
    }
    _player = _player.copyWith(inventory: [..._player.inventory, item]);
    return true;
  }

  void discard(Item item) {
    if (!_player.inventory.contains(item)) {
      return;
    }
    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(inventory: newInventory);
    _log('丢弃了 ${item.name}');
    notifyListeners();
  }

  void equipWeapon(Item item) {
    if (item.type != ItemType.weapon || !_player.inventory.contains(item)) {
      return;
    }
    final currentWeapon = equippedWeapon;
    final newInventory = [..._player.inventory]..remove(item);
    final newEquipped = [
      ..._player.equipped.where((e) => e.type != ItemType.weapon),
      item,
    ];
    if (currentWeapon != null) newInventory.add(currentWeapon);
    _player = _player.copyWith(inventory: newInventory, equipped: newEquipped);
    _log(
      '装备了 ${item.name}${currentWeapon != null ? '，替换掉 ${currentWeapon.name}' : ''}',
    );
    notifyListeners();
  }

  void equipArmor(Item item) {
    if (item.type != ItemType.armor || !_player.inventory.contains(item)) {
      return;
    }
    final currentArmor = equippedArmor;
    final newInventory = [..._player.inventory]..remove(item);
    final newEquipped = [
      ..._player.equipped.where((e) => e.type != ItemType.armor),
      item,
    ];
    if (currentArmor != null) newInventory.add(currentArmor);
    _player = _player.copyWith(inventory: newInventory, equipped: newEquipped);
    _log(
      '装备了 ${item.name}${currentArmor != null ? '，替换掉 ${currentArmor.name}' : ''}',
    );
    notifyListeners();
  }

  void useConsumable(Item item) {
    if (item.type != ItemType.consumable || !_player.inventory.contains(item)) {
      return;
    }
    final newStats = _player.stats.healHp(item.hpBonus);
    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(inventory: newInventory, stats: newStats);
    _log('服用了 ${item.name}，气血恢复');
    notifyListeners();
  }

  void _advanceTime(int days) {
    _tick += days;
    _clock = _clock.tickDays(days);
    final remainingLife = _player.lifespanDays - days;
    _player = _player.copyWith(lifespanDays: remainingLife);
    if (remainingLife <= 0) {
      _log('寿元耗尽，道途止于此。');
    }
  }

  void _checkBreakthrough() {
    final currentRealm = _player.realm;
    if (_player.xp < currentRealm.maxXp) return;
    final successRate = 0.72 + _player.stats.insight * 0.02;
    final success = _rng.nextDouble() < successRate;
    if (success && _player.stageIndex < RealmStage.stages.length - 1) {
      final nextStageIndex = _player.stageIndex + 1;
      final next = RealmStage.stages[nextStageIndex];
      _player = _player.copyWith(
        stageIndex: nextStageIndex,
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
      _log('突破成功，晋升 ${next.name}！');
    } else {
      _player = _player.copyWith(xp: currentRealm.maxXp ~/ 2);
      _log('突破失败，受伤退修，需要重新积累。');
    }
  }

  void _triggerNodeEvent(MapNode node) {
    final roll = _rng.nextDouble();
    if (roll < 0.55) {
      _encounterEnemy(node);
    } else if (roll < 0.8) {
      _findHerb();
    } else {
      _encounterNpc();
    }
  }

  void _encounterEnemy(MapNode node) {
    final enemy = _rollEnemy(node.danger);
    _log('遭遇 ${enemy.name}！准备战斗！');

    // Start Battle State
    _currentBattle = Battle(
      enemy: enemy,
      playerHp: _player.stats.hp,
      playerMaxHp: _player.stats.maxHp,
      playerSpirit: _player.stats.spirit,
      playerMaxSpirit: _player.stats.maxSpirit,
    );
    notifyListeners();
  }

  void progressBattle() {
    if (_currentBattle == null || _currentBattle!.isOver) return;

    final battle = _currentBattle!;
    final enemy = battle.enemy;

    // Player Turn
    // Simple logic for now: Attack
    // Calculate stats
    final playerAtkBase = (_player.stats.attack + _itemAttackBonus())
        .toDouble();
    final enemyDef = enemy.stats.defense.toDouble();
    final playerSpeed = _player.stats.speed;
    final enemySpeed = enemy.stats.speed;

    // Spirit Usage
    final hasSpirit = battle.playerSpirit >= 2;
    final isCrit =
        _rng.nextDouble() < (0.05 + (playerSpeed > enemySpeed ? 0.1 : 0.0));
    final critMultiplier = isCrit ? 1.5 : 1.0;

    double atkThisRound = hasSpirit ? playerAtkBase : playerAtkBase * 0.8;
    if (hasSpirit) {
      battle.playerSpirit -= 2;
    }

    // Variance
    atkThisRound *= (0.9 + _rng.nextDouble() * 0.2);
    final rawDmg = (atkThisRound * critMultiplier) - enemyDef;
    final dmgToEnemy = max(1, rawDmg.round());

    battle.enemyHp -= dmgToEnemy;
    battle.logs.add(
      BattleLog(
        '你对 ${enemy.name} 造成了 $dmgToEnemy 点伤害！',
        isPlayerAction: true,
        damage: dmgToEnemy,
        isCrit: isCrit,
      ),
    );

    if (battle.enemyHp <= 0) {
      battle.enemyHp = 0;
      battle.state = BattleState.victory;
      _resolveBattleVictory(battle);
      notifyListeners();
      return;
    }

    // Enemy Turn
    final enemyAtk = enemy.stats.attack.toDouble();
    final playerDef = (_player.stats.defense + _itemDefenseBonus()).toDouble();

    double enemyAtkThisRound = enemyAtk * (0.9 + _rng.nextDouble() * 0.2);
    final enemyIsCrit = _rng.nextDouble() < 0.05;
    if (enemyIsCrit) enemyAtkThisRound *= 1.5;

    final rawDmgToPlayer = enemyAtkThisRound - playerDef;
    final dmgToPlayer = max(1, rawDmgToPlayer.round());

    battle.playerHp -= dmgToPlayer;
    battle.logs.add(
      BattleLog(
        '${enemy.name} 对你造成了 $dmgToPlayer 点伤害！',
        isPlayerAction: false,
        damage: dmgToPlayer,
        isCrit: enemyIsCrit,
      ),
    );

    if (battle.playerHp <= 0) {
      battle.playerHp = 0;
      battle.state = BattleState.defeat;
      _resolveBattleDefeat(battle);
      notifyListeners();
      return;
    }

    battle.turn++;
    if (battle.turn >= 20) {
      // Limit turns
      battle.state = BattleState.fled; // Draw/Fled
      _log('战斗僵持不下，双方各自退去。');
      // Update player state anyway
      _player = _player.copyWith(
        stats: _player.stats.copyWith(
          hp: battle.playerHp,
          spirit: battle.playerSpirit,
        ),
      );
    }

    notifyListeners();
  }

  void _resolveBattleVictory(Battle battle) {
    final enemy = battle.enemy;
    _player = _player.copyWith(
      xp: _player.xp + enemy.xpReward,
      stats: _player.stats.copyWith(
        hp: battle.playerHp,
        spirit: battle.playerSpirit,
      ),
    );
    _log('击败 ${enemy.name}，获得 ${enemy.xpReward} 修为');

    // Loot
    if (enemy.loot.isNotEmpty && _rng.nextDouble() < 0.3) {
      final lootId = enemy.loot[_rng.nextInt(enemy.loot.length)];
      final added = _addItemById(lootId);
      final item = ItemsRepository.get(lootId);
      if (added && item != null) {
        _log('拾取战利品：${item.name}');
      }
    }
    _checkBreakthrough();
  }

  void _resolveBattleDefeat(Battle battle) {
    final enemy = battle.enemy;
    _player = _player.copyWith(
      stats: _player.stats.copyWith(hp: 0, spirit: battle.playerSpirit),
    );
    _log('被 ${enemy.name} 击败，身受重伤！');
  }

  void closeBattle() {
    _currentBattle = null;
    notifyListeners();
  }

  void _findHerb() {
    final added = _addItemById('herb');
    if (added) {
      _log('在林间采到了一株疗伤草。');
    }
  }

  void _encounterNpc() {
    _log('路过一名闭目修士，对方并未理你。');
  }

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

  List<MapNode> _seedMap() {
    return MapsRepository.getAll();
  }

  Enemy _rollEnemy(int danger) {
    return EnemiesRepository.rollEnemy(danger);
  }

  void _log(String message) {
    final stamped = '[${_clock.shortLabel()}] $message';
    final newLogs = [..._logs, LogEntry(stamped, tick: _tick)];
    // 只保留最近 80 条
    _logs = newLogs.length > 80
        ? newLogs.sublist(newLogs.length - 80)
        : newLogs;
  }

  void resetGame() {
    _tick = 0;
    _clock = const WorldClock(year: 1001, month: 1, day: 1);
    _player = Player(
      name: '无名散修',
      stageIndex: 0,
      xp: 0,
      lifespanDays: 80 * 365,
      stats: const Stats(
        maxHp: 80,
        hp: 80,
        maxSpirit: 50,
        spirit: 50,
        attack: 12,
        defense: 6,
        speed: 8,
        insight: 4,
      ),
      inventory: const [],
      equipped: const [],
    );
    _logs = [];
    _mapNodes = _seedMap();
    _currentNode = _mapNodes.first;
    // Reset Grid State
    _playerGridPos = const Point(0, 0);
    _visitedTiles = {_playerGridPos};

    _log('重开一局，新的人生开始。');
    notifyListeners();
  }
}
