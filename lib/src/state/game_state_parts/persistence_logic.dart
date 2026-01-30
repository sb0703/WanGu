part of '../game_state.dart';

extension PersistenceLogic on GameState {
  Future<SharedPreferences?> _prefs() async {
    try {
      return await SharedPreferences.getInstance();
    } on MissingPluginException {
      return null; // Plugin not available (e.g., unit tests)
    }
  }

  Future<void> saveToDisk() async {
    final prefs = await _prefs();
    if (prefs == null) return;
    await prefs.setString(GameState._saveKey, jsonEncode(_toJson()));
  }

  Future<bool> hasSave() async {
    final prefs = await _prefs();
    if (prefs == null) return false;
    return prefs.containsKey(GameState._saveKey);
  }

  Future<bool> clearSave() async {
    final prefs = await _prefs();
    if (prefs == null) return false;
    if (!prefs.containsKey(GameState._saveKey)) return false;
    return prefs.remove(GameState._saveKey);
  }

  Future<bool> loadFromDisk() async {
    final prefs = await _prefs();
    if (prefs == null) return false;
    final raw = prefs.getString(GameState._saveKey);
    if (raw == null) return false;

    try {
      final Map<String, dynamic> data = jsonDecode(raw);
      _restoreFromJson(data);
      _log('加载存档');
      notify();
      return true;
    } catch (_) {
      return false;
    }
  }

  Map<String, dynamic> _toJson() {
    return {
      'tick': _tick,
      'clock': {
        'year': _clock.year,
        'month': _clock.month,
        'day': _clock.day,
        'hour': _clock.hour,
      },
      'player': _playerToJson(_player),
      'currentNodeId': _currentNode.id,
      'playerGridPos': {'x': _playerGridPos.x, 'y': _playerGridPos.y},
      'visited': _visitedTiles.map((p) => [p.x, p.y]).toList(),
      'logs': _logs.map((l) => {'message': l.message, 'tick': l.tick}).toList(),
    };
  }

  Map<String, dynamic> _playerToJson(Player player) {
    return {
      'name': player.name,
      'gender': player.gender,
      'stageIndex': player.stageIndex,
      'level': player.level,
      'xp': player.xp,
      'lifespanDays': player.lifespanDays,
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
      'inventory': player.inventory.map((i) => i.id).toList(),
      'equipped': player.equipped.map((i) => i.id).toList(),
      'buffIds': player.buffIds,
    };
  }

  void _restoreFromJson(Map<String, dynamic> data) {
    _tick = data['tick'] is int ? data['tick'] as int : 0;

    final clockMap = data['clock'];
    if (clockMap is Map) {
      _clock = WorldClock(
        year: (clockMap['year'] as int?) ?? 1,
        month: (clockMap['month'] as int?) ?? 1,
        day: (clockMap['day'] as int?) ?? 1,
        hour: (clockMap['hour'] as int?) ?? 0,
      );
    }

    final playerMap = data['player'];
    if (playerMap is Map<String, dynamic>) {
      _player = _playerFromMap(playerMap);
    }

    _mapNodes = _seedMap();
    final nodeId = data['currentNodeId'];
    if (nodeId is String) {
      _currentNode = _mapNodes.firstWhere(
        (n) => n.id == nodeId,
        orElse: () => _mapNodes.first,
      );
    }

    final pos = data['playerGridPos'];
    if (pos is Map) {
      final x = pos['x'] is int ? pos['x'] as int : 0;
      final y = pos['y'] is int ? pos['y'] as int : 0;
      _playerGridPos = Point<int>(x, y);
    } else {
      _playerGridPos = const Point(0, 0);
    }

    final visited = data['visited'];
    if (visited is List) {
      _visitedTiles = visited
          .map(
            (e) => e is List && e.length == 2
                ? Point<int>((e[0] as num).toInt(), (e[1] as num).toInt())
                : null,
          )
          .whereType<Point<int>>()
          .toSet();
    } else {
      _visitedTiles = {_playerGridPos};
    }

    final logList = data['logs'];
    if (logList is List) {
      _logs = logList
          .map(
            (e) => e is Map
                ? LogEntry(
                    e['message']?.toString() ?? '',
                    tick: (e['tick'] as num?)?.toInt() ?? 0,
                  )
                : null,
          )
          .whereType<LogEntry>()
          .toList();
      if (_logs.length > 80) {
        _logs = _logs.sublist(_logs.length - 80);
      }
    }

    _visitedTiles.add(_playerGridPos);
    _currentBattle = null;
    _currentInteractionNpc = null;
    _showingBreakthrough = false;
    _breakthroughSuccess = false;
    _breakthroughMessage = '';
  }

  Player _playerFromMap(Map<String, dynamic> data) {
    final statsMap = data['stats'] as Map<String, dynamic>? ?? {};
    final stats = Stats(
      maxHp: (statsMap['maxHp'] as num?)?.toInt() ?? 80,
      hp: (statsMap['hp'] as num?)?.toInt() ?? 80,
      maxSpirit: (statsMap['maxSpirit'] as num?)?.toInt() ?? 50,
      spirit: (statsMap['spirit'] as num?)?.toInt() ?? 50,
      attack: (statsMap['attack'] as num?)?.toInt() ?? 10,
      defense: (statsMap['defense'] as num?)?.toInt() ?? 5,
      speed: (statsMap['speed'] as num?)?.toInt() ?? 8,
      insight: (statsMap['insight'] as num?)?.toInt() ?? 4,
      purity: (statsMap['purity'] as num?)?.toInt() ?? 100,
    );

    final inventoryIds =
        (data['inventory'] as List?)?.map((e) => e.toString()).toList() ?? [];
    final equippedIds =
        (data['equipped'] as List?)?.map((e) => e.toString()).toList() ?? [];

    // Handle backward compatibility: check for afflictions if buffIds missing
    List<String> buffs = [];
    if (data.containsKey('buffIds')) {
      buffs =
          (data['buffIds'] as List?)?.map((e) => e.toString()).toList() ?? [];
    } else if (data.containsKey('afflictions')) {
      buffs =
          (data['afflictions'] as List?)?.map((e) => e.toString()).toList() ??
          [];
    }

    return Player(
      name: data['name']?.toString() ?? '无名散修',
      gender: data['gender']?.toString() ?? '男',
      stageIndex: (data['stageIndex'] as num?)?.toInt() ?? 0,
      level: (data['level'] as num?)?.toInt() ?? 1,
      stats: stats,
      xp: (data['xp'] as num?)?.toInt() ?? 0,
      lifespanDays: (data['lifespanDays'] as num?)?.toInt() ?? 80 * 365,
      inventory: inventoryIds
          .map((id) => ItemsRepository.get(id))
          .whereType<Item>()
          .toList(),
      equipped: equippedIds
          .map((id) => ItemsRepository.get(id))
          .whereType<Item>()
          .toList(),
      buffIds: buffs,
    );
  }
}
