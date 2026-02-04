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

    // Try cloud sync if possible (non-blocking)
    saveToServer();
  }

  Future<void> saveToServer() async {
    final payload = _toJson();
    try {
      if (_remoteSaveId != null) {
        await _apiService.updateSave(_remoteSaveId!, _player.name, payload);
        _log('云端存档已同步');
      } else if (_userId != null) {
        // If we have a logged-in user but no remoteSaveId yet, create a new save.
        final result = await _apiService.createSave(
          _player.name,
          payload,
          userId: _userId,
        );
        if (result.containsKey('id')) {
          _remoteSaveId = result['id'].toString();
          _log('云端存档已创建');
          // Save again to disk to persist the new _remoteSaveId
          saveToDisk();
        }
      }
      // If no userId, we can't save to cloud (or handle anonymous saves if supported)
    } catch (e) {
      debugPrint('Cloud save failed: $e');
    }
  }

  Future<bool> loadFromServer(String id) async {
    try {
      final data = await _apiService.getSave(id);
      final payload = data['payload'];
      if (payload != null) {
        _restoreFromJson(payload);
        _remoteSaveId = id;
        _log('云端存档读取成功');
        notify();
        saveToDisk(); // Sync to local
        return true;
      }
    } catch (e) {
      _log('云端读取失败: $e');
    }
    return false;
  }

  Future<List<dynamic>> fetchCloudSaves() async {
    try {
      return await _apiService.listSaves(userId: _userId);
    } catch (e) {
      debugPrint('Fetch cloud saves failed: $e');
      return [];
    }
  }

  Future<bool> hasSave() async {
    final prefs = await _prefs();
    if (prefs == null) return false;
    return prefs.containsKey(GameState._saveKey);
  }

  Future<bool> clearSave() async {
    final prefs = await _prefs();
    if (prefs == null) return false;

    // 1. Clear cloud save if exists
    if (_remoteSaveId != null) {
      try {
        await _apiService.deleteSave(_remoteSaveId!);
        _log('云端存档已清除');
      } catch (e) {
        debugPrint('Clear cloud save failed: $e');
      }
      _remoteSaveId = null;
    }

    // 2. Delete character if userId exists (assuming we can track character ID)
    // Currently _remoteSaveId is for PlayerSave, but characters are separate entities in backend.
    // If we want to delete the character too, we need its ID.
    // However, we don't store character ID explicitly in GameState yet, only _remoteSaveId.
    // Assuming backend might handle cascading delete or we need to find character ID.
    // For now, let's try to delete character if we can infer it or if we stored it.
    // Since we don't have characterId stored, we might need to list characters or rely on save deletion.
    // But user specifically asked to delete character.
    // Let's assume we can find it via listing or maybe we should have stored it.
    // Given the previous task context, we removed assigning character ID to remoteSaveId.
    // Let's fetch characters and delete the one matching current name? Or delete all for user?
    // Safer approach: Delete all characters for this user if we are resetting "the" character?
    // Or better: Just list characters and delete them.
    if (_userId != null) {
      try {
        final chars = await _apiService.listCharacters(userId: _userId);
        for (final char in chars) {
          if (char is Map && char['name'] == _player.name) {
            final charId = char['id']?.toString();
            if (charId != null) {
              await _apiService.deleteCharacter(charId);
              _log('角色 ${char['name']} 已删除');
            }
          }
        }
      } catch (e) {
        debugPrint('Clear character failed: $e');
      }
    }

    // 3. Clear local save
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
      'activeMissions': _activeMissions.map((m) => m.toJson()).toList(),
      'completedMissionIds': _completedMissionIds.toList(),
      'logs': _logs.map((l) => {'message': l.message, 'tick': l.tick}).toList(),
      'remoteSaveId': _remoteSaveId,
      'npcStates': _npcStates.map((k, v) => MapEntry(k, _npcToJson(v))),
    };
  }

  Map<String, dynamic> _playerToJson(Player player) {
    return {
      'name': player.name,
      'gender': player.gender,
      'stageIndex': player.stageIndex,
      'level': player.level,
      'xp': player.xp,
      'contribution': player.contribution,
      'lifespanDays': player.lifespanDays,
      'traits': player.traits,
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
      'inventory': player.inventory
          .map((i) => {'id': i.id, 'count': i.count})
          .toList(),
      'equipped': player.equipped
          .map((i) => {'id': i.id, 'count': i.count})
          .toList(),
      'buffIds': player.buffIds,
    };
  }

  Map<String, dynamic> _npcToJson(Npc npc) {
    return {
      'id': npc.id,
      'name': npc.name,
      'title': npc.title,
      'description': npc.description,
      'friendship': npc.friendship,
      'inventory': npc.inventory,
      'isMobile': npc.isMobile,
      'displayRealm': npc.displayRealm,
      'stats': {
        'maxHp': npc.stats.maxHp,
        'hp': npc.stats.hp,
        'maxSpirit': npc.stats.maxSpirit,
        'spirit': npc.stats.spirit,
        'attack': npc.stats.attack,
        'defense': npc.stats.defense,
        'speed': npc.stats.speed,
        'insight': npc.stats.insight,
        'purity': npc.stats.purity,
      },
      'dialogues': npc.dialogues,
      'tags': npc.tags,
    };
  }

  Npc _npcFromJson(Map<String, dynamic> json) {
    final statsMap = json['stats'] ?? {};
    return Npc(
      id: json['id'],
      name: json['name'],
      title: json['title'] ?? '',
      description: json['description'],
      friendship: json['friendship'] ?? 50,
      inventory: List<String>.from(json['inventory'] ?? []),
      isMobile: json['isMobile'] ?? false,
      displayRealm: json['displayRealm'] ?? '凡人',
      dialogues: List<String>.from(json['dialogues'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      stats: Stats(
        maxHp: statsMap['maxHp'] ?? 100,
        hp: statsMap['hp'] ?? 100,
        maxSpirit: statsMap['maxSpirit'] ?? 0,
        spirit: statsMap['spirit'] ?? 0,
        attack: statsMap['attack'] ?? 10,
        defense: statsMap['defense'] ?? 5,
        speed: statsMap['speed'] ?? 10,
        insight: statsMap['insight'] ?? 10,
        purity: statsMap['purity'] ?? 100,
      ),
    );
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

    final activeMissionsList = data['activeMissions'];
    if (activeMissionsList is List) {
      _activeMissions = activeMissionsList
          .map(
            (e) => e is Map<String, dynamic> ? ActiveMission.fromJson(e) : null,
          )
          .whereType<ActiveMission>()
          .toList();
    } else {
      _activeMissions = [];
    }

    final completedList = data['completedMissionIds'];
    if (completedList is List) {
      _completedMissionIds = completedList.map((e) => e.toString()).toSet();
    } else {
      _completedMissionIds = {};
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

    final npcLocMap = data['npcLocations'];
    if (npcLocMap is Map) {
      _npcLocations = Map<String, String>.from(npcLocMap);
    } else {
      _initNpcLocations();
    }

    final npcStatesMap = data['npcStates'];
    if (npcStatesMap is Map) {
      _npcStates = npcStatesMap.map(
        (k, v) => MapEntry(k.toString(), _npcFromJson(v)),
      );
    } else {
      _npcStates = {};
    }

    _visitedTiles.add(_playerGridPos);
    _currentBattle = null;
    _currentInteractionNpc = null;
    _showingBreakthrough = false;
    _breakthroughSuccess = false;
    _breakthroughMessage = '';
    _remoteSaveId = data['remoteSaveId']?.toString();
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

    final inventoryList = data['inventory'] as List?;
    List<Item> inventoryItems = [];
    if (inventoryList != null) {
      for (final element in inventoryList) {
        if (element is String) {
          // Old format: List<String>
          final item = ItemsRepository.get(element);
          if (item != null) inventoryItems.add(item);
        } else if (element is Map) {
          // New format: List<Map>
          final id = element['id']?.toString();
          final count = (element['count'] as num?)?.toInt() ?? 1;
          if (id != null) {
            final item = ItemsRepository.get(id);
            if (item != null) {
              inventoryItems.add(item.copyWith(count: count));
            }
          }
        }
      }
    }

    final equippedList = data['equipped'] as List?;
    List<Item> equippedItems = [];
    if (equippedList != null) {
      for (final element in equippedList) {
        if (element is String) {
          // Old format
          final item = ItemsRepository.get(element);
          if (item != null) equippedItems.add(item);
        } else if (element is Map) {
          // New format
          final id = element['id']?.toString();
          final count = (element['count'] as num?)?.toInt() ?? 1;
          if (id != null) {
            final item = ItemsRepository.get(id);
            if (item != null) {
              equippedItems.add(item.copyWith(count: count));
            }
          }
        }
      }
    }

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

    final traits =
        (data['traits'] as List?)?.map((e) => e.toString()).toList() ?? [];

    return Player(
      name: data['name']?.toString() ?? '无名散修',
      gender: data['gender']?.toString() ?? '男',
      traits: traits,
      stageIndex: (data['stageIndex'] as num?)?.toInt() ?? 0,
      level: (data['level'] as num?)?.toInt() ?? 1,
      stats: stats,
      xp: (data['xp'] as num?)?.toInt() ?? 0,
      lifespanDays: (data['lifespanDays'] as num?)?.toInt() ?? 80 * 365,
      inventory: inventoryItems,
      equipped: equippedItems,
      buffIds: buffs,
    );
  }
}
