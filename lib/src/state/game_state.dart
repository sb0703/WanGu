import 'dart:math';

import 'package:flutter/foundation.dart';

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
          purity: 100,
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

  // NPC Interaction State
  Npc? _currentInteractionNpc;
  Npc? get currentInteractionNpc => _currentInteractionNpc;

  // Breakthrough State
  bool _showingBreakthrough = false;
  bool _breakthroughSuccess = false;
  String _breakthroughMessage = '';

  bool get showingBreakthrough => _showingBreakthrough;
  bool get breakthroughSuccess => _breakthroughSuccess;
  String get breakthroughMessage => _breakthroughMessage;

  // Getters for exploration
  Point<int> get playerGridPos => _playerGridPos;
  Set<Point<int>> get visitedTiles => _visitedTiles;

  double get estimatedBreakthroughChance {
    final isMajorBreakthrough = _player.level >= 10;
    double rate;

    if (isMajorBreakthrough) {
      // Major Breakthrough Base
      rate = 0.6 * (0.72 + _player.stats.insight * 0.02);

      // Check pills (Logic duplicated for display, ideally refactor to helper)
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
      rate = 0.9 + _player.stats.insight * 0.01;
    }

    // Apply Purity Factor to EVERYTHING
    final purityFactor = _player.stats.purity / 100.0;
    rate *= purityFactor;

    return rate.clamp(0.01, 0.95);
  }

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

  List<Npc> get currentNpcs {
    return _currentNode.npcIds
        .map((id) => NpcsRepository.get(id))
        .whereType<Npc>()
        .toList();
  }

  bool get isDead => _player.lifespanDays <= 0 || _player.stats.hp <= 0;
  bool get isGameOver => isDead;

  Item? _firstEquipped(ItemType type) {
    for (final item in _player.equipped) {
      if (item.type == type) return item;
    }
    return null;
  }

  // Cultivate: Absorb Qi (Increases XP, Decreases Purity)
  void cultivate({int days = 1}) {
    if (isDead) return;

    // Check if player reached max XP for current realm level
    final maxXp = _player.currentMaxXp;
    if (_player.xp >= maxXp) {
      _advanceTime(days);
      _log('修为已至瓶颈，无法寸进，需闭关突破。');
      notifyListeners();
      return;
    }

    // Base XP gain
    int baseGain = 6 + _player.stats.insight;

    // Decrease XP gain based on stage index (Diminishing returns)
    double efficiency = (1.0 - (_player.stageIndex * 0.2)).clamp(0.1, 1.0);

    int gainedXp = (baseGain * efficiency * days).toInt(); // Scaled by days
    if (gainedXp < 1) gainedXp = 1;

    // Purity Penalty: -1 per day (Base)
    // Higher insight might reduce impurity intake slightly? No, let's keep it simple.
    int purityLoss = 1 * days;

    // Cap XP at max
    int newXp = _player.xp + gainedXp;
    if (newXp > maxXp) {
      newXp = maxXp;
    }

    // Apply stats changes
    _player = _player.copyWith(
      xp: newXp,
      stats: _player.stats.copyWith(
        purity: (_player.stats.purity - purityLoss).clamp(0, 100),
      ),
    );

    _advanceTime(days);
    _log('纳气修炼 $days 天，修为+$gainedXp，纯度-$purityLoss');
    notifyListeners();
  }

  // Purify: Remove Impurity (No XP, Increases Purity)
  void purify({int days = 1}) {
    if (isDead) return;

    if (_player.stats.purity >= 100) {
      _advanceTime(days);
      _log('灵气已纯净无暇，无需提纯。');
      notifyListeners();
      return;
    }

    // Base Purity Gain
    // Insight helps purify faster
    int baseRecovery = 2 + (_player.stats.insight ~/ 5);
    int totalRecovery = baseRecovery * days;

    _player = _player.copyWith(
      stats: _player.stats.copyWith(
        purity: (_player.stats.purity + totalRecovery).clamp(0, 100),
      ),
    );

    _advanceTime(days);
    _log('运功化煞 $days 天，纯度+$totalRecovery');
    notifyListeners();
  }

  /// Manually trigger breakthrough attempt
  void attemptBreakthrough() {
    _checkBreakthrough();
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
    final maxXp = _player.currentMaxXp;
    if (_player.xp < maxXp) return;

    // Use the unified calculation logic
    final successRate = estimatedBreakthroughChance;
    final success = _rng.nextDouble() < successRate;

    _showingBreakthrough = true;
    _breakthroughSuccess = success;

    final isMajorBreakthrough = _player.level >= 10;

    if (success) {
      if (isMajorBreakthrough) {
        // Major Breakthrough: Next Stage, Level 1
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
        // Minor Breakthrough: Same Stage, Next Level
        final newLevel = _player.level + 1;
        // Minor stats boost
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
    notifyListeners();
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

    // Handle Teleportation
    if (result.teleportToDanger) {
      // Find most dangerous node
      if (_mapNodes.isNotEmpty) {
        final dangerousNode = _mapNodes.reduce(
          (curr, next) => curr.danger > next.danger ? curr : next,
        );
        if (dangerousNode != _currentNode) {
          // We use enterRegion but suppress log or add specific log
          _currentNode = dangerousNode; // Teleport directly
          _playerGridPos = const Point(0, 0);
          _visitedTiles = {_playerGridPos};
          _log('空间裂缝撕裂，你被强制传送到了 ${dangerousNode.name}！');
        }
      }
    }

    // Handle Nemesis Spawn
    if (result.spawnNemesis) {
      // Trigger enemy encounter immediately
      _encounterEnemy(_currentNode);
    }

    if (result.daysPassed > 0) {
      _advanceTime(result.daysPassed);
    }
  }

  void closeBreakthrough() {
    _showingBreakthrough = false;
    notifyListeners();
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

  // NPC Interactions
  void startNpcInteraction(String npcId) {
    final npc = NpcsRepository.get(npcId);
    if (npc != null) {
      _currentInteractionNpc = npc;
      notifyListeners();
    }
  }

  void endNpcInteraction() {
    _currentInteractionNpc = null;
    notifyListeners();
  }

  void attackNpc(Npc npc) {
    _currentInteractionNpc = null; // Close dialog

    // Convert NPC to Enemy for battle
    final enemy = Enemy(
      name: npc.name,
      stats: npc.stats,
      loot: [], // Or specific loot
      xpReward: npc.stats.attack * 2, // Simple logic
    );

    _log('你突然对 ${npc.name} 发起了攻击！');

    _currentBattle = Battle(
      enemy: enemy,
      playerHp: _player.stats.hp,
      playerMaxHp: _player.stats.maxHp,
      playerSpirit: _player.stats.spirit,
      playerMaxSpirit: _player.stats.maxSpirit,
    );
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
    _clock = const WorldClock(year: 1, month: 1, day: 1);
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
    _mapNodes = MapsRepository.getAll();
    _currentNode = _mapNodes.first;
    _logs = [LogEntry('大道争锋，我辈修士当逆天而行。', tick: 0)];
    _playerGridPos = const Point(0, 0);
    _visitedTiles = {_playerGridPos};
    _currentBattle = null;
    _currentInteractionNpc = null;
    _showingBreakthrough = false;
    _breakthroughSuccess = false;
    notifyListeners();
  }
}
