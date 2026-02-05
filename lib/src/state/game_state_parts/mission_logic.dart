part of '../game_state.dart';

extension MissionLogic on GameState {
  // 刷新可接任务
  bool refreshAvailableMissions({int cost = 10}) {
    if (cost > 0) {
      final spiritStones = _player.inventory
          .where((i) => i.id == 'spirit_stone')
          .length;
      if (spiritStones < cost) {
        return false;
      }
      _removeItemsById('spirit_stone', cost);
      _log('消耗 $cost 灵石刷新了任务列表');
    }

    final allMissions = MissionsRepository.missions;
    if (allMissions.isEmpty) return false;

    // Randomly select between 2 and 10 missions (or less if not enough missions)
    final maxCount = min(10, allMissions.length);
    // Ensure we don't try to get more than available, and at least 1 if possible
    final minCount = min(2, maxCount);

    // Random count between minCount and maxCount
    final count = minCount + _rng.nextInt(maxCount - minCount + 1);

    final shuffled = [...allMissions]..shuffle(_rng);
    _availableMissionIds = shuffled.take(count).map((m) => m.id).toList();

    notify();
    saveToDisk();
    return true;
  }

  // 接取任务
  void acceptMission(Mission mission) {
    if (_activeMissions.any((m) => m.missionId == mission.id)) {
      _log('已接取该任务：${mission.title}');
      return;
    }

    final active = ActiveMission(
      missionId: mission.id,
      startYear: _clock.year,
      startMonth: _clock.month,
      startDay: _clock.day,
      startHour: _clock.hour,
    );
    _activeMissions = [
      ..._activeMissions,
      active,
    ]; // Reassign to trigger update if watched

    // Remove from available list
    _availableMissionIds = [..._availableMissionIds]..remove(mission.id);

    _log('接取任务：${mission.title}');

    // 如果是收集任务，立即检查背包
    if (mission.type == MissionType.collect) {
      _updateCollectionProgressFor(active, mission);
    }

    notify();
    saveToDisk();
  }

  // 放弃任务
  void abandonMission(ActiveMission active) {
    final mission = MissionsRepository.getMissionById(active.missionId);
    _activeMissions = [..._activeMissions]..remove(active);
    if (mission != null) {
      _log('放弃任务：${mission.title}');
    }
    notify();
    saveToDisk();
  }

  // 提交任务
  void submitMission(ActiveMission active) {
    final mission = MissionsRepository.getMissionById(active.missionId);
    if (mission == null) return;

    // Check expiration
    if (mission.timeLimitDays != null) {
      // Calculate elapsed days
      // Simplify: (currentYear - startYear) * 360 + (currentMonth - startMonth) * 30 + (currentDay - startDay)
      // Assuming 12 months/year, 30 days/month
      final startTotalDays =
          active.startYear * 360 + active.startMonth * 30 + active.startDay;
      final currentTotalDays =
          _clock.year * 360 + _clock.month * 30 + _clock.day;
      final elapsedDays = currentTotalDays - startTotalDays;

      if (elapsedDays > mission.timeLimitDays!) {
        _log('任务已过期：${mission.title}');
        _activeMissions = [..._activeMissions]..remove(active);
        notify();
        saveToDisk();
        return;
      }
    }

    // 再次更新状态确保准确
    if (mission.type == MissionType.collect) {
      _updateCollectionProgressFor(active, mission);
    }

    if (!active.isCompleted) {
      _log('任务目标尚未达成');
      return;
    }

    // 扣除收集物品
    if (mission.type == MissionType.collect) {
      if (!_hasItemCount(mission.targetId, mission.targetCount)) {
        _log('缺少任务物品：${mission.targetName}');
        return;
      }
      _removeItemsById(mission.targetId, mission.targetCount);
      _log('上交了 ${mission.targetCount} 个 ${mission.targetName}');
    }

    // 发放奖励
    _distributeRewards(mission.reward);

    // 移除任务并记录
    _activeMissions = [..._activeMissions]..remove(active);
    _completedMissionIds = {..._completedMissionIds, mission.id};
    _log('任务完成：${mission.title}！');

    notify();
    saveToDisk();
  }

  void _distributeRewards(MissionReward reward) {
    if (reward.contribution > 0) {
      _player = _player.copyWith(
        contribution: _player.contribution + reward.contribution,
      );
      _log('获得宗门贡献 ${reward.contribution}');
    }
    if (reward.exp > 0) {
      final newXp = _player.xp + reward.exp;
      // Simple XP add, capping logic is in cultivation but let's allow overflow or cap here
      final maxXp = _player.currentMaxXp;
      _player = _player.copyWith(xp: min(newXp, maxXp));
      _log('获得修为 ${reward.exp}');
    }
    for (final itemId in reward.itemIds) {
      _addItemById(itemId);
      _log('获得奖励物品：${ItemsRepository.get(itemId)?.name ?? itemId}');
    }
  }

  // 更新讨伐进度 (需在 BattleLogic 中调用)
  void updateHuntProgress(String enemyId) {
    bool changed = false;
    // 使用新的列表以避免修改正在遍历的列表（虽然这里只修改内部属性）
    for (final active in _activeMissions) {
      final mission = MissionsRepository.getMissionById(active.missionId);
      if (mission != null &&
          mission.type == MissionType.hunt &&
          mission.targetId == enemyId) {
        if (active.currentCount < mission.targetCount) {
          active.currentCount++;
          if (active.currentCount >= mission.targetCount) {
            active.isCompleted = true;
            _log('任务目标达成：${mission.title}');
          }
          changed = true;
        }
      }
    }
    if (changed) {
      notify();
      saveToDisk();
    }
  }

  // 更新所有收集任务进度 (需在 InventoryLogic 或 UI 中调用)
  void updateAllCollectionProgress() {
    bool changed = false;
    for (final active in _activeMissions) {
      final mission = MissionsRepository.getMissionById(active.missionId);
      if (mission != null && mission.type == MissionType.collect) {
        final oldCompleted = active.isCompleted;
        final oldCount = active.currentCount;
        _updateCollectionProgressFor(active, mission);
        if (active.isCompleted != oldCompleted ||
            active.currentCount != oldCount) {
          changed = true;
        }
      }
    }
    if (changed) notify();
  }

  void _updateCollectionProgressFor(ActiveMission active, Mission mission) {
    // 计算背包中有多少个目标物品
    int count = _player.inventory.where((i) => i.id == mission.targetId).length;
    active.currentCount = count;
    active.isCompleted = count >= mission.targetCount;
  }

  // Helpers
  bool _hasItemCount(String itemId, int count) {
    return _player.inventory.where((i) => i.id == itemId).length >= count;
  }

  void _removeItemsById(String itemId, int count) {
    var remaining = count;
    final newInventory = [..._player.inventory];
    newInventory.removeWhere((item) {
      if (remaining > 0 && item.id == itemId) {
        remaining--;
        return true;
      }
      return false;
    });
    _player = _player.copyWith(inventory: newInventory);
  }
}
