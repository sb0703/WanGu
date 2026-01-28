import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/battle_result.dart';
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
      _clock = const WorldClock(year: 1001, month: 1, day: 1, hour: 8),
      _player = Player(
        name: '无名散修',
        stageIndex: 0,
        xp: 0,
        lifespanHours: 80 * 365 * 24, // 80年寿元
        stats: const Stats(
          maxHp: 80,
          hp: 80,
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

  final Random _rng;
  int _tick;
  WorldClock _clock;
  Player _player;
  late final List<MapNode> _mapNodes;
  late MapNode _currentNode;
  List<LogEntry> _logs;

  // Public getters
  int get tick => _tick;
  WorldClock get clock => _clock;
  Player get player => _player;
  MapNode get currentNode => _currentNode;
  List<MapNode> get mapNodes => List.unmodifiable(_mapNodes);
  List<LogEntry> get logs => List.unmodifiable(_logs);

  bool get isDead => _player.lifespanHours <= 0 || _player.stats.hp <= 0;

  void cultivate({int hours = 1}) {
    if (isDead) return;
    final gainedXp = 6 + _player.stats.insight;
    _player = _player.copyWith(xp: _player.xp + gainedXp);
    _advanceTime(hours);
    _log('静坐修炼，获得 $gainedXp 修为');
    _checkBreakthrough();
    notifyListeners();
  }

  void moveTo(MapNode node) {
    if (isDead) return;
    _currentNode = node;
    _advanceTime(2);
    _log('移动到【${node.name}】');
    _triggerNodeEvent(node);
    notifyListeners();
  }

  void rest({int hours = 2}) {
    if (isDead) return;
    final newHp = (_player.stats.hp + 10 * hours).clamp(0, _player.stats.maxHp);
    _player = _player.copyWith(stats: _player.stats.copyWith(hp: newHp));
    _advanceTime(hours);
    _log('调息休整，恢复体力');
    notifyListeners();
  }

  // --- Internal helpers ---
  void _advanceTime(int hours) {
    _tick += hours;
    _clock = _clock.tickHours(hours);
    final remainingLife = _player.lifespanHours - hours;
    _player = _player.copyWith(lifespanHours: remainingLife);
    if (remainingLife <= 0) {
      _log('寿元耗尽，道消身死。');
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
          spirit: _player.stats.spirit + next.spiritBonus,
        ),
      );
      _log('突破成功，迈入【${next.name}】！');
    } else {
      _player = _player.copyWith(xp: currentRealm.maxXp ~/ 2);
      _log('突破失败，修为受损，需要静养。');
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
    _log('遭遇【${enemy.name}】！');
    final result = _simulateBattle(enemy);
    if (result.victory) {
      _player = _player.copyWith(
        xp: _player.xp + result.xpGained,
        stats: _player.stats.copyWith(hp: result.playerHp),
      );
      _log('击败 ${enemy.name}，获得 ${result.xpGained} 修为');
      if (result.lootedItemName != null) {
        _log('拾取：${result.lootedItemName}');
      }
      _checkBreakthrough();
    } else {
      _player = _player.copyWith(
        stats: _player.stats.copyWith(hp: result.playerHp),
      );
      _log('战败！${enemy.name} 让你重伤，先回去休养。');
    }
  }

  void _findHerb() {
    const herb = Item(
      id: 'herb_common',
      name: '普通灵草',
      description: '可直接服用，恢复少量气血。',
      type: ItemType.consumable,
      hpBonus: 20,
    );
    final newInventory = [..._player.inventory, herb];
    _player = _player.copyWith(inventory: newInventory);
    _log('在灌木丛中找到了一株灵草。');
  }

  void useConsumable(Item item) {
    if (item.type != ItemType.consumable || !_player.inventory.contains(item)) {
      return;
    }
    final newHp = (_player.stats.hp + item.hpBonus).clamp(
      0,
      _player.stats.maxHp,
    );
    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(
      inventory: newInventory,
      stats: _player.stats.copyWith(hp: newHp),
    );
    _log('服用了 ${item.name}，气血恢复。');
    notifyListeners();
  }

  void _encounterNpc() {
    _log('路过一名闭关的修士，对方没有理你。');
  }

  BattleResult _simulateBattle(Enemy enemy) {
    int playerHp = _player.stats.hp;
    int enemyHp = enemy.stats.hp;
    final playerAtk = (_player.stats.attack + _itemAttackBonus()) * 1.0;
    final enemyAtk = enemy.stats.attack.toDouble();
    final playerDef = _player.stats.defense.toDouble();
    final enemyDef = enemy.stats.defense.toDouble();

    // 5 回合简化
    for (int round = 0; round < 5; round++) {
      final dmgToEnemy = max(1, (playerAtk - enemyDef).round());
      enemyHp -= dmgToEnemy;
      if (enemyHp <= 0) {
        final loot = enemy.loot.isNotEmpty
            ? enemy.loot[_rng.nextInt(enemy.loot.length)]
            : null;
        final lootedName = loot;
        return BattleResult(
          victory: true,
          playerHp: max(1, playerHp),
          enemyHp: 0,
          xpGained: enemy.xpReward,
          lootedItemName: lootedName,
        );
      }
      final dmgToPlayer = max(1, (enemyAtk - playerDef).round());
      playerHp -= dmgToPlayer;
      if (playerHp <= 0) {
        return BattleResult(
          victory: false,
          playerHp: 0,
          enemyHp: enemyHp,
          xpGained: 0,
        );
      }
    }
    // 超过5回合视为僵持，小退
    return BattleResult(
      victory: false,
      playerHp: playerHp,
      enemyHp: enemyHp,
      xpGained: 0,
    );
  }

  double _itemAttackBonus() {
    return _player.equipped.fold<double>(
      0,
      (sum, item) => sum + item.attackBonus,
    );
  }

  Enemy _rollEnemy(int danger) {
    if (danger >= 6) {
      return Enemy(
        name: '狂暴妖狼',
        stats: const Stats(
          maxHp: 70,
          hp: 70,
          spirit: 30,
          attack: 16,
          defense: 6,
          speed: 10,
          insight: 0,
        ),
        loot: const ['兽骨'],
        xpReward: 20,
      );
    }
    return Enemy(
      name: '山野野猪',
      stats: const Stats(
        maxHp: 40,
        hp: 40,
        spirit: 0,
        attack: 10,
        defense: 4,
        speed: 6,
        insight: 0,
      ),
      loot: const ['獠牙'],
      xpReward: 12,
    );
  }

  List<MapNode> _seedMap() {
    return const [
      MapNode(id: 'sect', name: '宗门山门', description: '安全区，可休整与学习', danger: 1),
      MapNode(id: 'forest', name: '后山密林', description: '常见野兽出没', danger: 3),
      MapNode(id: 'swamp', name: '迷雾泽地', description: '湿气浓重，妖兽较多', danger: 6),
      MapNode(id: 'ruin', name: '废弃古庙', description: '传闻藏有奇遇，也潜伏危险', danger: 7),
    ];
  }

  void _log(String message) {
    final newLogs = [..._logs, LogEntry(message, tick: _tick)];
    // 只保留最近 80 条
    _logs = newLogs.length > 80
        ? newLogs.sublist(newLogs.length - 80)
        : newLogs;
  }
}
