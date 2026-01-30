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
      if ((item.slot == EquipmentSlot.mainHand || item.slot == EquipmentSlot.soulbound) && 
          item.skillName != null) {
        return item;
      }
    }
    return null;
  }

  /// Calculate damage with element modifier
  int _calculateElementDamage(double baseDmg, ElementType atkType, ElementType defType) {
    final multiplier = ElementLogic.getMultiplier(atkType, defType);
    return max(1, (baseDmg * multiplier).round());
  }

  /// Player Basic Attack
  void progressBattle() {
    if (_currentBattle == null || _currentBattle!.isOver) return;

    final battle = _currentBattle!;
    final enemy = battle.enemy;

    // Player Turn
    final playerAtkBase = (_player.effectiveStats.attack + _itemAttackBonus()).toDouble();
    final enemyDef = enemy.stats.defense.toDouble();
    final playerSpeed = _player.effectiveStats.speed + _itemSpeedBonus();
    final enemySpeed = enemy.stats.speed;

    // Element Logic
    final playerElement = _getPlayerAttackElement();
    final enemyElement = enemy.element;

    // Spirit Usage for Attack (Enhance attack if enough spirit)
    final hasSpirit = battle.playerSpirit >= 1;
    final isCrit = _rng.nextDouble() < (0.05 + (playerSpeed > enemySpeed ? 0.1 : 0.0));
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
    final finalDmg = _calculateElementDamage(max(1.0, rawDmg), playerElement, enemyElement);
    
    // Log details
    String logMsg = '你对 ${enemy.name} 造成了$finalDmg 点伤害';
    if (playerElement != ElementType.none) {
      final multiplier = ElementLogic.getMultiplier(playerElement, enemyElement);
      if (multiplier > 1.0) logMsg += ' (克制)';
      if (multiplier < 1.0) logMsg += ' (被克)';
    }
    logMsg += '！';

    battle.enemyHp -= finalDmg;
    battle.logs.add(
      BattleLog(
        logMsg,
        isPlayerAction: true,
        damage: finalDmg,
        isCrit: isCrit,
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

    if (battle.playerSpirit < weapon.skillCost) {
      battle.logs.add(BattleLog('灵力不足，无法施展${weapon.skillName}！', isPlayerAction: true));
      notify();
      return;
    }

    // Consume Spirit
    battle.playerSpirit -= weapon.skillCost;

    final enemy = battle.enemy;
    final playerAtkBase = (_player.effectiveStats.attack + _itemAttackBonus()).toDouble();
    final enemyDef = enemy.stats.defense.toDouble();
    
    // Spell calculation
    final spellMultiplier = weapon.skillDamageMultiplier;
    double spellDmgBase = playerAtkBase * spellMultiplier;
    
    // Variance
    spellDmgBase *= (0.9 + _rng.nextDouble() * 0.2);
    
    // Element (Spell usually inherits weapon element)
    final playerElement = weapon.element;
    final enemyElement = enemy.element;
    
    final rawDmg = spellDmgBase - (enemyDef * 0.8); // Spells penetrate some defense
    final finalDmg = _calculateElementDamage(max(1.0, rawDmg), playerElement, enemyElement);

    // Log
    String logMsg = '你施展【${weapon.skillName}】，对 ${enemy.name} 造成了$finalDmg 点伤害';
    if (playerElement != ElementType.none) {
      final multiplier = ElementLogic.getMultiplier(playerElement, enemyElement);
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

  void attemptFlee() {
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
      // Update player state to reflect current battle status (e.g. lost HP/Spirit)
      _player = _player.copyWith(
        stats: _player.stats.copyWith(
          hp: battle.playerHp,
          spirit: battle.playerSpirit,
        ),
      );
      notify();
    } else {
      // Fail
      _log('逃跑失败！被 ${enemy.name} 追上了！');
      _resolveEnemyTurn(battle);
      notify();
    }
  }

  void _resolveEnemyTurn(Battle battle) {
    if (battle.isOver) return;

    final enemy = battle.enemy;
    final enemyAtk = enemy.stats.attack.toDouble();
    // Use effective defense
    final playerDef = (_player.effectiveStats.defense + _itemDefenseBonus()).toDouble();

    // Element Interaction
    final enemyElement = enemy.element;
    final playerElement = _getPlayerDefenseElement();

    double enemyAtkThisRound = enemyAtk * (0.9 + _rng.nextDouble() * 0.2);
    final enemyIsCrit = _rng.nextDouble() < 0.05;
    if (enemyIsCrit) enemyAtkThisRound *= 1.5;

    final rawDmgToPlayer = enemyAtkThisRound - playerDef;
    final finalDmg = _calculateElementDamage(max(1.0, rawDmgToPlayer), enemyElement, playerElement);

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

    // Loot
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
    }
    _checkBreakthrough();
    saveToDisk(); // Auto-save
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
    notify();
  }

  void attackNpc(Npc npc) {
    _currentInteractionNpc = null; // Close dialog

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
}
