import '../models/mission.dart';

class MissionsRepository {
  static final List<Mission> missions = [
    const Mission(
      id: 'mission_001',
      title: '押运·青石镇瘟疫阵旗',
      description: '缉拿青石镇附近的黑刃刺客 (成功会提升势力好感；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_002',
      title: '救出·宗门外门失踪药材',
      description: '清剿宗门外门的鬼面蜂，收集证据 (会增加天道注视；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_003',
      title: '修复·浮云台灵脉争夺矿脉样本',
      description: '在浮云台采集空灵石并安全带回 (会增加天道注视；失败会留下因果标记)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '空灵石',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_004',
      title: '清剿·古墓入口邪祟作乱封印钉',
      description: '在炼器堂完成一次布阵委托 (需要在限时内完成；可能引来仇家)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_005',
      title: '镇压·赤焰洞走火灵石车队',
      description: '在赤焰洞调查叛徒并提交报告 (需要在限时内完成；需要携带特定道具)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_006',
      title: '追查·古墓入口灵脉争夺令牌',
      description: '在炼器堂完成一次布阵委托 (有隐藏分支对话；可选择和平或强硬解决)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_007',
      title: '勘测·秘境裂隙秘境开启阵旗',
      description: '与秘境裂隙的药圃管事交涉，化解债契争端 (有隐藏分支对话；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_008',
      title: '押运·星砂滩灵潮异常矿脉样本',
      description: '缉拿星砂滩附近的炼尸道人 (需要在限时内完成；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_009',
      title: '采集·阵法殿秘境开启矿脉样本',
      description: '在阵法殿完成一次布阵委托 (会增加天道注视；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 1, // Scaling count
      difficulty: 1,
      reward: MissionReward(
        contribution: 10,
        exp: 20,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_010',
      title: '押运·星砂滩阵法失效被盗法器',
      description: '清剿星砂滩的时隙裂纹，收集证据 (成功会提升势力好感；需要在限时内完成)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '时隙裂纹',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_011',
      title: '追查·古战场邪祟作乱古卷',
      description: '护送外门执事穿越古战场，避开蛛王 (会增加天道注视；需要携带特定道具)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_012',
      title: '护送·赤焰洞封印松动矿脉样本',
      description: '护送炼器师穿越赤焰洞，避开铜人阵兵 (完成后解锁后续连环任务；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'bronze_soldier',
      targetName: '铜人阵兵',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_013',
      title: '救出·封印古井秘境开启钥匙',
      description: '在炼丹堂完成一次布阵委托 (可选择和平或强硬解决；失败会留下因果标记)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_014',
      title: '追查·荒漠驿站走火宗门弟子',
      description: '清剿荒漠驿站的尸傀，收集证据 (夜间完成收益更高；需要携带特定道具)',
      type: MissionType.hunt,
      targetId: 'corpse_puppet',
      targetName: '尸傀',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_015',
      title: '潜入·星砂滩秘境开启令牌',
      description: '清剿星砂滩的迷途雾，收集证据 (可选择和平或强硬解决；可能触发伏击)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '迷途雾',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_016',
      title: '押运·炼器堂邪祟作乱矿脉样本',
      description: '缉拿炼器堂附近的炼尸道人 (夜间完成收益更高；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_017',
      title: '押运·青石镇黑市交易封印钉',
      description: '清剿青石镇的尸傀，收集证据 (有隐藏分支对话；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'corpse_puppet',
      targetName: '尸傀',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_018',
      title: '修复·秘境裂隙妖患古卷',
      description: '与秘境裂隙的散修首领交涉，化解矿脉纠纷 (需要携带特定道具；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_019',
      title: '护送·青石镇叛徒封印钉',
      description: '镇压青石镇的封印异动并补齐封印 (会增加天道注视；需要携带特定道具)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 2, // Scaling count
      difficulty: 2,
      reward: MissionReward(
        contribution: 20,
        exp: 40,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_020',
      title: '护送·望月坊市走火封印钉',
      description: '清剿望月坊市的时隙裂纹，收集证据 (完成后解锁后续连环任务；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '时隙裂纹',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_021',
      title: '封印·浮云台盗窃祭坛',
      description: '镇压浮云台的封印异动并补齐封印 (可选择和平或强硬解决；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_022',
      title: '勘测·星砂滩灵潮异常祭坛',
      description: '与星砂滩的药圃管事交涉，化解矿脉纠纷 (有隐藏分支对话；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_023',
      title: '护法·宗门外门秘境开启阵旗',
      description: '在宗门外门采集青灵叶并安全带回 (可能触发反转真凶；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'green_spirit_leaf',
      targetName: '青灵叶',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_024',
      title: '采集·古战场失踪古卷',
      description: '护送药圃管事穿越古战场，避开鬼面蜂 (可能引来仇家；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_025',
      title: '侦探·赤焰洞灵脉争夺供香',
      description: '镇压赤焰洞的封印异动并补齐封印 (失败会留下因果标记；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_026',
      title: '护送·黑风岭阵法失效钥匙',
      description: '在炼器堂完成一次炼丹委托 (失败会留下因果标记；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_027',
      title: '潜入·云水城灵脉争夺古卷',
      description: '缉拿云水城附近的血契商人 (会增加天道注视；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'fake_envoy',
      targetName: '血契商人',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_028',
      title: '救出·落霞谷妖患丹炉',
      description: '清剿落霞谷的铜人阵兵，收集证据 (有隐藏分支对话；失败会留下因果标记)',
      type: MissionType.hunt,
      targetId: 'bronze_soldier',
      targetName: '铜人阵兵',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_029',
      title: '清剿·云水城走火封印钉',
      description: '缉拿云水城附近的伪宗门使 (失败会留下因果标记；可能触发反转真凶)',
      type: MissionType.hunt,
      targetId: 'fake_envoy',
      targetName: '伪宗门使',
      targetCount: 3, // Scaling count
      difficulty: 3,
      reward: MissionReward(
        contribution: 30,
        exp: 60,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_030',
      title: '潜入·城主府失踪宗门弟子',
      description: '在炼器堂完成一次炼丹委托 (可能引来仇家；失败会留下因果标记)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_031',
      title: '护送·雷原妖患阵旗',
      description: '与雷原的掌柜交涉，化解误会追杀 (可能触发反转真凶；可选择和平或强硬解决)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_032',
      title: '镇压·封印古井失踪药材',
      description: '护送散修首领穿越封印古井，避开规则倒刺 (可选择和平或强硬解决；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_033',
      title: '采集·镜湖妖患灵石车队',
      description: '护送药圃管事穿越镜湖，避开灵潮涌动 (夜间完成收益更高；有隐藏分支对话)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_034',
      title: '追查·宗门外门秘境开启灵石车队',
      description: '在阵法殿完成一次炼器委托 (需要携带特定道具；可选择和平或强硬解决)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_035',
      title: '押运·边关烽火台瘟疫矿脉样本',
      description: '护送炼器师穿越边关烽火台，避开蜃蚌妖 (夜间完成收益更高；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'mirage_clam',
      targetName: '蜃蚌妖',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_036',
      title: '镇压·海礁邪祟作乱灵石车队',
      description: '与海礁的商队头领交涉，化解误会追杀 (有隐藏分支对话；可能触发反转真凶)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_037',
      title: '押运·镜湖妖患古卷',
      description: '在炼器堂完成一次炼丹委托 (可能引来仇家；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_038',
      title: '谈判·秘境裂隙秘境开启封印钉',
      description: '清剿秘境裂隙的迷途雾，收集证据 (成功会提升势力好感；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '迷途雾',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_039',
      title: '护送·边关烽火台妖患丹炉',
      description: '与边关烽火台的散修首领交涉，化解矿脉纠纷 (可能引来仇家；可能触发反转真凶)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 4, // Scaling count
      difficulty: 4,
      reward: MissionReward(
        contribution: 40,
        exp: 80,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_040',
      title: '镇压·阵法殿瘟疫矿脉样本',
      description: '在炼器堂完成一次炼丹委托 (可能引来仇家；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_041',
      title: '救出·藏经阁盗窃药材',
      description: '清剿藏经阁的赤眼狼群，收集证据 (完成后解锁后续连环任务；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'red_eye_wolf',
      targetName: '赤眼狼群',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_042',
      title: '夺回·寒潭黑市交易被盗法器',
      description: '在炼丹堂完成一次布阵委托 (有隐藏分支对话；可能触发反转真凶)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_043',
      title: '追查·浮云台叛徒供香',
      description: '在浮云台调查封印松动并提交报告 (完成后解锁后续连环任务；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_044',
      title: '追查·灵泉谷叛徒阵旗',
      description: '与灵泉谷的外门执事交涉，化解债契争端 (可选择和平或强硬解决；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_045',
      title: '护法·边关烽火台妖患封印钉',
      description: '在边关烽火台调查失踪并提交报告 (完成后解锁后续连环任务；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_046',
      title: '护法·古墓入口盗窃宗门弟子',
      description: '缉拿古墓入口附近的黑刃刺客 (失败会留下因果标记；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_047',
      title: '夺回·秘境裂隙叛徒丹炉',
      description: '在炼丹堂完成一次炼丹委托 (成功会提升势力好感；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_048',
      title: '押运·断崖栈道走火封印钉',
      description: '押运阵材匣至断崖栈道，防劫 (可选择和平或强硬解决；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_049',
      title: '护送·青石镇盗窃宗门弟子',
      description: '护送掌柜穿越青石镇，避开规则倒刺 (有隐藏分支对话；需要携带特定道具)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 5, // Scaling count
      difficulty: 5,
      reward: MissionReward(
        contribution: 50,
        exp: 100,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_050',
      title: '镇压·灵泉谷封印松动供香',
      description: '缉拿灵泉谷附近的伪宗门使 (需要携带特定道具；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '伪宗门使',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_051',
      title: '救出·云水城失踪祭坛',
      description: '在阵法殿完成一次布阵委托 (可能触发反转真凶；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_052',
      title: '救出·灵泉谷走火矿脉样本',
      description: '在炼器堂完成一次炼丹委托 (成功会提升势力好感；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_053',
      title: '谈判·镜湖阵法失效钥匙',
      description: '与镜湖的炼器师交涉，化解误会追杀 (完成后解锁后续连环任务；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_054',
      title: '潜入·炼器堂阵法失效被盗法器',
      description: '缉拿炼器堂附近的炼尸道人 (夜间完成收益更高；可选择和平或强硬解决)',
      type: MissionType.collect,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: [
          'spirit_stone',
          'spirit_stone',
          'vitality_pill',
          'protection_talisman',
        ],
      ),
    ),
    const Mission(
      id: 'mission_055',
      title: '谈判·雾隐山道瘟疫钥匙',
      description: '在雾隐山道采集灵木芯并安全带回 (成功会提升势力好感；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'wood',
      targetName: '灵木芯',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_056',
      title: '夺回·海礁阵法失效阵旗',
      description: '清剿海礁的迷途雾，收集证据 (可能触发反转真凶；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '迷途雾',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_057',
      title: '镇压·雾隐山道走火封印钉',
      description: '清剿雾隐山道的血煞修，收集证据 (可能引来仇家；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_058',
      title: '清剿·落霞谷失踪阵旗',
      description: '在炼丹堂完成一次炼丹委托 (失败会留下因果标记；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_059',
      title: '潜入·阵法殿灵潮异常钥匙',
      description: '在阵法殿完成一次炼丹委托 (可能触发反转真凶；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 6, // Scaling count
      difficulty: 6,
      reward: MissionReward(
        contribution: 60,
        exp: 120,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_060',
      title: '救出·荒漠驿站瘟疫宗门弟子',
      description: '缉拿荒漠驿站附近的黑刃刺客 (可选择和平或强硬解决；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_061',
      title: '侦探·海礁邪祟作乱令牌',
      description: '缉拿海礁附近的炼尸道人 (失败会留下因果标记；需要携带特定道具)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_062',
      title: '夺回·秘境裂隙妖患被盗法器',
      description: '缉拿秘境裂隙附近的炼尸道人 (会增加天道注视；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_063',
      title: '护送·荒漠驿站阵法失效阵旗',
      description: '在炼丹堂完成一次布阵委托 (可能触发反转真凶；可能引来仇家)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_064',
      title: '镇压·阴槐村叛徒祭坛',
      description: '在炼丹堂完成一次炼器委托 (会增加天道注视；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_065',
      title: '修复·阵法殿走火钥匙',
      description: '在阵法殿调查黑市交易并提交报告 (失败会留下因果标记；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_066',
      title: '救出·赤焰洞封印松动封印钉',
      description: '护送掌柜穿越赤焰洞，避开规则倒刺 (需要携带特定道具；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_067',
      title: '勘测·青石镇盗窃封印钉',
      description: '镇压青石镇的鬼门并补齐封印 (可能触发反转真凶；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_068',
      title: '护法·葬骨坡盗窃钥匙',
      description: '在炼器堂完成一次炼器委托 (需要在限时内完成；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_069',
      title: '封印·封印古井灵潮异常宗门弟子',
      description: '押运药材箱至封印古井，防劫 (夜间完成收益更高；需要携带特定道具)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 7, // Scaling count
      difficulty: 7,
      reward: MissionReward(
        contribution: 70,
        exp: 140,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_070',
      title: '救出·望月坊市妖患令牌',
      description: '在望月坊市采集凝露草并安全带回 (可能引来仇家；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '凝露草',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_071',
      title: '夺回·赤焰洞叛徒古卷',
      description: '护送城主幕僚穿越赤焰洞，避开蛛王 (可能引来仇家；有隐藏分支对话)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_072',
      title: '追查·青石镇叛徒阵旗',
      description: '镇压青石镇的封印异动并补齐封印 (可能触发伏击；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_073',
      title: '清剿·秘境裂隙秘境开启宗门弟子',
      description: '在炼器堂完成一次炼丹委托 (成功会提升势力好感；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_074',
      title: '押运·海礁邪祟作乱古卷',
      description: '在阵法殿完成一次炼丹委托 (可能触发反转真凶；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_075',
      title: '护送·雾隐山道秘境开启药材',
      description: '进入雾隐山道旁的裂隙，带回封印符文 (夜间完成收益更高；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_076',
      title: '护法·宗门外门走火被盗法器',
      description: '清剿宗门外门的噬经蛊师，收集证据 (需要携带特定道具；有隐藏分支对话)',
      type: MissionType.hunt,
      targetId: 'gu_master',
      targetName: '噬经蛊师',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_077',
      title: '救出·灵泉谷阵法失效古卷',
      description: '护送阵师穿越灵泉谷，避开鬼面蜂 (可能触发伏击；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_078',
      title: '救出·黑风岭叛徒矿脉样本',
      description: '镇压黑风岭的封印异动并补齐封印 (夜间完成收益更高；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_079',
      title: '护送·内门药圃灵潮异常钥匙',
      description: '在炼器堂完成一次布阵委托 (会增加天道注视；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 8, // Scaling count
      difficulty: 8,
      reward: MissionReward(
        contribution: 80,
        exp: 160,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_080',
      title: '夺回·商队营地瘟疫封印钉',
      description: '在阵法殿完成一次布阵委托 (成功会提升势力好感；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_081',
      title: '护送·青石镇叛徒宗门弟子',
      description: '护送阵师穿越青石镇，避开煞雾团 (可能引来仇家；需要在限时内完成)',
      type: MissionType.hunt,
      targetId: 'plague_ghost',
      targetName: '煞雾团',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_082',
      title: '押运·商队营地黑市交易药材',
      description: '在炼丹堂完成一次布阵委托 (会增加天道注视；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_083',
      title: '护法·浮云台灵脉争夺令牌',
      description: '镇压浮云台的封印异动并补齐封印 (有隐藏分支对话；可能引来仇家)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_084',
      title: '护法·星砂滩盗窃矿脉样本',
      description: '在炼器堂完成一次炼器委托 (可选择和平或强硬解决；可能触发反转真凶)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_085',
      title: '镇压·雷原叛徒被盗法器',
      description: '为结丹护法一次，防铜人阵兵搅局 (可能引来仇家；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'bronze_soldier',
      targetName: '铜人阵兵',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_086',
      title: '修复·封印古井叛徒灵石车队',
      description: '缉拿封印古井附近的血契商人 (会增加天道注视；可能触发反转真凶)',
      type: MissionType.hunt,
      targetId: 'fake_envoy',
      targetName: '血契商人',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_087',
      title: '谈判·阴槐村走火阵旗',
      description: '镇压阴槐村的邪坛并补齐封印 (完成后解锁后续连环任务；可能引来仇家)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_088',
      title: '侦探·阵法殿盗窃药材',
      description: '在阵法殿采集朱砂并安全带回 (可能引来仇家；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'red_flame_flower',
      targetName: '朱砂',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_089',
      title: '清剿·黑风岭秘境开启丹炉',
      description: '镇压黑风岭的邪坛并补齐封印 (需要在限时内完成；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 9, // Scaling count
      difficulty: 9,
      reward: MissionReward(
        contribution: 90,
        exp: 180,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_090',
      title: '护送·阴槐村走火灵石车队',
      description: '护送外门执事穿越阴槐村，避开蛛王 (需要携带特定道具；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_091',
      title: '侦探·落霞谷邪祟作乱供香',
      description: '护送药圃管事穿越落霞谷，避开噬经蛊师 (有隐藏分支对话；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'gu_master',
      targetName: '噬经蛊师',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_092',
      title: '护法·内门药圃邪祟作乱祭坛',
      description: '缉拿内门药圃附近的伪宗门使 (可能引来仇家；需要携带特定道具)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '伪宗门使',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_093',
      title: '追查·雾隐山道秘境开启被盗法器',
      description: '缉拿雾隐山道附近的血契商人 (可能引来仇家；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '血契商人',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_094',
      title: '护法·寒潭妖患祭坛',
      description: '清剿寒潭的鬼面蜂，收集证据 (可能触发伏击；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_095',
      title: '护送·阵法殿盗窃药材',
      description: '清剿阵法殿的血煞修，收集证据 (可能触发反转真凶；可能引来仇家)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_096',
      title: '护法·望月坊市盗窃封印钉',
      description: '清剿望月坊市的规则倒刺，收集证据 (会增加天道注视；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_097',
      title: '护法·浮云台阵法失效宗门弟子',
      description: '缉拿浮云台附近的黑刃刺客 (可能触发伏击；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_098',
      title: '谈判·内门药圃灵潮异常灵石车队',
      description: '与内门药圃的炼器师交涉，化解误会追杀 (夜间完成收益更高；可能引来仇家)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_099',
      title: '采集·海礁秘境开启药材',
      description: '镇压海礁的邪坛并补齐封印 (需要携带特定道具；可能引来仇家)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 10, // Scaling count
      difficulty: 10,
      reward: MissionReward(
        contribution: 100,
        exp: 200,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_100',
      title: '护法·望月坊市阵法失效供香',
      description: '在望月坊市采集凝露草并安全带回 (成功会提升势力好感；可能引来仇家)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '凝露草',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_101',
      title: '封印·荒漠驿站灵潮异常祭坛',
      description: '护送巡夜官穿越荒漠驿站，避开铜人阵兵 (需要携带特定道具；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'bronze_soldier',
      targetName: '铜人阵兵',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_102',
      title: '护送·望月坊市叛徒钥匙',
      description: '镇压望月坊市的鬼门并补齐封印 (有隐藏分支对话；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_103',
      title: '护送·雷原盗窃矿脉样本',
      description: '护送掌柜穿越雷原，避开蛛王 (失败会留下因果标记；有隐藏分支对话)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_104',
      title: '镇压·阴槐村走火封印钉',
      description: '护送掌柜穿越阴槐村，避开蛛王 (成功会提升势力好感；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_105',
      title: '追查·雷原瘟疫祭坛',
      description: '清剿雷原的火蜥王，收集证据 (失败会留下因果标记；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'fire_lizard_king',
      targetName: '火蜥王',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_106',
      title: '追查·荒漠驿站瘟疫丹炉',
      description: '清剿荒漠驿站的时隙裂纹，收集证据 (可能引来仇家；失败会留下因果标记)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '时隙裂纹',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_107',
      title: '清剿·黑风岭阵法失效供香',
      description: '镇压黑风岭的封印异动并补齐封印 (可能引来仇家；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_108',
      title: '救出·浮云台走火阵旗',
      description: '在浮云台采集沉星铁并安全带回 (有隐藏分支对话；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'iron_ore',
      targetName: '沉星铁',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone'],
      ),
    ),
    const Mission(
      id: 'mission_109',
      title: '谈判·葬骨坡黑市交易被盗法器',
      description: '在葬骨坡调查灵潮异常并提交报告 (失败会留下因果标记；会增加天道注视)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 11, // Scaling count
      difficulty: 11,
      reward: MissionReward(
        contribution: 110,
        exp: 220,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_110',
      title: '侦探·浮云台封印松动阵旗',
      description: '清剿浮云台的灵潮涌动，收集证据 (可能触发反转真凶；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_111',
      title: '救出·阴槐村叛徒封印钉',
      description: '清剿阴槐村的迷途雾，收集证据 (可能触发伏击；可能引来仇家)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '迷途雾',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_112',
      title: '护送·秘境裂隙妖患令牌',
      description: '与秘境裂隙的阵师交涉，化解债契争端 (可选择和平或强硬解决；可能触发反转真凶)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_113',
      title: '镇压·海礁瘟疫被盗法器',
      description: '押运灵石箱至海礁，防劫 (会增加天道注视；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_114',
      title: '护送·断崖栈道灵脉争夺封印钉',
      description: '护送巡夜官穿越断崖栈道，避开蛛王 (失败会留下因果标记；可能触发伏击)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_115',
      title: '镇压·镜湖走火令牌',
      description: '在镜湖调查灵潮异常并提交报告 (可能触发伏击；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_116',
      title: '侦探·城主府走火令牌',
      description: '缉拿城主府附近的伪宗门使 (成功会提升势力好感；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '伪宗门使',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_117',
      title: '潜入·城主府叛徒矿脉样本',
      description: '护送掌柜穿越城主府，避开煞雾团 (需要携带特定道具；有隐藏分支对话)',
      type: MissionType.hunt,
      targetId: 'plague_ghost',
      targetName: '煞雾团',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_118',
      title: '谈判·藏经阁瘟疫被盗法器',
      description: '在炼丹堂完成一次炼器委托 (成功会提升势力好感；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_119',
      title: '谈判·寒潭失踪药材',
      description: '清剿寒潭的蜃蚌妖，收集证据 (可能引来仇家；需要在限时内完成)',
      type: MissionType.hunt,
      targetId: 'mirage_clam',
      targetName: '蜃蚌妖',
      targetCount: 12, // Scaling count
      difficulty: 12,
      reward: MissionReward(
        contribution: 120,
        exp: 240,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_120',
      title: '侦探·雷原瘟疫祭坛',
      description: '为破关护法一次，防石像守卫搅局 (完成后解锁后续连环任务；可能触发反转真凶)',
      type: MissionType.hunt,
      targetId: 'stone_guardian',
      targetName: '石像守卫',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_121',
      title: '潜入·望月坊市秘境开启矿脉样本',
      description: '进入望月坊市旁的裂隙，带回灵泉核 (会增加天道注视；失败会留下因果标记)',
      type: MissionType.collect,
      targetId: 'water_pearl',
      targetName: '灵泉核',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_122',
      title: '押运·海礁阵法失效药材',
      description: '在阵法殿完成一次布阵委托 (可选择和平或强硬解决；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_123',
      title: '勘测·海礁秘境开启丹炉',
      description: '清剿海礁的石像守卫，收集证据 (可能引来仇家；失败会留下因果标记)',
      type: MissionType.hunt,
      targetId: 'stone_guardian',
      targetName: '石像守卫',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_124',
      title: '潜入·赤焰洞灵潮异常灵石车队',
      description: '与赤焰洞的商队头领交涉，化解债契争端 (需要携带特定道具；可能引来仇家)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_125',
      title: '潜入·青石镇盗窃药材',
      description: '与青石镇的掌柜交涉，化解误会追杀 (可能触发反转真凶；失败会留下因果标记)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_126',
      title: '护法·荒漠驿站秘境开启封印钉',
      description: '与荒漠驿站的药圃管事交涉，化解误会追杀 (可能引来仇家；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_127',
      title: '护送·藏经阁阵法失效矿脉样本',
      description: '在藏经阁调查邪祟作乱并提交报告 (失败会留下因果标记；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_128',
      title: '侦探·封印古井走火丹炉',
      description: '为结丹护法一次，防蜃蚌妖搅局 (完成后解锁后续连环任务；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'mirage_clam',
      targetName: '蜃蚌妖',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_129',
      title: '勘测·古墓入口黑市交易祭坛',
      description: '在古墓入口调查盗窃并提交报告 (失败会留下因果标记；可能引来仇家)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 13, // Scaling count
      difficulty: 13,
      reward: MissionReward(
        contribution: 130,
        exp: 260,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_130',
      title: '护送·古墓入口灵潮异常灵石车队',
      description: '护送城主幕僚穿越古墓入口，避开裂翼蝠群 (可选择和平或强硬解决；需要在限时内完成)',
      type: MissionType.hunt,
      targetId: 'wind_vulture',
      targetName: '裂翼蝠群',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_131',
      title: '潜入·古墓入口失踪丹炉',
      description: '清剿古墓入口的时隙裂纹，收集证据 (失败会留下因果标记；需要在限时内完成)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '时隙裂纹',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_132',
      title: '潜入·宗门外门阵法失效古卷',
      description: '在炼丹堂完成一次布阵委托 (失败会留下因果标记；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_133',
      title: '护法·边关烽火台阵法失效灵石车队',
      description: '护送炼器师穿越边关烽火台，避开铜人阵兵 (成功会提升势力好感；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'bronze_soldier',
      targetName: '铜人阵兵',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_134',
      title: '追查·落霞谷失踪丹炉',
      description: '缉拿落霞谷附近的黑刃刺客 (会增加天道注视；可选择和平或强硬解决)',
      type: MissionType.hunt,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_135',
      title: '夺回·星砂滩叛徒矿脉样本',
      description: '在星砂滩调查秘境开启并提交报告 (可能触发反转真凶；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_136',
      title: '护送·藏经阁灵潮异常供香',
      description: '缉拿藏经阁附近的黑刃刺客 (可能触发反转真凶；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_137',
      title: '夺回·海礁瘟疫古卷',
      description: '在炼器堂完成一次炼丹委托 (可选择和平或强硬解决；成功会提升势力好感)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_138',
      title: '潜入·云水城盗窃阵旗',
      description: '为筑基护法一次，防角蜈蚣搅局 (成功会提升势力好感；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'poison_snake',
      targetName: '角蜈蚣',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_139',
      title: '镇压·云水城瘟疫宗门弟子',
      description: '在云水城采集寒髓兰并安全带回 (有隐藏分支对话；可选择和平或强硬解决)',
      type: MissionType.collect,
      targetId: 'cold_marrow_orchid',
      targetName: '寒髓兰',
      targetCount: 14, // Scaling count
      difficulty: 14,
      reward: MissionReward(
        contribution: 140,
        exp: 280,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_140',
      title: '修复·宗门外门瘟疫古卷',
      description: '在炼丹堂完成一次炼丹委托 (可能引来仇家；完成后解锁后续连环任务)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_141',
      title: '押运·浮云台邪祟作乱宗门弟子',
      description: '在浮云台调查失踪并提交报告 (完成后解锁后续连环任务；可能触发伏击)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_142',
      title: '护法·古墓入口秘境开启古卷',
      description: '为结丹护法一次，防赤眼狼群搅局 (可能触发伏击；完成后解锁后续连环任务)',
      type: MissionType.hunt,
      targetId: 'red_eye_wolf',
      targetName: '赤眼狼群',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_143',
      title: '护送·镜湖灵脉争夺灵石车队',
      description: '缉拿镜湖附近的炼尸道人 (可选择和平或强硬解决；需要携带特定道具)',
      type: MissionType.collect,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_144',
      title: '护法·海礁秘境开启药材',
      description: '缉拿海礁附近的伪宗门使 (成功会提升势力好感；可能触发伏击)',
      type: MissionType.hunt,
      targetId: 'fake_envoy',
      targetName: '伪宗门使',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_145',
      title: '潜入·葬骨坡封印松动矿脉样本',
      description: '护送游方道士穿越葬骨坡，避开角蜈蚣 (有隐藏分支对话；可能触发反转真凶)',
      type: MissionType.hunt,
      targetId: 'poison_snake',
      targetName: '角蜈蚣',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_146',
      title: '侦探·内门药圃走火宗门弟子',
      description: '护送商队头领穿越内门药圃，避开黑刃刺客 (可选择和平或强硬解决；需要在限时内完成)',
      type: MissionType.hunt,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_147',
      title: '谈判·内门药圃灵潮异常祭坛',
      description: '押运药材箱至内门药圃，防劫 (可能触发反转真凶；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_148',
      title: '夺回·雷原瘟疫钥匙',
      description: '在炼器堂完成一次炼丹委托 (夜间完成收益更高；有隐藏分支对话)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_149',
      title: '镇压·雷原阵法失效丹炉',
      description: '护送游方道士穿越雷原，避开火蜥王 (有隐藏分支对话；可能触发反转真凶)',
      type: MissionType.hunt,
      targetId: 'fire_lizard_king',
      targetName: '火蜥王',
      targetCount: 15, // Scaling count
      difficulty: 15,
      reward: MissionReward(
        contribution: 150,
        exp: 300,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_150',
      title: '救出·望月坊市走火被盗法器',
      description: '清剿望月坊市的火蜥王，收集证据 (可选择和平或强硬解决；可能触发伏击)',
      type: MissionType.hunt,
      targetId: 'fire_lizard_king',
      targetName: '火蜥王',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_151',
      title: '护送·炼器堂封印松动古卷',
      description: '护送掌柜穿越炼器堂，避开石像守卫 (可能引来仇家；需要携带特定道具)',
      type: MissionType.hunt,
      targetId: 'stone_guardian',
      targetName: '石像守卫',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_152',
      title: '护送·灵泉谷秘境开启祭坛',
      description: '与灵泉谷的游方道士交涉，化解矿脉纠纷 (有隐藏分支对话；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_153',
      title: '押运·黑风岭秘境开启阵旗',
      description: '为破关护法一次，防石像守卫搅局 (需要携带特定道具；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'stone_guardian',
      targetName: '石像守卫',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_154',
      title: '押运·内门药圃失踪宗门弟子',
      description: '在内门药圃采集蛛王丝囊并安全带回 (可能引来仇家；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'spider_sac',
      targetName: '蛛王丝囊',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_155',
      title: '封印·青石镇妖患供香',
      description: '为筑基护法一次，防蛛王搅局 (可能触发反转真凶；成功会提升势力好感)',
      type: MissionType.hunt,
      targetId: 'spider_king',
      targetName: '蛛王',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_156',
      title: '修复·望月坊市封印松动钥匙',
      description: '在望月坊市采集雷陨砂并安全带回 (完成后解锁后续连环任务；需要在限时内完成)',
      type: MissionType.collect,
      targetId: 'thunder_sand',
      targetName: '雷陨砂',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_157',
      title: '镇压·封印古井邪祟作乱供香',
      description: '与封印古井的掌柜交涉，化解矿脉纠纷 (完成后解锁后续连环任务；需要携带特定道具)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_158',
      title: '采集·炼器堂盗窃令牌',
      description: '护送商队头领穿越炼器堂，避开石像守卫 (失败会留下因果标记；夜间完成收益更高)',
      type: MissionType.hunt,
      targetId: 'stone_guardian',
      targetName: '石像守卫',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_159',
      title: '护送·赤焰洞叛徒钥匙',
      description: '在阵法殿完成一次布阵委托 (成功会提升势力好感；需要携带特定道具)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 16, // Scaling count
      difficulty: 16,
      reward: MissionReward(
        contribution: 160,
        exp: 320,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_160',
      title: '谈判·镜湖失踪阵旗',
      description: '镇压镜湖的封印异动并补齐封印 (可能触发伏击；会增加天道注视)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_161',
      title: '侦探·赤焰洞邪祟作乱丹炉',
      description: '与赤焰洞的外门执事交涉，化解矿脉纠纷 (失败会留下因果标记；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_162',
      title: '潜入·落霞谷黑市交易被盗法器',
      description: '进入落霞谷旁的裂隙，带回古钥匙 (有隐藏分支对话；夜间完成收益更高)',
      type: MissionType.collect,
      targetId: 'bronze_key',
      targetName: '古钥匙',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'protection_talisman'],
      ),
    ),
    const Mission(
      id: 'mission_163',
      title: '清剿·雷原灵潮异常灵石车队',
      description: '护送城主幕僚穿越雷原，避开蜃蚌妖 (需要携带特定道具；夜间完成收益更高；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'mirage_clam',
      targetName: '蜃蚌妖',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_164',
      title: '护送·雾隐山道封印松动药材',
      description: '缉拿雾隐山道附近的伪宗门使 (可能触发反转真凶；需要在限时内完成；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '伪宗门使',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_165',
      title: '护送·城主府瘟疫钥匙',
      description: '缉拿城主府附近的黑刃刺客 (夜间完成收益更高；可能引来仇家；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_166',
      title: '镇压·古战场邪祟作乱宗门弟子',
      description: '护送外门执事穿越古战场，避开鬼面蜂 (可选择和平或强硬解决；可能触发反转真凶；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_167',
      title: '侦探·灵泉谷瘟疫灵石车队',
      description: '为筑基护法一次，防裂翼蝠群搅局 (完成后解锁后续连环任务；需要携带特定道具；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'wind_vulture',
      targetName: '裂翼蝠群',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_168',
      title: '护送·寒潭灵潮异常封印钉',
      description: '清剿寒潭的规则倒刺，收集证据 (失败会留下因果标记；成功会提升势力好感；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_169',
      title: '镇压·城主府妖患令牌',
      description: '护送游方道士穿越城主府，避开鬼面蜂 (成功会提升势力好感；可能引来仇家；会触发势力战争支线)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 17, // Scaling count
      difficulty: 17,
      reward: MissionReward(
        contribution: 170,
        exp: 340,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_170',
      title: '采集·灵泉谷盗窃令牌',
      description: '护送掌柜穿越灵泉谷，避开铜人阵兵 (需要在限时内完成；可能引来仇家；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'bronze_soldier',
      targetName: '铜人阵兵',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_171',
      title: '潜入·内门药圃灵潮异常供香',
      description: '清剿内门药圃的时隙裂纹，收集证据 (可能触发伏击；失败会留下因果标记；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '时隙裂纹',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_172',
      title: '护送·断崖栈道黑市交易宗门弟子',
      description: '在炼丹堂完成一次炼丹委托 (需要在限时内完成；有隐藏分支对话；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_173',
      title: '护法·云水城灵脉争夺令牌',
      description: '进入云水城旁的裂隙，带回灵泉核 (需要在限时内完成；可能触发反转真凶；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'water_pearl',
      targetName: '灵泉核',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_174',
      title: '镇压·雷原阵法失效供香',
      description: '押运阵材匣至雷原，防劫 (需要在限时内完成；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_175',
      title: '潜入·浮云台盗窃丹炉',
      description: '缉拿浮云台附近的炼尸道人 (有隐藏分支对话；需要携带特定道具；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_176',
      title: '勘测·边关烽火台盗窃矿脉样本',
      description: '在边关烽火台调查秘境开启并提交报告 (可能触发反转真凶；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_177',
      title: '镇压·藏经阁妖患矿脉样本',
      description: '押运阵材匣至藏经阁，防劫 (成功会提升势力好感；夜间完成收益更高；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_178',
      title: '勘测·青石镇盗窃宗门弟子',
      description: '为结丹护法一次，防冤魂搅局 (会增加天道注视；可能触发反转真凶；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '冤魂',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_179',
      title: '谈判·望月坊市邪祟作乱灵石车队',
      description: '在望月坊市调查灵脉争夺并提交报告 (可选择和平或强硬解决；可能触发伏击；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 18, // Scaling count
      difficulty: 18,
      reward: MissionReward(
        contribution: 180,
        exp: 360,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_180',
      title: '侦探·商队营地秘境开启钥匙',
      description: '护送巡夜官穿越商队营地，避开裂翼蝠群 (可能触发反转真凶；需要携带特定道具；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'wind_vulture',
      targetName: '裂翼蝠群',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_181',
      title: '救出·云水城叛徒矿脉样本',
      description: '清剿云水城的血煞修，收集证据 (需要携带特定道具；可能引来仇家；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_182',
      title: '护法·古战场盗窃封印钉',
      description: '清剿古战场的煞雾团，收集证据 (需要在限时内完成；成功会提升势力好感；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'plague_ghost',
      targetName: '煞雾团',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_183',
      title: '谈判·海礁邪祟作乱钥匙',
      description: '清剿海礁的迷途雾，收集证据 (夜间完成收益更高；完成后解锁后续连环任务；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '迷途雾',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_184',
      title: '押运·城主府失踪矿脉样本',
      description: '在城主府调查黑市交易并提交报告 (有隐藏分支对话；可选择和平或强硬解决；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_185',
      title: '封印·望月坊市盗窃令牌',
      description: '与望月坊市的城主幕僚交涉，化解矿脉纠纷 (会增加天道注视；失败会留下因果标记；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_186',
      title: '追查·雷原封印松动祭坛',
      description: '在雷原采集寒髓兰并安全带回 (夜间完成收益更高；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'cold_marrow_orchid',
      targetName: '寒髓兰',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_187',
      title: '镇压·青石镇走火被盗法器',
      description: '在炼丹堂完成一次炼器委托 (可能触发伏击；可能引来仇家；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_188',
      title: '护送·荒漠驿站灵潮异常供香',
      description: '在荒漠驿站调查失踪并提交报告 (可能引来仇家；会增加天道注视；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_189',
      title: '谈判·黑风岭瘟疫丹炉',
      description: '缉拿黑风岭附近的血契商人 (夜间完成收益更高；成功会提升势力好感；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '血契商人',
      targetCount: 19, // Scaling count
      difficulty: 19,
      reward: MissionReward(
        contribution: 190,
        exp: 380,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_190',
      title: '护送·望月坊市灵潮异常供香',
      description: '清剿望月坊市的时隙裂纹，收集证据 (成功会提升势力好感；可选择和平或强硬解决；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '时隙裂纹',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_191',
      title: '侦探·阵法殿盗窃钥匙',
      description: '在炼器堂完成一次炼器委托 (会增加天道注视；需要携带特定道具；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_192',
      title: '采集·炼器堂黑市交易古卷',
      description: '进入炼器堂旁的裂隙，带回阵图残页 (夜间完成收益更高；失败会留下因果标记；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'talisman_paper_roll',
      targetName: '阵图残页',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_193',
      title: '押运·灵泉谷灵脉争夺药材',
      description: '押运灵石箱至灵泉谷，防劫 (会增加天道注视；成功会提升势力好感；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_194',
      title: '镇压·荒漠驿站妖患药材',
      description: '缉拿荒漠驿站附近的炼尸道人 (成功会提升势力好感；完成后解锁后续连环任务；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_195',
      title: '护送·阵法殿阵法失效宗门弟子',
      description: '清剿阵法殿的裂翼蝠群，收集证据 (可能触发反转真凶；失败会留下因果标记；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'wind_vulture',
      targetName: '裂翼蝠群',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_196',
      title: '追查·赤焰洞邪祟作乱阵旗',
      description: '与赤焰洞的炼器师交涉，化解误会追杀 (夜间完成收益更高；可选择和平或强硬解决；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_197',
      title: '修复·云水城盗窃古卷',
      description: '在炼器堂完成一次布阵委托 (可能引来仇家；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_198',
      title: '潜入·商队营地灵脉争夺令牌',
      description: '缉拿商队营地附近的血契商人 (失败会留下因果标记；可能触发反转真凶；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '血契商人',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_199',
      title: '采集·古墓入口灵脉争夺钥匙',
      description: '在阵法殿完成一次布阵委托 (完成后解锁后续连环任务；可选择和平或强硬解决；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 20, // Scaling count
      difficulty: 20,
      reward: MissionReward(
        contribution: 200,
        exp: 400,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_200',
      title: '采集·黑风岭叛徒矿脉样本',
      description: '护送游方道士穿越黑风岭，避开噬经蛊师 (需要携带特定道具；夜间完成收益更高；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'gu_master',
      targetName: '噬经蛊师',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_201',
      title: '夺回·灵泉谷失踪被盗法器',
      description: '清剿灵泉谷的火蜥王，收集证据 (夜间完成收益更高；可能引来仇家；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'fire_lizard_king',
      targetName: '火蜥王',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_202',
      title: '潜入·望月坊市叛徒祭坛',
      description: '护送巡夜官穿越望月坊市，避开尸傀 (需要携带特定道具；成功会提升势力好感；会触发势力战争支线)',
      type: MissionType.hunt,
      targetId: 'corpse_puppet',
      targetName: '尸傀',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_203',
      title: '采集·落霞谷瘟疫封印钉',
      description: '护送城主幕僚穿越落霞谷，避开火蜥王 (需要携带特定道具；可能触发伏击；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'fire_lizard_king',
      targetName: '火蜥王',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_204',
      title: '夺回·炼器堂叛徒古卷',
      description: '在炼器堂调查秘境开启并提交报告 (完成后解锁后续连环任务；可选择和平或强硬解决；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_205',
      title: '押运·断崖栈道瘟疫灵石车队',
      description: '押运药材箱至断崖栈道，防劫 (失败会留下因果标记；可选择和平或强硬解决；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_206',
      title: '押运·阴槐村灵脉争夺令牌',
      description: '缉拿阴槐村附近的炼尸道人 (可能触发反转真凶；失败会留下因果标记；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_207',
      title: '采集·落霞谷灵潮异常宗门弟子',
      description: '缉拿落霞谷附近的炼尸道人 (成功会提升势力好感；需要在限时内完成；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'corpse_refiner',
      targetName: '炼尸道人',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_208',
      title: '谈判·浮云台盗窃宗门弟子',
      description: '清剿浮云台的尸傀，收集证据 (可选择和平或强硬解决；会增加天道注视；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'corpse_puppet',
      targetName: '尸傀',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_209',
      title: '侦探·古墓入口瘟疫封印钉',
      description: '在炼器堂完成一次炼丹委托 (可选择和平或强硬解决；需要携带特定道具；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 21, // Scaling count
      difficulty: 21,
      reward: MissionReward(
        contribution: 210,
        exp: 420,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_210',
      title: '侦探·古墓入口秘境开启灵石车队',
      description: '清剿古墓入口的鬼面蜂，收集证据 (夜间完成收益更高；失败会留下因果标记；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'fire_bee_queen',
      targetName: '鬼面蜂',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_211',
      title: '救出·荒漠驿站秘境开启灵石车队',
      description: '缉拿荒漠驿站附近的黑刃刺客 (失败会留下因果标记；可能触发反转真凶；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'shadow_assassin',
      targetName: '黑刃刺客',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_212',
      title: '封印·落霞谷邪祟作乱宗门弟子',
      description: '为筑基护法一次，防石像守卫搅局 (有隐藏分支对话；可选择和平或强硬解决；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'stone_guardian',
      targetName: '石像守卫',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_213',
      title: '封印·寒潭叛徒被盗法器',
      description: '与寒潭的散修首领交涉，化解债契争端 (有隐藏分支对话；可能引来仇家；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_214',
      title: '谈判·落霞谷秘境开启祭坛',
      description: '在阵法殿完成一次布阵委托 (完成后解锁后续连环任务；需要携带特定道具；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_215',
      title: '镇压·寒潭秘境开启药材',
      description: '在寒潭调查失踪并提交报告 (成功会提升势力好感；需要携带特定道具；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_216',
      title: '救出·荒漠驿站秘境开启矿脉样本',
      description: '在阵法殿完成一次炼丹委托 (可选择和平或强硬解决；可能引来仇家；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_217',
      title: '护法·葬骨坡邪祟作乱封印钉',
      description: '与葬骨坡的游方道士交涉，化解矿脉纠纷 (可能触发反转真凶；可能触发伏击；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_218',
      title: '护送·雷原灵潮异常阵旗',
      description: '清剿雷原的蜃蚌妖，收集证据 (完成后解锁后续连环任务；需要在限时内完成；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'mirage_clam',
      targetName: '蜃蚌妖',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_219',
      title: '勘测·封印古井封印松动宗门弟子',
      description: '护送散修首领穿越封印古井，避开火蜥王 (有隐藏分支对话；需要在限时内完成；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'fire_lizard_king',
      targetName: '火蜥王',
      targetCount: 22, // Scaling count
      difficulty: 22,
      reward: MissionReward(
        contribution: 220,
        exp: 440,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_220',
      title: '押运·黑风岭灵潮异常阵旗',
      description: '清剿黑风岭的裂翼蝠群，收集证据 (可能触发伏击；可能引来仇家；会触发势力战争支线)',
      type: MissionType.hunt,
      targetId: 'wind_vulture',
      targetName: '裂翼蝠群',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_221',
      title: '封印·古战场叛徒供香',
      description: '缉拿古战场附近的血契商人 (失败会留下因果标记；可选择和平或强硬解决；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'fake_envoy',
      targetName: '血契商人',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_222',
      title: '谈判·商队营地灵潮异常药材',
      description: '镇压商队营地的鬼门并补齐封印 (失败会留下因果标记；会增加天道注视；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_223',
      title: '追查·云水城盗窃令牌',
      description: '为破关护法一次，防灵潮涌动搅局 (失败会留下因果标记；可能引来仇家；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_224',
      title: '护送·城主府封印松动宗门弟子',
      description: '在城主府采集蛛王丝囊并安全带回 (需要在限时内完成；夜间完成收益更高；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'spider_sac',
      targetName: '蛛王丝囊',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_225',
      title: '追查·星砂滩秘境开启祭坛',
      description: '护送散修首领穿越星砂滩，避开冤魂 (可能引来仇家；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '冤魂',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_226',
      title: '押运·荒漠驿站秘境开启矿脉样本',
      description: '清剿荒漠驿站的灵潮涌动，收集证据 (完成后解锁后续连环任务；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_227',
      title: '镇压·古墓入口黑市交易古卷',
      description: '为破关护法一次，防裂翼蝠群搅局 (可选择和平或强硬解决；夜间完成收益更高；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'wind_vulture',
      targetName: '裂翼蝠群',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_228',
      title: '追查·云水城妖患被盗法器',
      description: '护送散修首领穿越云水城，避开蜃蚌妖 (失败会留下因果标记；完成后解锁后续连环任务；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'mirage_clam',
      targetName: '蜃蚌妖',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_229',
      title: '镇压·断崖栈道妖患钥匙',
      description: '在断崖栈道调查盗窃并提交报告 (需要携带特定道具；需要在限时内完成；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 23, // Scaling count
      difficulty: 23,
      reward: MissionReward(
        contribution: 230,
        exp: 460,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_230',
      title: '谈判·阵法殿灵潮异常药材',
      description: '镇压阵法殿的鬼门并补齐封印 (有隐藏分支对话；夜间完成收益更高；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_231',
      title: '清剿·古墓入口秘境开启令牌',
      description: '与古墓入口的商队头领交涉，化解误会追杀 (会增加天道注视；可能触发伏击；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_232',
      title: '潜入·寒潭妖患矿脉样本',
      description: '镇压寒潭的鬼门并补齐封印 (可能触发反转真凶；有隐藏分支对话；可能引发天劫前兆)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_233',
      title: '镇压·海礁封印松动宗门弟子',
      description: '在海礁采集蛛王丝囊并安全带回 (会增加天道注视；夜间完成收益更高；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'spider_sac',
      targetName: '蛛王丝囊',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_234',
      title: '追查·城主府灵脉争夺宗门弟子',
      description: '镇压城主府的鬼门并补齐封印 (需要在限时内完成；成功会提升势力好感；会触发势力战争支线)',
      type: MissionType.hunt,
      targetId: 'boar',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_235',
      title: '封印·断崖栈道灵潮异常祭坛',
      description: '押运灵石箱至断崖栈道，防劫 (成功会提升势力好感；可能触发反转真凶；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_236',
      title: '护送·内门药圃瘟疫阵旗',
      description: '在炼器堂完成一次布阵委托 (会增加天道注视；可能引来仇家；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_237',
      title: '护送·阵法殿叛徒令牌',
      description: '在阵法殿完成一次炼丹委托 (可能引来仇家；可能触发反转真凶；可能引发天劫前兆)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_238',
      title: '潜入·商队营地叛徒封印钉',
      description: '押运药材箱至商队营地，防劫 (可能引来仇家；有隐藏分支对话；会触发势力战争支线)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_239',
      title: '押运·藏经阁灵脉争夺令牌',
      description: '清剿藏经阁的冤魂，收集证据 (可选择和平或强硬解决；可能引来仇家；失败会掉落随身物品)',
      type: MissionType.hunt,
      targetId: 'vengeful_spirit',
      targetName: '冤魂',
      targetCount: 24, // Scaling count
      difficulty: 24,
      reward: MissionReward(
        contribution: 240,
        exp: 480,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
      ),
    ),
    const Mission(
      id: 'mission_240',
      title: '护送·落霞谷秘境开启被盗法器',
      description: '在炼丹堂完成一次布阵委托 (可能触发伏击；成功会提升势力好感；失败会掉落随身物品)',
      type: MissionType.collect,
      targetId: 'dew_grass',
      targetName: '目标',
      targetCount: 25, // Scaling count
      difficulty: 25,
      reward: MissionReward(
        contribution: 250,
        exp: 500,
        itemIds: ['spirit_stone', 'spirit_stone', 'iron_ore'],
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
