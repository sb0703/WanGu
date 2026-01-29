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

  final Map<String, Item> _catalog = {
    'herb': const Item(
      id: 'herb',
      name: '疗伤草',
      description: '服用可恢复气血。',
      type: ItemType.consumable,
      hpBonus: 25,
    ),
    'rusty_sword': const Item(
      id: 'rusty_sword',
      name: '生锈铁剑',
      description: '旧铁剑，聊胜于无。',
      type: ItemType.weapon,
      attackBonus: 5,
    ),
    'cloth_robe': const Item(
      id: 'cloth_robe',
      name: '粗布护衣',
      description: '最简单的护身布衣，略有防护。',
      type: ItemType.armor,
      defenseBonus: 3,
    ),
  };

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

  bool get isDead => _player.lifespanHours <= 0 || _player.stats.hp <= 0;
  bool get isGameOver => isDead;

  Item? _firstEquipped(ItemType type) {
    for (final item in _player.equipped) {
      if (item.type == type) return item;
    }
    return null;
  }

  void cultivate({int hours = 1}) {
    if (isDead) return;
    final gainedXp = 6 + _player.stats.insight;
    _player = _player.copyWith(xp: _player.xp + gainedXp);
    _advanceTime(hours);
    _log('闭关修炼，获得 $gainedXp 修为');
    _checkBreakthrough();
    notifyListeners();
  }

  void moveTo(MapNode node) {
    if (isDead) return;
    _currentNode = node;
    _advanceTime(2);
    _log('移动到 ${node.name}');
    _triggerNodeEvent(node);
    notifyListeners();
  }

  void rest({int hours = 2}) {
    if (isDead) return;
    final newHp = (_player.stats.hp + 10 * hours).clamp(0, _player.stats.maxHp);
    final newSpirit = (_player.stats.spirit + 8 * hours).clamp(0, _player.stats.maxSpirit);
    _player = _player.copyWith(
      stats: _player.stats.copyWith(hp: newHp, spirit: newSpirit),
    );
    _advanceTime(hours);
    _log('调息恢复，气血/灵力回复');
    notifyListeners();
  }

  bool _addItemById(String id) {
    final item = _catalog[id];
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
    if (!_player.inventory.contains(item)) return;
    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(inventory: newInventory);
    _log('丢弃了 ${item.name}');
    notifyListeners();
  }

  void equipWeapon(Item item) {
    if (item.type != ItemType.weapon || !_player.inventory.contains(item)) return;
    final currentWeapon = equippedWeapon;
    final newInventory = [..._player.inventory]..remove(item);
    final newEquipped = [
      ..._player.equipped.where((e) => e.type != ItemType.weapon),
      item,
    ];
    if (currentWeapon != null) newInventory.add(currentWeapon);
    _player = _player.copyWith(inventory: newInventory, equipped: newEquipped);
    _log('装备了 ${item.name}${currentWeapon != null ? '，替换掉 ${currentWeapon.name}' : ''}');
    notifyListeners();
  }

  void equipArmor(Item item) {
    if (item.type != ItemType.armor || !_player.inventory.contains(item)) return;
    final currentArmor = equippedArmor;
    final newInventory = [..._player.inventory]..remove(item);
    final newEquipped = [
      ..._player.equipped.where((e) => e.type != ItemType.armor),
      item,
    ];
    if (currentArmor != null) newInventory.add(currentArmor);
    _player = _player.copyWith(inventory: newInventory, equipped: newEquipped);
    _log('装备了 ${item.name}${currentArmor != null ? '，替换掉 ${currentArmor.name}' : ''}');
    notifyListeners();
  }

  void useConsumable(Item item) {
    if (item.type != ItemType.consumable || !_player.inventory.contains(item)) return;
    final newStats = _player.stats.healHp(item.hpBonus);
    final newInventory = [..._player.inventory]..remove(item);
    _player = _player.copyWith(inventory: newInventory, stats: newStats);
    _log('服用了 ${item.name}，气血恢复');
    notifyListeners();
  }

  void _advanceTime(int hours) {
    _tick += hours;
    _clock = _clock.tickHours(hours);
    final remainingLife = _player.lifespanHours - hours;
    _player = _player.copyWith(lifespanHours: remainingLife);
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
    _log('遭遇 ${enemy.name}！');
    final result = _simulateBattle(enemy);
    if (result.victory) {
      _player = _player.copyWith(
        xp: _player.xp + result.xpGained,
        stats: _player.stats.copyWith(
          hp: result.playerHp,
          spirit: result.playerSpirit,
        ),
      );
      _log('击败 ${enemy.name}，获得 ${result.xpGained} 修为');
      if (result.lootedItemId != null) {
        final added = _addItemById(result.lootedItemId!);
        final name = _catalog[result.lootedItemId!]!.name;
        if (added) {
          _log('拾取：$name');
        }
      }
      _checkBreakthrough();
    } else {
      _player = _player.copyWith(
        stats: _player.stats.copyWith(
          hp: result.playerHp,
          spirit: result.playerSpirit,
        ),
      );
      _log('战败，${enemy.name}令你重伤，先回去休整。');
    }
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

  BattleResult _simulateBattle(Enemy enemy) {
    int playerHp = _player.stats.hp;
    int enemyHp = enemy.stats.hp;
    double playerSpirit = _player.stats.spirit.toDouble();
    final playerAtkBase = (_player.stats.attack + _itemAttackBonus()).toDouble();
    final enemyAtk = enemy.stats.attack.toDouble();
    final playerDef = (_player.stats.defense + _itemDefenseBonus()).toDouble();
    final enemyDef = enemy.stats.defense.toDouble();

    String? lootId;

    for (int round = 0; round < 5; round++) {
      final hasSpirit = playerSpirit >= 5;
      final atkThisRound = hasSpirit ? playerAtkBase : playerAtkBase * 0.6;
      if (hasSpirit) {
        playerSpirit -= 5;
      } else {
        _log('Spirit low, attack weakened.');
      }
      final dmgToEnemy = max(1, (atkThisRound - enemyDef).round());
      enemyHp -= dmgToEnemy;
      if (enemyHp <= 0) {
        lootId = enemy.loot.isNotEmpty
            ? enemy.loot[_rng.nextInt(enemy.loot.length)]
            : null;
        return BattleResult(
          victory: true,
          playerHp: max(1, playerHp),
          enemyHp: 0,
          xpGained: enemy.xpReward,
          playerSpirit: playerSpirit.round(),
          lootedItemId: lootId,
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
          playerSpirit: playerSpirit.round(),
        );
      }
    }

    return BattleResult(
      victory: false,
      playerHp: playerHp,
      enemyHp: enemyHp,
      xpGained: 0,
      playerSpirit: playerSpirit.round(),
    );
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

  Enemy _rollEnemy(int danger) {
    if (danger >= 6) {
      return Enemy(
        name: '血牙狼王',
        stats: const Stats(
          maxHp: 70,
          hp: 70,
          maxSpirit: 30,
          spirit: 30,
          attack: 16,
          defense: 6,
          speed: 10,
          insight: 0,
        ),
        loot: const ['rusty_sword', 'herb'],
        xpReward: 20,
      );
    }
    return Enemy(
      name: '野猪',
      stats: const Stats(
        maxHp: 40,
        hp: 40,
        maxSpirit: 0,
        spirit: 0,
        attack: 10,
        defense: 4,
        speed: 6,
        insight: 0,
      ),
      loot: const ['herb', 'cloth_robe'],
      xpReward: 12,
    );
  }

  List<MapNode> _seedMap() {
    return const [
      MapNode(
        id: 'sect',
        name: '宗门后山',
        description: '安全区，可打坐与学习',
        danger: 1,
      ),
      MapNode(
        id: 'forest',
        name: '后山竹林',
        description: '常见野兽出没',
        danger: 3,
      ),
      MapNode(
        id: 'swamp',
        name: '迷雾沼泽',
        description: '瘴气重，危险较大',
        danger: 6,
      ),
      MapNode(
        id: 'ruin',
        name: '破败遗迹',
        description: '听说有机缘，也有埋伏',
        danger: 7,
      ),
    ];
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
    _clock = const WorldClock(year: 1001, month: 1, day: 1, hour: 8);
    _player = Player(
      name: '无名散修',
      stageIndex: 0,
      xp: 0,
      lifespanHours: 80 * 365 * 24,
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
    _log('重开一局，新的人生开始。');
    notifyListeners();
  }
}
