import '../drop_tables.dart';
import '../../models/enemy.dart';
import '../../models/stats.dart';

const List<Enemy> bosses = [
  // Secret Realm Guards (101-110)
  Enemy(
    id: 'stone_guardian',
    name: '石像守卫',
    description: '出没于遗迹门。被动触发，重击破盾。',
    dangerLevel: 9,
    stats: Stats(maxHp: 800, hp: 800, attack: 50, defense: 80, speed: 5, insight: 0, purity: 0),
    loot: ['stone_heart', 'inscription_fragment', ...DropTables.epicMonsterParts, ...DropTables.highLevelConsumables],
    xpReward: 150,
  ),
  Enemy(
    id: 'bronze_soldier',
    name: '铜人阵兵',
    description: '出没于祭坛。阵中连动，逐个击破更稳。',
    dangerLevel: 9,
    stats: Stats(maxHp: 600, hp: 600, attack: 45, defense: 60, speed: 10, insight: 5, purity: 0),
    loot: ['copper_core', 'array_flag_four_symbols', ...DropTables.epicMonsterParts, ...DropTables.midLevelConsumables],
    xpReward: 140,
  ),
  Enemy(
    id: 'rune_trap',
    name: '符纹地刺',
    description: '出没于通道。踩中即爆，可拆解收集。',
    dangerLevel: 8,
    stats: Stats(maxHp: 300, hp: 300, attack: 80, defense: 20, speed: 30, insight: 0, purity: 0),
    loot: ['talisman_fragment', 'trap_blueprint', ...DropTables.rareMonsterParts],
    xpReward: 100,
  ),
  Enemy(
    id: 'furnace_spirit',
    name: '吞火炉灵',
    description: '出没于炼器室。吞火成长，吐火成雨。',
    dangerLevel: 9,
    stats: Stats(maxHp: 700, hp: 700, attack: 70, defense: 40, speed: 15, insight: 10, purity: 50),
    loot: ['furnace_core', 'red_flame_crystal', ...DropTables.epicHerbs, ...DropTables.highLevelConsumables],
    xpReward: 160,
  ),
  Enemy(
    id: 'mirror_maze_spirit',
    name: '碎镜迷宫灵',
    description: '出没于迷宫。复制分身，畏破障符。',
    dangerLevel: 9,
    stats: Stats(maxHp: 500, hp: 500, attack: 40, defense: 20, speed: 35, insight: 20, purity: 10),
    loot: ['mirror_sand', 'map_fragment', ...DropTables.midLevelConsumables, ...DropTables.rareHerbs],
    xpReward: 145,
  ),
  Enemy(
    id: 'spring_guardian',
    name: '灵泉守灵',
    description: '出没于泉眼。治愈亦反噬，考验心性。',
    dangerLevel: 9,
    stats: Stats(maxHp: 1000, hp: 1000, attack: 30, defense: 50, speed: 12, insight: 25, purity: 100),
    loot: ['spring_core', 'spirit_liquid', ...DropTables.epicHerbs, ...DropTables.highLevelConsumables],
    xpReward: 180,
  ),
  Enemy(
    id: 'wind_blade_spirit',
    name: '风刃回廊灵',
    description: '出没于回廊。风刃循环，需要节奏通过。',
    dangerLevel: 9,
    stats: Stats(maxHp: 400, hp: 400, attack: 90, defense: 10, speed: 40, insight: 0, purity: 20),
    loot: ['wind_core', 'inscription_fragment', ...DropTables.midLevelConsumables],
    xpReward: 155,
  ),
  Enemy(
    id: 'thunder_pillar_spirit',
    name: '雷柱试炼灵',
    description: '出没于雷殿。雷柱锁定，靠引雷针可转向。',
    dangerLevel: 10,
    stats: Stats(maxHp: 900, hp: 900, attack: 100, defense: 40, speed: 25, insight: 10, purity: 30),
    loot: ['thunder_sand', 'thunder_key', ...DropTables.epicMonsterParts, ...DropTables.advancedEquipment],
    xpReward: 200,
  ),
  Enemy(
    id: 'shadow_curtain_keeper',
    name: '影幕看守者',
    description: '出没于宝库。影幕遮宝，需点亮正确灯位。',
    dangerLevel: 10,
    stats: Stats(maxHp: 600, hp: 600, attack: 60, defense: 30, speed: 50, insight: 30, purity: 0),
    loot: ['shadow_dust', 'treasure_clue', ...DropTables.specialEquipment, ...DropTables.highLevelConsumables],
    xpReward: 190,
  ),
  Enemy(
    id: 'sealed_beast',
    name: '封印锁兽',
    description: '出没于封印门。越挣越强，需破阵后击杀。',
    dangerLevel: 10,
    stats: Stats(maxHp: 2000, hp: 2000, attack: 120, defense: 100, speed: 5, insight: 0, purity: -100),
    loot: ['broken_chain', 'seal_rune', ...DropTables.epicMonsterParts, ...DropTables.specialEquipment],
    xpReward: 300,
  ),

  // Disasters / Anomalies (111-120)
  // Represented as high-level entities
  Enemy(
    id: 'spirit_tide',
    name: '灵潮暴动',
    description: '天灾。灵气如浪，拍碎低阶修士经脉。',
    dangerLevel: 10,
    stats: Stats(maxHp: 5000, hp: 5000, attack: 200, defense: 0, speed: 100, insight: 0, purity: 0),
    loot: ['spirit_stone', 'spirit_essence', ...DropTables.highLevelConsumables],
    xpReward: 0,
  ),
];
