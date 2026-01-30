part of '../game_state.dart';

extension ExplorationLogic on GameState {
  Point<int> get playerGridPos => _playerGridPos;
  Set<Point<int>> get visitedTiles => _visitedTiles;
  Npc? get currentInteractionNpc => _currentInteractionNpc;

  List<Npc> get currentNpcs {
    return _currentNode.npcIds
        .map((id) => NpcsRepository.get(id))
        .whereType<Npc>()
        .toList();
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

  void _findResource(MapNode node) {
    if (node.resourceIds.isEmpty) {
      _log('此处似乎空空如也。');
      return;
    }

    final resourceId = node.resourceIds[_rng.nextInt(node.resourceIds.length)];
    final item = ItemsRepository.get(resourceId);
    if (item == null) return;

    final added = _addItem(item);
    if (added) {
      _log('探索发现：${item.name}');
    } else {
      // Bag full handled in _addItem but we can add specific log if needed,
      // though _addItem already logs "Bag full".
    }
  }

  void _encounterNpc() {
    _log('路过一名闭目修士，对方并未理你。');
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
