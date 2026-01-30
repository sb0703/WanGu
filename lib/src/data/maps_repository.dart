import '../models/map_node.dart';

class MapsRepository {
  static List<MapNode> getAll() {
    return const [
      MapNode(
        id: 'sect_back_mountain',
        name: '宗门后山',
        description: '宗门划定的安全区域，灵气尚可，适合低阶弟子打坐练气。',
        danger: 1,
        enemyChance: 0.3, // Low enemy chance
        herbChance: 0.4, // Decent herb chance
        resourceIds: ['dew_grass', 'spirit_stone_low', 'wood'],
        npcIds: ['sect_elder'],
      ),
      MapNode(
        id: 'green_bamboo_forest',
        name: '青竹林',
        description: '盛产灵竹与低阶草药，常有青蛇出没。',
        danger: 2,
        enemyChance: 0.5,
        herbChance: 0.4,
        resourceIds: ['green_spirit_leaf', 'dragon_whisker_grass', 'bamboo'],
        npcIds: ['village_chief'],
      ),
      MapNode(
        id: 'herb_garden',
        name: '百草园',
        description: '灵气充裕的药园，虽然有阵法保护，但偶尔也有偷药的小兽。',
        danger: 2,
        enemyChance: 0.2,
        herbChance: 0.7, // Very high herb chance
        resourceIds: ['dew_grass', 'purple_ginseng', 'spring_vine', 'tri_color_lotus'],
        npcIds: ['sect_disciple'],
      ),
      MapNode(
        id: 'chaotic_stone_hill',
        name: '乱石岗',
        description: '怪石嶙峋，植被稀少，但盛产矿石。',
        danger: 3,
        enemyChance: 0.4,
        herbChance: 0.1,
        resourceIds: ['iron_ore', 'copper_essence', 'stone_heart_flower'],
        npcIds: ['traveling_merchant'],
      ),
      MapNode(
        id: 'dark_wind_cave',
        name: '阴风洞',
        description: '终年阴风怒号，寒气逼人，多阴生毒物。',
        danger: 4,
        enemyChance: 0.6,
        herbChance: 0.3,
        resourceIds: ['moon_shadow_grass', 'bat_bone', 'withered_heart_wood'],
        npcIds: [],
      ),
      MapNode(
        id: 'cold_pond',
        name: '寒潭',
        description: '水温极低，深不见底，盛产寒属性灵材。',
        danger: 5,
        enemyChance: 0.5,
        herbChance: 0.4,
        resourceIds: ['cold_marrow_orchid', 'fish_scale', 'green_frost_moss'],
        npcIds: [],
      ),
      MapNode(
        id: 'raging_fire_valley',
        name: '烈火谷',
        description: '地火弥漫，酷热难耐，火系妖兽横行。',
        danger: 6,
        enemyChance: 0.6,
        herbChance: 0.3,
        resourceIds: ['red_flame_flower', 'fire_pattern_stone', 'lizard_core', 'sun_flame_fruit'],
        npcIds: [],
      ),
      MapNode(
        id: 'sunset_peak',
        name: '落霞峰',
        description: '高耸入云，猛禽盘踞，可采集到珍稀的飞行妖兽材料。',
        danger: 7,
        enemyChance: 0.6,
        herbChance: 0.3,
        resourceIds: ['eagle_feather', 'vulture_wing', 'wind_bell_grass'],
        npcIds: [],
      ),
      MapNode(
        id: 'beast_mountain',
        name: '万兽山',
        description: '妖兽聚集之地，危机四伏，猎杀妖兽的好去处。',
        danger: 8,
        enemyChance: 0.8, // High encounter rate
        herbChance: 0.1,
        resourceIds: ['wolf_fang', 'bear_skin', 'tiger_bone', 'monster_leather'],
        npcIds: [],
      ),
      MapNode(
        id: 'thunder_wood_forest',
        name: '雷击木林',
        description: '常年落雷，焦土遍地，孕育雷属性至宝。',
        danger: 8,
        enemyChance: 0.5,
        herbChance: 0.3,
        resourceIds: ['lightning_struck_wood', 'thunder_pattern_grass', 'thunder_sand'],
        npcIds: [],
      ),
      MapNode(
        id: 'market_city',
        name: '散修坊市',
        description: '修士交易之地，鱼龙混杂，消息灵通。',
        danger: 1,
        enemyChance: 0.05, // Very safe
        herbChance: 0.05, // Few resources to find on ground
        resourceIds: ['broken_silver', 'spirit_stone'],
        npcIds: ['traveling_merchant', 'sect_disciple', 'rogue_cultivator'],
      ),
      MapNode(
        id: 'ancient_ruins',
        name: '上古遗迹',
        description: '残垣断壁中隐藏着上古机缘，也潜伏着未知的恐怖。',
        danger: 10,
        enemyChance: 0.7,
        herbChance: 0.2,
        resourceIds: ['spirit_stone_med', 'jade_marrow_fungus', 'ancient_blade', 'obsidian'],
        npcIds: [],
      ),
    ];
  }
}
