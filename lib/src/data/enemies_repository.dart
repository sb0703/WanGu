import 'dart:math';

import '../models/enemy.dart';
import 'enemies/mortal_beasts.dart';
import 'enemies/spirit_beasts.dart';
import 'enemies/evil_spirits.dart';
import 'enemies/demons.dart';
import 'enemies/bosses.dart';

class EnemiesRepository {
  static final Random _rng = Random();

  static final List<Enemy> _allEnemies = [
    ...mortalBeasts,
    ...spiritBeasts,
    ...evilSpirits,
    ...demons,
    ...bosses,
  ];

  static final Map<String, Enemy> _enemiesMap = {
    for (var e in _allEnemies) e.id: e,
  };

  static Enemy? get(String id) => _enemiesMap[id];

  static List<Enemy> getAll() => _allEnemies;

  static Enemy rollEnemy(int danger) {
    // Filter enemies based on danger level
    // We allow a small variance: danger - 1 to danger + 1
    // If danger is high (e.g. 10), we look for 9-10.
    
    var candidates = _allEnemies.where((e) {
      return (e.dangerLevel - danger).abs() <= 1;
    }).toList();

    // Fallback 1: Widen range
    if (candidates.isEmpty) {
      candidates = _allEnemies.where((e) {
        return (e.dangerLevel - danger).abs() <= 2;
      }).toList();
    }

    // Fallback 2: Any enemy <= danger (for high danger maps that might lack specific high level content)
    if (candidates.isEmpty) {
      candidates = _allEnemies.where((e) {
        return e.dangerLevel <= danger;
      }).toList();
    }

    // Fallback 3: Return *something*
    if (candidates.isEmpty) {
       return _allEnemies.first; 
    }

    return candidates[_rng.nextInt(candidates.length)];
  }
}
