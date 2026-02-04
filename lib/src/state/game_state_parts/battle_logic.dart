part of '../game_state.dart';

extension BattleLogic on GameState {
  Battle? get currentBattle => _currentBattle;

  /// Get player's offensive element (MainHand > Soulbound > None)
  ElementType _getPlayerAttackElement() {
    for (final item in _player.equipped) {
      if (item.slot == EquipmentSlot.mainHand) return item.element;
    }
    for (final item in _player.equipped) {
      if (item.slot == EquipmentSlot.soulbound) return item.element;
    }
    return ElementType.none;
  }

  /// Get player's defensive element (Body > Guard > None)
  ElementType _getPlayerDefenseElement() {
    for (final item in _player.equipped) {
      if (item.slot == EquipmentSlot.body) return item.element;
    }
    for (final item in _player.equipped) {
      if (item.slot == EquipmentSlot.guard) return item.element;
    }
    return ElementType.none;
  }

  /// Get currently equipped weapon skill
  Item? getWeaponWithSkill() {
    for (final item in _player.equipped) {
      if ((item.slot == EquipmentSlot.mainHand ||
              item.slot == EquipmentSlot.soulbound) &&
          item.skillName != null) {
        return item;
      }
    }
    return null;
  }

  /// Calculate damage with element modifier
  int _calculateElementDamage(
    double baseDmg,
    ElementType atkType,
    ElementType defType,
  ) {
    final multiplier = ElementLogic.getMultiplier(atkType, defType);
    return max(1, (baseDmg * multiplier).round());
  }

  /// Start Battle (Local initiated)
  void startBattle(Enemy enemy) {
    _currentBattle = Battle(
      enemy: enemy,
      playerHp: _player.stats.hp,
      playerMaxHp: _player.effectiveStats.maxHp,
      playerSpirit: _player.stats.spirit,
      playerMaxSpirit: _player.effectiveStats.maxSpirit,
    );
    notify();
  }

  /// Player Basic Attack (Local only for now to ensure consistency)
  void progressBattle() {
    if (_currentBattle == null || _currentBattle!.isOver) return;
    _progressLocalBattle();
  }

  void _progressLocalBattle() {
    final battle = _currentBattle!;
    final enemy = battle.enemy;

    // Player Turn
    final playerAtkBase = (_player.effectiveStats.attack + _itemAttackBonus())
        .toDouble();
    final enemyDef = enemy.stats.defense.toDouble();
    final playerSpeed = _player.effectiveStats.speed + _itemSpeedBonus();
    final enemySpeed = enemy.stats.speed;

    // Element Logic
    final playerElement = _getPlayerAttackElement();
    final enemyElement = enemy.element;

    // Spirit Usage for Attack (Enhance attack if enough spirit)
    final hasSpirit = battle.playerSpirit >= 1;
    final isCrit =
        _rng.nextDouble() < (0.05 + (playerSpeed > enemySpeed ? 0.1 : 0.0));
    final critMultiplier = isCrit ? 1.5 : 1.0;

    double atkThisRound = hasSpirit ? playerAtkBase : playerAtkBase * 0.9;
    if (hasSpirit) {
      battle.playerSpirit -= 1; // Basic attack consumes 1 spirit for full power
    }

    // Variance
    atkThisRound *= (0.9 + _rng.nextDouble() * 0.2);

    // Raw Damage before element
    final rawDmg = (atkThisRound * critMultiplier) - enemyDef;

    // Apply Element
    final finalDmg = _calculateElementDamage(
      max(1.0, rawDmg),
      playerElement,
      enemyElement,
    );

    // Log details
    String logMsg = '你对 ${enemy.name} 造成了$finalDmg 点伤害';
    if (playerElement != ElementType.none) {
      final multiplier = ElementLogic.getMultiplier(
        playerElement,
        enemyElement,
      );
      if (multiplier > 1.0) logMsg += ' (克制)';
      if (multiplier < 1.0) logMsg += ' (被克)';
    }
    logMsg += '！';

    battle.enemyHp -= finalDmg;
    battle.logs.add(
      BattleLog(logMsg, isPlayerAction: true, damage: finalDmg, isCrit: isCrit),
    );

    if (battle.enemyHp <= 0) {
      battle.enemyHp = 0;
      battle.state = BattleState.victory;
      _resolveBattleVictory(battle);
      notify();
      return;
    }

    // Enemy Turn
    _resolveEnemyTurn(battle);
    notify();
  }

