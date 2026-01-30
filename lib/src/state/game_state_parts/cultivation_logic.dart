part of '../game_state.dart';

extension CultivationLogic on GameState {
  bool get showingBreakthrough => _showingBreakthrough;
  bool get breakthroughSuccess => _breakthroughSuccess;
  String get breakthroughMessage => _breakthroughMessage;

  // Cultivate: Absorb Qi (Increases XP, Decreases Purity)
  void cultivate({int days = 1}) {
    if (isDead) return;

    // Check if player reached max XP for current realm level
    final maxXp = _player.currentMaxXp;
    if (_player.xp >= maxXp) {
      _advanceTime(days);
      _log('修为已至瓶颈，无法寸进，需闭关突破。');
      notify();
      saveToDisk(); // Auto-save
      return;
    }

    // Base XP gain (Use effective insight)
    int baseGain = 6 + _player.effectiveStats.insight;

    // Decrease XP gain based on stage index (Diminishing returns)
    double efficiency = (1.0 - (_player.stageIndex * 0.2)).clamp(0.1, 1.0);

    int gainedXp = (baseGain * efficiency * days).toInt(); // Scaled by days
    if (gainedXp < 1) gainedXp = 1;

    // Purity Penalty: -1 per day (Base)
    int purityLoss = 1 * days;

    // Cap XP at max
    int newXp = _player.xp + gainedXp;
    if (newXp > maxXp) {
      newXp = maxXp;
    }

    // Apply stats changes
    _player = _player.copyWith(
      xp: newXp,
      stats: _player.stats.copyWith(
        purity: (_player.stats.purity - purityLoss).clamp(0, 100),
      ),
    );

    _advanceTime(days);
    _log('纳气修炼 $days 天，修为+$gainedXp，纯度-$purityLoss');
    notify();
    saveToDisk(); // Auto-save
  }

  // Purify: Remove Impurity (No XP, Increases Purity)
  void purify({int days = 1}) {
    if (isDead) return;

    if (_player.stats.purity >= 100) {
      _advanceTime(days);
      _log('灵气已纯净无暇，无需提纯。');
      notify();
      saveToDisk(); // Auto-save
      return;
    }

    // Base Purity Gain
    // Insight helps purify faster (Use effective insight)
    int baseRecovery = 2 + (_player.effectiveStats.insight ~/ 5);
    int totalRecovery = baseRecovery * days;

    _player = _player.copyWith(
      stats: _player.stats.copyWith(
        purity: (_player.stats.purity + totalRecovery).clamp(0, 100),
      ),
    );

    _advanceTime(days);
    _log('运功化煞 $days 天，纯度+$totalRecovery');
    notify();
    saveToDisk(); // Auto-save
  }

  /// Manually trigger breakthrough attempt
  void attemptBreakthrough() {
    _checkBreakthrough();
  }

  void closeBreakthrough() {
    _showingBreakthrough = false;
    notify();
  }
}
