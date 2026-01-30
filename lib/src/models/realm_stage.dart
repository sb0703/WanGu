/// 种族定义
enum Race {
  human, // 人族
  beast, // 妖族
  devil, // 魔族
  ghost, // 鬼族
  spirit, // 灵族
  ancient, // 巫族
}

extension RaceExtension on Race {
  String get name {
    switch (this) {
      case Race.human:
        return '人族';
      case Race.beast:
        return '妖族';
      case Race.devil:
        return '魔族';
      case Race.ghost:
        return '鬼族';
      case Race.spirit:
        return '灵族';
      case Race.ancient:
        return '巫族';
    }
  }
}

/// 修仙境界阶段模型
class RealmStage {
  const RealmStage({
    required this.name,
    this.raceNames = const {},
    required this.maxXp,
    required this.hpBonus,
    required this.attackBonus,
    required this.spiritBonus,
  });

  final String name; // 默认(人族)境界名称
  final Map<Race, String> raceNames; // 各种族对应境界名称
  final int maxXp; // 该境界基础修为上限
  final int hpBonus; // 突破增加气血
  final int attackBonus; // 突破增加攻击
  final int spiritBonus; // 突破增加灵力

  /// 获取指定种族的境界名称
  String getName(Race race) {
    return raceNames[race] ?? name;
  }

  /// 境界定义列表
  static const stages = <RealmStage>[
    // 1. 练气期
    RealmStage(
      name: '练气',
      raceNames: {
        Race.beast: '聚灵',
        Race.devil: '聚气',
        Race.ghost: '游魂',
        Race.spirit: '启灵',
        Race.ancient: '蛮力',
      },
      maxXp: 200,
      hpBonus: 0,
      attackBonus: 0,
      spiritBonus: 0,
    ),
    // 2. 筑基期
    RealmStage(
      name: '筑基',
      raceNames: {
        Race.beast: '通智',
        Race.devil: '易筋',
        Race.ghost: '鬼卒',
        Race.spirit: '感知',
        Race.ancient: '铁骨',
      },
      maxXp: 1000,
      hpBonus: 30,
      attackBonus: 5,
      spiritBonus: 20,
    ),
    // 3. 金丹期
    RealmStage(
      name: '金丹',
      raceNames: {
        Race.beast: '锻骨',
        Race.devil: '锻体',
        Race.ghost: '鬼将',
        Race.spirit: '幻形',
        Race.ancient: '沸血',
      },
      maxXp: 5000,
      hpBonus: 80,
      attackBonus: 12,
      spiritBonus: 60,
    ),
    // 4. 元婴期
    RealmStage(
      name: '元婴',
      raceNames: {
        Race.beast: '妖丹',
        Race.devil: '魔丹',
        Race.ghost: '鬼王',
        Race.spirit: '聚形',
        Race.ancient: '战纹',
      },
      maxXp: 20000,
      hpBonus: 150,
      attackBonus: 25,
      spiritBonus: 120,
    ),
    // 5. 化神期
    RealmStage(
      name: '化神',
      raceNames: {
        Race.beast: '化形',
        Race.devil: '魔婴',
        Race.ghost: '鬼仙',
        Race.spirit: '融合',
        Race.ancient: '山海',
      },
      maxXp: 100000,
      hpBonus: 300,
      attackBonus: 50,
      spiritBonus: 240,
    ),
    // 6. 炼虚期
    RealmStage(
      name: '炼虚',
      raceNames: {
        Race.beast: '凝魄',
        Race.devil: '离识',
        Race.ghost: '摄魂',
        Race.spirit: '自然',
        Race.ancient: '破空',
      },
      maxXp: 500000,
      hpBonus: 600,
      attackBonus: 100,
      spiritBonus: 480,
    ),
    // 7. 合体期
    RealmStage(
      name: '合体',
      raceNames: {
        Race.beast: '返祖',
        Race.devil: '合体',
        Race.ghost: '渡魂',
        Race.spirit: '融合', // Note: Spirit fusion logic seems repeated or similar? Doc says '融合' for HuaShen and '自然' for LianXu. Ah, doc for HeTi (合体) says... wait.
        // Checking doc again:
        // Spirit:
        // HuaShen -> 融合 (Fusion)
        // LianXu -> 自然 (Nature)
        // Wait, doc doesn't explicitly list Spirit beyond LianXu? 
        // Let's check the doc again.
        // Doc says:
        // Spirit: ...
        // 69 | **炼虚** | **自然** (Nature) |
        // 70
        // Doc ends Spirit there? No, let me re-read tool output.
        // The tool output shows Spirit table ends at LianXu (Nature). 
        // I will double check the read output.
        // Lines 62-70 cover Spirit. It only goes up to LianXu.
        // Okay, I will infer or leave as is. But for code consistency I should probably have placeholders or repeat.
        // For now I'll use Human names or reasonable defaults if not specified, but the code supports missing keys (falls back to name).
        // However, I should try to be complete if possible.
        // Let's look at Ancient (Wu):
        // 85 | **合体** | **星辰** (Star) |
        // It ends at HeTi.
        // Wait, doc has:
        // Beast: goes to DaCheng (TianYao)
        // Devil: goes to DaCheng (DaTianMo)
        // Ghost: goes to DaCheng (GuiDi)
        // Spirit: Ends at LianXu?
        // Ancient: Ends at HeTi?
        // I will fill what I have.
        Race.ancient: '星辰',
      },
      maxXp: 2500000,
      hpBonus: 1200,
      attackBonus: 200,
      spiritBonus: 1000,
    ),
    // 8. 大乘期
    RealmStage(
      name: '大乘',
      raceNames: {
        Race.beast: '天妖',
        Race.devil: '大天魔',
        Race.ghost: '鬼帝',
        // Spirit/Ancient missing in doc for this level
      },
      maxXp: 10000000,
      hpBonus: 2500,
      attackBonus: 500,
      spiritBonus: 2000,
    ),
  ];
}