  /// Player Cast Spell (Weapon Skill)
  void playerCastSpell() {
    if (_currentBattle == null || _currentBattle!.isOver) return;

    final battle = _currentBattle!;
    final weapon = getWeaponWithSkill();

    if (weapon == null) {
      battle.logs.add(BattleLog('你没有装备带有术法的法宝！', isPlayerAction: true));
      notify();
      return;
    }

    // Local Logic
    if (battle.playerSpirit < weapon.skillCost) {
      battle.logs.add(
        BattleLog('灵力不足，无法施展${weapon.skillName}！', isPlayerAction: true),
      );
      notify();
      return;
    }

    // Consume Spirit
    battle.playerSpirit -= weapon.skillCost;

    final enemy = battle.enemy;
    final playerAtkBase = (_player.effectiveStats.attack + _itemAttackBonus())
        .toDouble();
    final enemyDef = enemy.stats.defense.toDouble();

    // Spell calculation
    final spellMultiplier = weapon.skillDamageMultiplier;
    double spellDmgBase = playerAtkBase * spellMultiplier;

    // Variance
    spellDmgBase *= (0.9 + _rng.nextDouble() * 0.2);

    // Element (Spell usually inherits weapon element)
    final playerElement = weapon.element;
    final enemyElement = enemy.element;

    final rawDmg =
        spellDmgBase - (enemyDef * 0.8); // Spells penetrate some defense
    final finalDmg = _calculateElementDamage(
      max(1.0, rawDmg),
      playerElement,
      enemyElement,
    );

    // Log
    String logMsg = '你施展【${weapon.skillName}】，对 ${enemy.name} 造成了$finalDmg 点伤害';
    if (playerElement != ElementType.none) {
      final multiplier = ElementLogic.getMultiplier(
        playerElement,
        enemyElement,
      );
      if (multiplier > 1.0) logMsg += ' (五行克制)';
    }
    logMsg += '！';

    battle.enemyHp -= finalDmg;
    battle.logs.add(
      BattleLog(
        logMsg,
        isPlayerAction: true,
        damage: finalDmg,
        isCrit: true, // Spells count as crit visually
      ),
    );

    if (battle.enemyHp <= 0) {
      battle.enemyHp = 0;
      battle.state = BattleState.victory;
      _resolveBattleVictory(battle);
      notify();
      return;
    }

    // Enemy Turn
    _resolveEnemyTurn(battle);
    notify();
  }

  Future<void> attemptFlee() async {
    if (_currentBattle == null || _currentBattle!.isOver) return;

    final battle = _currentBattle!;
    final enemy = battle.enemy;

    final playerSpeed = _player.effectiveStats.speed + _itemSpeedBonus();
    final enemySpeed = enemy.stats.speed;

    // Chance: 50% base + 2% per speed diff
    double chance = 0.5 + (playerSpeed - enemySpeed) * 0.02;
    chance = chance.clamp(0.1, 0.9); // Always some chance to fail or succeed

    if (_rng.nextDouble() < chance) {
      // Success
      battle.state = BattleState.fled;
      _log('你成功逃离了战斗！');
      notify();
    } else {
      // Fail
      battle.logs.add(BattleLog('逃跑失败！', isPlayerAction: true));
      _resolveEnemyTurn(battle);
      notify();
    }
  }

