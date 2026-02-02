part of '../game_state.dart';

extension ExplorationLogic on GameState {
  Point<int> get playerGridPos => _playerGridPos;
  Set<Point<int>> get visitedTiles => _visitedTiles;
  Npc? get currentInteractionNpc => _currentInteractionNpc;

  List<Npc> get currentNpcs {
    // Filter NPCs that are currently in this node based on dynamic location
    final idsInCurrentNode = _npcLocations.entries
        .where((entry) => entry.value == _currentNode.id)
        .map((entry) => entry.key)
        .toList();

    return idsInCurrentNode.map((id) => _getNpc(id)).whereType<Npc>().toList();
  }

  Npc? _getNpc(String id) {
    if (_npcStates.containsKey(id)) return _npcStates[id];
    return NpcsRepository.get(id);
  }

  // Interaction Methods
  void talkToNpc() {
    if (_currentInteractionNpc == null) return;
    var npc = _currentInteractionNpc!;

    // Chance to increase friendship
    int increase = 2;
    if (npc.friendship >= 80) increase = 1;
    if (npc.friendship >= 100) increase = 0;

    int newFriendship = npc.friendship + increase;
    npc = npc.copyWith(friendship: newFriendship);

    _updateNpcState(npc);
    _log('你与 ${npc.name} 交谈了一番，${increase > 0 ? "关系略有增进" : "相谈甚欢"}。');
  }

  void giftNpc(Item item) {
    if (_currentInteractionNpc == null) return;

    // Remove from player
    final index = _player.inventory.indexOf(item);
    if (index == -1) return;

    List<Item> newInv = [..._player.inventory];
    if (item.count > 1) {
      newInv[index] = item.copyWith(count: item.count - 1);
    } else {
      newInv.removeAt(index);
    }
    _player = _player.copyWith(inventory: newInv);

    // Add to NPC
    var npc = _currentInteractionNpc!;
    List<String> npcInv = [...npc.inventory, item.id];

    // Friendship calculation
    int bonus = (item.rarity.index + 1) * 10;
    int newFriendship = min(100, npc.friendship + bonus);

    npc = npc.copyWith(friendship: newFriendship, inventory: npcInv);
    _updateNpcState(npc);

    _log('你赠送了 ${item.name} 给 ${npc.name}，好感度 +$bonus！');
  }

  void stealFromNpc() {
    if (_currentInteractionNpc == null) return;
    var npc = _currentInteractionNpc!;

    if (npc.inventory.isEmpty) {
      _log('${npc.name} 身上似乎没有什么值得下手的。');
      return;
    }

    // Success Check (30% base)
    bool success = _rng.nextDouble() < 0.3;

    if (success) {
      final itemId = npc.inventory[_rng.nextInt(npc.inventory.length)];
      final item = ItemsRepository.get(itemId);

      if (item != null) {
        _addItem(item);
        List<String> npcInv = [...npc.inventory]..remove(itemId);
        npc = npc.copyWith(inventory: npcInv);

        int newF = max(0, npc.friendship - 5);
        npc = npc.copyWith(friendship: newF);
        _updateNpcState(npc);

        _log('你神不知鬼不觉地摸走了 ${item.name}！');
      }
    } else {
      int newF = max(0, npc.friendship - 30);
      npc = npc.copyWith(friendship: newF);
      _updateNpcState(npc);
      _log('行窃失败！被 ${npc.name} 当场抓获！好感度大跌！');

      if (newF < 20) {
        attackNpc(npc);
      }
    }
  }

  void _updateNpcState(Npc npc) {
    _npcStates[npc.id] = npc;
    // Ensure it has a location so we can find it again (and it can move)
    if (!_npcLocations.containsKey(npc.id)) {
      _npcLocations[npc.id] = _currentNode.id;
    }
    _currentInteractionNpc = npc;
    notify();
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

    notify();
  }

  /// Move within the grid
  void exploreMove(int row, int col) {
    if (isDead) return;

    final target = Point(row, col);
    if (_visitedTiles.contains(target) && target != _playerGridPos) {
      // Just moving to already visited tile
      _playerGridPos = target;
      notify();
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
    notify();
    saveToDisk(); // Auto-save
  }

  // Deprecated: moveTo used to be direct travel+event
  // Keeping for compatibility if needed, but should use enterRegion + exploreMove
  void moveTo(MapNode node) {
    enterRegion(node);
  }

  void rest({int days = 2}) {
    if (isDead) return;
    // Recover based on effective Max HP/Spirit
    final newHp = (_player.stats.hp + 10 * days).clamp(
      0,
      _player.effectiveStats.maxHp,
    );
    final newSpirit = (_player.stats.spirit + 8 * days).clamp(
      0,
      _player.effectiveStats.maxSpirit,
    );
    _player = _player.copyWith(
      stats: _player.stats.copyWith(hp: newHp, spirit: newSpirit),
    );
    _advanceTime(days);
    _log('调息恢复，气血/灵力回复');
    notify();
    saveToDisk(); // Auto-save
  }

  void _triggerNodeEvent(MapNode node) {
    final roll = _rng.nextDouble();

    if (roll < node.enemyChance) {
      _encounterEnemy(node);
    } else if (roll < node.enemyChance + node.herbChance) {
      _findResource(node);
    } else {
      _encounterNpc();
    }
  }

  Future<void> _findResource(MapNode node) async {
    if (node.resourceIds.isEmpty) {
      _log('此处似乎空空如也。');
      return;
    }

    // Use server to generate drops
    try {
      final drops = await _apiService.generateDrops(node.id, 'map_node');
      if (drops.isEmpty) {
        _log('虽然有些痕迹，但没找到有价值的东西。');
        return;
      }

      for (final drop in drops) {
        final itemId = drop['itemId'];
        final count = drop['count'] ?? 1;
        final item = ItemsRepository.get(itemId);
        if (item != null) {
          final itemToAdd = item.copyWith(count: count);
          final added = _addItem(itemToAdd);
          if (added) {
            _log('探索发现：${itemToAdd.name} x$count');
          } else {
            _log('包裹已满，无法拾取 ${itemToAdd.name}');
          }
        }
      }
    } catch (e) {
      debugPrint('Server drop generation failed: $e');
      // Fallback to local logic
      final resourceId =
          node.resourceIds[_rng.nextInt(node.resourceIds.length)];
      final item = ItemsRepository.get(resourceId);
      if (item == null) return;

      final added = _addItem(item);
      if (added) {
        _log('探索发现：${item.name}');
      }
    }
  }

  void _encounterNpc() {
    // Generate a random NPC based on current map danger or player level
    // Danger 1 maps -> Stage 0 (Qi Refinement)
    // Danger 2-3 -> Stage 1
    // etc.
    final stageIndex = max(0, (_currentNode.danger - 1) ~/ 2);
    final npc = NpcGenerator.generate(stageIndex: stageIndex);

    _log('你遇到了一名${npc.displayRealm}的${npc.name}。');
    _log(npc.description);

    // Auto start interaction or just show?
    // Let's interact immediately for now to show the generated content
    _currentInteractionNpc = npc;
    notify();
  }

  // NPC Interactions
  void startNpcInteraction(String npcId) {
    final npc = NpcsRepository.get(npcId);
    if (npc != null) {
      _currentInteractionNpc = npc;
      notify();
    }
  }

  void endNpcInteraction() {
    _currentInteractionNpc = null;
    notify();
  }
}
