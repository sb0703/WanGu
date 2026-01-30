/// Drop tables for dynamic loot generation
class DropTables {
  // 常用灵草 (Common Herbs)
  static const List<String> commonHerbs = [
    'dew_grass',
    'green_spirit_leaf',
    'red_flame_flower',
    'cold_marrow_orchid',
    'wind_bell_grass',
    'green_radish_vine',
    'red_sand_grass',
  ];

  // 稀有灵草 (Rare Herbs)
  static const List<String> rareHerbs = [
    'purple_ginseng',
    'gold_thread_vine',
    'spring_vine',
    'moon_shadow_grass',
    'tri_color_lotus',
    'jade_bamboo',
    'green_frost_moss',
    'dragon_whisker_grass',
  ];

  // 珍贵灵草 (Epic Herbs)
  static const List<String> epicHerbs = [
    'jade_marrow_fungus',
    'crimson_cloud_fungus',
    'stone_heart_flower',
    'thunder_pattern_grass',
    'dust_star_grass',
    'bitter_moon_grass',
  ];

  // 常用兽材 (Common Monster Parts)
  static const List<String> commonMonsterParts = [
    'wolf_fang',
    'bear_skin',
    'snake_gall',
    'eagle_feather',
    'beetle_shell',
  ];

  // 稀有兽材 (Rare Monster Parts)
  static const List<String> rareMonsterParts = [
    'turtle_shell',
    'fox_blood',
    'goat_horn',
    'fish_scale',
    'ape_tendon',
  ];

  // 珍贵兽材 (Epic Monster Parts)
  static const List<String> epicMonsterParts = ['lizard_core', 'python_skin'];

  // 低阶消耗品 (Low Level Consumables)
  static const List<String> lowLevelConsumables = [
    'breath_powder',
    'blood_paste',
    'vitality_pill',
    'antidote_pill',
    'spirit_stone_low',
    'broken_silver',
  ];

  // 中阶消耗品 (Mid Level Consumables)
  static const List<String> midLevelConsumables = [
    'spirit_pill',
    'bone_powder',
    'flesh_growth_powder',
    'clear_stasis_pill',
    'spirit_stone',
  ];

  // 高阶消耗品 (High Level Consumables)
  static const List<String> highLevelConsumables = [
    'heart_pill',
    'spring_pill',
    'vein_warming_pill',
    'gu_remover_pill',
    'gold_ingot',
    'jade_coin',
  ];

  // 基础装备 (Basic Equipment)
  static const List<String> basicEquipment = [
    'green_steel_sword',
    'iron_staff',
    'spirit_locking_chain',
  ];

  // 进阶装备 (Advanced Equipment)
  static const List<String> advancedEquipment = [
    'frost_dagger',
    'red_flame_saber',
    'flowing_light_spear',
    'mountain_breaking_hammer',
    'singing_wind_bow',
  ];

  // 特殊装备 (Special Equipment)
  static const List<String> specialEquipment = [
    'spirit_pattern_sword_embryo',
    'soul_slashing_bell',
  ];
}