  void _resolveEnemyTurn(Battle battle) {
    if (battle.isOver) return;

    final enemy = battle.enemy;
    final enemyAtk = enemy.stats.attack.toDouble();
    // Use effective defense
    final playerDef = (_player.effectiveStats.defense + _itemDefenseBonus())
        .toDouble();

    // Element Interaction
    final enemyElement = enemy.element;
    final playerElement = _getPlayerDefenseElement();

    double enemyAtkThisRound = enemyAtk * (0.9 + _rng.nextDouble() * 0.2);
    final enemyIsCrit = _rng.nextDouble() < 0.05;
    if (enemyIsCrit) enemyAtkThisRound *= 1.5;

    final rawDmgToPlayer = enemyAtkThisRound - playerDef;
    final finalDmg = _calculateElementDamage(
      max(1.0, rawDmgToPlayer),
      enemyElement,
      playerElement,
    );

    battle.playerHp -= finalDmg;
    battle.logs.add(
      BattleLog(
        '${enemy.name} 对你造成了$finalDmg 点伤害！',
        isPlayerAction: false,
        damage: finalDmg,
        isCrit: enemyIsCrit,
      ),
    );

    if (battle.playerHp <= 0) {
      battle.playerHp = 0;
      battle.state = BattleState.defeat;
      _resolveBattleDefeat(battle);
      return; // Battle ended
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

    // Update Hunt Missions
    updateHuntProgress(enemy.id);

    // Loot (Async)
    _handleBattleLoot(enemy).then((_) {
      saveToDisk(); // Auto-save after loot processing
    });
  }

  Future<void> _handleBattleLoot(Enemy enemy) async {
    bool useLocal = true;

    // 1. Try Server Logic
    try {
      final dropsResponse = await _apiService.generateDrops(enemy.id);
      useLocal = false; // Server responded

      // Parse DropRollResponse: { "drops": [ { ...item... } ] }
      final dropsList = dropsResponse['drops'];
      if (dropsList is List && dropsList.isNotEmpty) {
        for (final drop in dropsList) {
          // drop is Map<String, dynamic> representing Item
          final itemId = drop['id']?.toString();
          if (itemId == null) continue;
          
          final count = drop['count'] is int ? drop['count'] as int : 1;

          // We can use the full item data from server, or just ID to lookup local repo.
          // Using local repo ensures consistency with local game data definitions.
          // But if server sends unique generated items, we should construct from JSON.
          // For now, let's try lookup by ID first, if not found (or for dynamic items), construct.
          // Given the context, ItemsRepository.get(itemId) is standard.
          
          final item = ItemsRepository.get(itemId);
          if (item != null) {
            final itemToAdd = item.copyWith(count: count);
            if (_addItem(itemToAdd)) {
              _log('拾取战利品：${item.name} ${count > 1 ? 'x$count' : ''}');
            } else {
              _log('包裹已满，无法拾取 ${item.name}');
            }
          }
        }
        notify();
      }
    } catch (e) {
      debugPrint('Server drops failed: $e');
      useLocal = true; // Fallback to local on error
    }

    if (!useLocal) return;

    // 2. Local Fallback Logic
    if (enemy.loot.isNotEmpty && _rng.nextDouble() < 0.3) {
      // Create weighted candidates list
      final candidates = <MapEntry<String, int>>[];

      for (final lootId in enemy.loot) {
        final item = ItemsRepository.get(lootId);
        if (item == null) continue;

        int weight;
        switch (item.rarity) {
          case ItemRarity.common:
            weight = 1000;
            break;
          case ItemRarity.uncommon:
            weight = 400;
            break;
          case ItemRarity.rare:
            weight = 150;
            break;
          case ItemRarity.epic:
            weight = 50;
            break;
          case ItemRarity.legendary:
            weight = 10;
            break;
          case ItemRarity.mythic:
            weight = 1;
            break;
        }
        candidates.add(MapEntry(lootId, weight));
      }

      if (candidates.isNotEmpty) {
        final totalWeight = candidates.fold(
          0,
          (sum, entry) => sum + entry.value,
        );
        final roll = _rng.nextInt(totalWeight);

        String? selectedLootId;
        int currentSum = 0;
        for (final entry in candidates) {
          currentSum += entry.value;
          if (roll < currentSum) {
            selectedLootId = entry.key;
            break;
          }
        }

        if (selectedLootId != null) {
          final added = _addItemById(selectedLootId);
          final item = ItemsRepository.get(selectedLootId);
          if (added && item != null) {
            _log('拾取战利品：${item.name}');
          }
        }
      }
      notify();
    }
  }

  void _resolveBattleDefeat(Battle battle) {
    final enemy = battle.enemy;
    _player = _player.copyWith(
      stats: _player.stats.copyWith(hp: 0, spirit: battle.playerSpirit),
    );
    _log('被 ${enemy.name} 击败，身死道消！');

    // Death: Delete save and character
    clearSave().then((_) {
      _log('存档已删除。');
      notify();
    });
  }

  void closeBattle() {
    _currentBattle = null;
    notify();
  }

  void attackNpc(Npc npc) {
    _currentInteractionNpc = null; // Close dialog

    // Update friendship to 0 (Hostile)
    final updatedNpc = npc.copyWith(friendship: 0);
    _npcStates[npc.id] = updatedNpc;

    // Convert NPC to Enemy for battle
    final enemy = Enemy(
      id: 'npc_${npc.id}',
      name: npc.name,
      description: '一名被你激怒的修士。',
      dangerLevel: 5, // Default danger
      stats: npc.stats,
      loot: [], // Or specific loot
      xpReward: npc.stats.attack * 2, // Simple logic
      element: ElementType.none, // NPC default element
    );

    _log('你突然对 ${npc.name} 发起了攻击！');

    _currentBattle = Battle(
      enemy: enemy,
      playerHp: _player.stats.hp,
      playerMaxHp: _player.effectiveStats.maxHp,
      playerSpirit: _player.stats.spirit,
      playerMaxSpirit: _player.effectiveStats.maxSpirit,
    );
    notify();
  }

  // Missing helper for defense bonus
  double _itemDefenseBonus() {
    return _player.equipped.fold<double>(
      0,
      (sum, item) => sum + item.defenseBonus,
    );
  }
}
