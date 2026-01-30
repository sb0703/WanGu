import '../../models/item.dart';

const Map<String, Item> containerItems = {
  // T0｜凡俗便携（Lv.1–5）
  'cloth_bag': Item(
    id: 'cloth_bag',
    name: '粗布行囊',
    description: '便宜耐用，适合新手跑图。遇雨易受潮。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount, // Back -> Mount
    levelReq: 1,
    spaceBonus: 10, // M
    price: 5,
  ),
  'waxed_herb_pouch': Item(
    id: 'waxed_herb_pouch',
    name: '油蜡药囊',
    description: '防潮，丹药/灵草保鲜更久。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Waist -> Accessory
    levelReq: 1,
    spaceBonus: 5, // S
    price: 10,
  ),
  'hidden_pouch': Item(
    id: 'hidden_pouch',
    name: '暗格腰包',
    description: '降低被搜出概率。容量极小。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Waist -> Accessory
    levelReq: 2,
    spaceBonus: 5, // S
    price: 20,
  ),
  'leather_quiver': Item(
    id: 'leather_quiver',
    name: '皮革箭囊',
    description: '存放箭矢/符筒更方便。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount, // Back -> Mount
    levelReq: 3,
    spaceBonus: 5, // S
    price: 15,
  ),
  'bamboo_food_box': Item(
    id: 'bamboo_food_box',
    name: '竹编食匣',
    description: '辟谷前过渡：干粮不易坏。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount, // Back -> Mount
    levelReq: 4,
    spaceBonus: 5, // S
    price: 12,
  ),
  'iron_clasp_purse': Item(
    id: 'iron_clasp_purse',
    name: '铁扣钱袋',
    description: '防偷盗。重量增加，赶路更耗体力。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Waist -> Accessory
    levelReq: 5,
    spaceBonus: 5, // S
    price: 25,
  ),

  // T1｜入门储物（Lv.6–12）
  'beast_skin_bag': Item(
    id: 'beast_skin_bag',
    name: '兽皮行囊',
    description: '耐磨，野外翻滚不易破。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 6,
    spaceBonus: 10, // M
    price: 50,
  ),
  'talisman_pouch': Item(
    id: 'talisman_pouch',
    name: '防潮符袋',
    description: '符纸不散灵。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 7,
    spaceBonus: 5, // S
    price: 60,
  ),
  'layered_herb_box': Item(
    id: 'layered_herb_box',
    name: '双层药匣',
    description: '药材分层，减少“串味变质”。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 8,
    spaceBonus: 10, // M
    price: 80,
  ),
  'lightweight_bag': Item(
    id: 'lightweight_bag',
    name: '轻身布囊',
    description: '减轻背负惩罚。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 10,
    spaceBonus: 10, // M
    price: 100,
  ),
  'material_pack': Item(
    id: 'material_pack',
    name: '锁扣材料包',
    description: '材料分类，炼器/炼丹事件更顺。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 11,
    spaceBonus: 10, // M
    price: 120,
  ),
  'merchant_sealed_box': Item(
    id: 'merchant_sealed_box',
    name: '旅商密封箱',
    description: '减少“战利品被雨坏/丢失”。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 12,
    spaceBonus: 20, // L
    price: 150,
  ),

  // T2｜灵修常备（Lv.13–20）
  'storage_bag_basic': Item(
    id: 'storage_bag_basic',
    name: '低阶储物袋·青纹',
    description: '初代空间袋，可装常规法器/材料。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 13,
    spaceBonus: 20, // L
    price: 300,
  ),
  'storage_bag_stealth': Item(
    id: 'storage_bag_stealth',
    name: '低阶储物袋·墨纹',
    description: '自带隐息纹，减少被搜到概率。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 14,
    spaceBonus: 20, // L
    price: 400,
  ),
  'waist_storage_pouch': Item(
    id: 'waist_storage_pouch',
    name: '腰挂储物囊·双扣',
    description: '取物更快。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 15,
    spaceBonus: 10, // M
    price: 350,
  ),
  'jade_fish_pendant': Item(
    id: 'jade_fish_pendant',
    name: '佩饰储物坠·玉鱼',
    description: '小容量但更安全。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 16,
    spaceBonus: 5, // S
    price: 500,
  ),
  'talisman_box_hundred': Item(
    id: 'talisman_box_hundred',
    name: '符匣·百符格',
    description: '符箓自动分格。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 18,
    spaceBonus: 10, // M
    price: 450,
  ),
  'cold_spring_herb_box': Item(
    id: 'cold_spring_herb_box',
    name: '灵药匣·冷泉纹',
    description: '药材保鲜显著提升。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 20,
    spaceBonus: 10, // M
    price: 600,
  ),

  // T3｜筑基/宗门任务级（Lv.21–30）
  'storage_bag_medium': Item(
    id: 'storage_bag_medium',
    name: '中阶储物袋·三叠纹',
    description: '适合秘境扫荡，装载上限更高。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 21,
    spaceBonus: 50, // XL
    price: 1000,
  ),
  'storage_bag_reinforced': Item(
    id: 'storage_bag_reinforced',
    name: '中阶储物袋·止血绳扣',
    description: '自带防撕裂结构，战斗不易破。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 22,
    spaceBonus: 50, // XL
    price: 1200,
  ),
  'quick_draw_waist_pouch': Item(
    id: 'quick_draw_waist_pouch',
    name: '乾坤腰囊·快取式',
    description: '快取：每年/每战首次取物免费。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 24,
    spaceBonus: 20, // L
    price: 900,
  ),
  'array_material_box': Item(
    id: 'array_material_box',
    name: '阵材匣·四象分栏',
    description: '阵旗/阵钉/阵线分类，布阵更稳。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 25,
    spaceBonus: 20, // L
    price: 800,
  ),
  'portable_furnace_box': Item(
    id: 'portable_furnace_box',
    name: '炼丹行炉箱·稳火锁',
    description: '带炉具与药格，路上也能炼。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 27,
    spaceBonus: 20, // L
    price: 1500,
  ),
  'soul_lock_pendant': Item(
    id: 'soul_lock_pendant',
    name: '护命储物佩·锁魂扣',
    description: '被夺舍/摄魂时袋口自动封闭。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 30,
    spaceBonus: 10, // M
    price: 2000,
  ),

  // T4｜金丹期行囊（Lv.31–40）
  'storage_bag_high': Item(
    id: 'storage_bag_high',
    name: '高阶储物袋·云纹',
    description: '自带减重纹，携重物不拖速。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 31,
    spaceBonus: 50, // XL
    price: 3000,
  ),
  'storage_bag_heavy': Item(
    id: 'storage_bag_heavy',
    name: '高阶储物袋·沉星纹',
    description: '可装“重器/沉物”，稳固不晃。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 33,
    spaceBonus: 50, // XL
    price: 3500,
  ),
  'storage_ring_basic': Item(
    id: 'storage_ring_basic',
    name: '纳戒·空灵石芯',
    description: '戒指位储物，潜入更安全。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Hand -> Accessory
    levelReq: 34,
    spaceBonus: 10, // M
    price: 4000,
  ),
  'storage_ring_secure': Item(
    id: 'storage_ring_secure',
    name: '纳戒·双锁口',
    description: '双重开口术式，防偷盗与夺宝。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Hand -> Accessory
    levelReq: 36,
    spaceBonus: 20, // L
    price: 5000,
  ),
  'camp_box': Item(
    id: 'camp_box',
    name: '乾坤箱·一炷香展开',
    description: '展开成临时库房。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 38,
    spaceBonus: 50, // XL
    price: 4500,
  ),
  'shadow_pendant': Item(
    id: 'shadow_pendant',
    name: '佩饰·万象匣',
    description: '可伪装成普通饰品，隐匿性强。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 40,
    spaceBonus: 10, // M
    price: 5500,
  ),

  // T5｜元婴/高阶游历（Lv.41–50）
  'storage_bag_huge': Item(
    id: 'storage_bag_huge',
    name: '大型储物袋·九宫纹',
    description: '九宫分区，自动归类。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 41,
    spaceBonus: 50, // XL
    price: 8000,
  ),
  'storage_bag_thunder': Item(
    id: 'storage_bag_thunder',
    name: '大型储物袋·封雷口',
    description: '雷域不易散灵，符匣更稳。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 43,
    spaceBonus: 50, // XL
    price: 9000,
  ),
  'storage_ring_instant': Item(
    id: 'storage_ring_instant',
    name: '纳戒·瞬开式',
    description: '取物几乎不耗回合，战斗体验爽。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Hand -> Accessory
    levelReq: 44,
    spaceBonus: 20, // L
    price: 10000,
  ),
  'ring_resonance': Item(
    id: 'ring_resonance',
    name: '指环·共鸣匣',
    description: '与法器共鸣：切换武器更顺。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Hand -> Accessory
    levelReq: 46,
    spaceBonus: 10, // M
    price: 11000,
  ),
  'karma_pendant': Item(
    id: 'karma_pendant',
    name: '护身佩·因果扣',
    description: '夺宝时可“标记仇家气机”。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory,
    levelReq: 48,
    spaceBonus: 10, // M
    price: 12000,
  ),
  'ship_bag': Item(
    id: 'ship_bag',
    name: '乾坤舟囊·折舟式',
    description: '可收纳小型飞舟/机关兽。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 50,
    spaceBonus: 50, // XL
    price: 15000,
  ),

  // T6｜化神/合道边缘（Lv.51–60）
  'tao_bag': Item(
    id: 'tao_bag',
    name: '道纹储物袋·无漏',
    description: '“无漏”：极难被探查与偷盗。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 51,
    spaceBonus: 50, // XL
    price: 20000,
  ),
  'mind_ring': Item(
    id: 'mind_ring',
    name: '纳戒·一念开合',
    description: '意念取放，几乎无动作成本。',
    type: ItemType.equipment,
    slot: EquipmentSlot.accessory, // Hand -> Accessory
    levelReq: 53,
    spaceBonus: 20, // L
    price: 25000,
  ),
  'void_box': Item(
    id: 'void_box',
    name: '虚空匣·折叠洞府',
    description: '随身携带小洞府，可暂避风头。',
    type: ItemType.equipment,
    slot: EquipmentSlot.mount,
    levelReq: 55,
    spaceBonus: 50, // XL
    price: 30000,
  ),
};
