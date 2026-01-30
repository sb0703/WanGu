import '../models/mission.dart';

class MissionsRepository {
  static final List<Mission> missions = [
    // 收集任务
    const Mission(
      id: 'collect_herbs_01',
      title: '采集凝露草',
      description: '宗门炼丹房急需凝露草制作回气散，前往后山采集。',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '凝露草',
      targetCount: 5,
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: ['spirit_stone'],
      ),
    ),
    const Mission(
      id: 'collect_iron_ore',
      title: '补充矿石储备',
      description: '炼器室缺少玄铁矿，去矿洞挖掘一些回来。',
      type: MissionType.collect,
      targetId: 'iron_ore',
      targetName: '玄铁矿',
      targetCount: 3,
      difficulty: 2,
      reward: MissionReward(
        contribution: 15,
        exp: 30,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'collect_bear_skin',
      title: '收集熊皮',
      description: '需要一些铁背熊皮来制作皮甲。',
      type: MissionType.collect,
      targetId: 'bear_skin',
      targetName: '铁背熊皮',
      targetCount: 5,
      difficulty: 3,
      reward: MissionReward(
        contribution: 25,
        exp: 50,
        itemIds: ['spirit_stone', 'spirit_stone', 'blood_paste'],
      ),
    ),

    // 讨伐任务
    const Mission(
      id: 'hunt_wild_boar',
      title: '清理野牙山猪',
      description: '山下的农田被野牙山猪破坏了，去清理它们。',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '野牙山猪',
      targetCount: 3,
      difficulty: 1,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: ['spirit_stone'],
      ),
    ),
    const Mission(
      id: 'hunt_iron_beak_crow',
      title: '驱逐铁嘴鸦',
      description: '铁嘴鸦经常袭击过往的低阶弟子，去教训它们。',
      type: MissionType.hunt,
      targetId: 'iron_beak_crow',
      targetName: '铁嘴鸦',
      targetCount: 5,
      difficulty: 2,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'hunt_black_mastiff',
      title: '恶犬伤人',
      description: '黑背獒妖在村寨附近游荡，十分危险，务必铲除。',
      type: MissionType.hunt,
      targetId: 'black_mastiff',
      targetName: '黑背獒妖',
      targetCount: 2,
      difficulty: 3,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: ['vitality_pill'],
      ),
    ),
  ];

  static Mission? getMissionById(String id) {
    try {
      return missions.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}
