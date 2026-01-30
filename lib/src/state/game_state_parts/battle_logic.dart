part of '../game_state.dart';

extension BattleLogic on GameState {
  Battle? get currentBattle => _currentBattle;

  void progressBattle() {
    if (_currentBattle == null || _currentBattle!.isOver) return;

    final battle = _currentBattle!;
    final enemy = battle.enemy;

    // Player Turn
    // Simple logic for now: Attack
    // Calculate stats (Use effective stats for battle)
    final playerAtkBase = (_player.effectiveStats.attack + _itemAttackBonus())
        .toDouble();
    final enemyDef = enemy.stats.defense.toDouble();
    final playerSpeed = _player.effectiveStats.speed + _itemSpeedBonus();
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
        '你对 ${enemy.name} 造成了$dmgToEnemy 点伤害！',
        isPlayerAction: true,
        damage: dmgToEnemy,
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
    final enemyAtk = enemy.stats.attack.toDouble();
    // Use effective defense
    final playerDef = (_player.effectiveStats.defense + _itemDefenseBonus())
        .toDouble();

    double enemyAtkThisRound = enemyAtk * (0.9 + _rng.nextDouble() * 0.2);
    final enemyIsCrit = _rng.nextDouble() < 0.05;
    if (enemyIsCrit) enemyAtkThisRound *= 1.5;

    final rawDmgToPlayer = enemyAtkThisRound - playerDef;
    final dmgToPlayer = max(1, rawDmgToPlayer.round());

    battle.playerHp -= dmgToPlayer;
    battle.logs.add(
      BattleLog(
        '${enemy.name} 对你造成了$dmgToPlayer 点伤害！',
        isPlayerAction: false,
        damage: dmgToPlayer,
        isCrit: enemyIsCrit,
      ),
    );

    if (battle.playerHp <= 0) {
      battle.playerHp = 0;
      battle.state = BattleState.defeat;
      _resolveBattleDefeat(battle);
      notify();
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

    notify();
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
