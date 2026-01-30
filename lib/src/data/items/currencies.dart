import '../../models/item.dart';

const Map<String, Item> currencyItems = {
  'broken_silver': Item(
    id: 'broken_silver',
    name: '碎银',
    description: '凡俗通用货币，用于路引、酒馆、官府打点。',
    type: ItemType.other,
    price: 1,
  ),
  'copper_coins': Item(
    id: 'copper_coins',
    name: '铜钱串',
    description: '小额交易与施舍，影响凡俗声望。',
    type: ItemType.other,
    price: 1,
  ),
  'gold_ingot': Item(
    id: 'gold_ingot',
    name: '金锭',
    description: '大额交易，常用于贿赂或买命。',
    type: ItemType.other,
    price: 100,
  ),
  'jade_coin': Item(
    id: 'jade_coin',
    name: '玉币',
    description: '世家流通，能换到稀缺情报。',
    type: ItemType.other,
    price: 50,
  ),
  'spirit_stone': Item(
    id: 'spirit_stone',
    name: '灵石',
    description: '修士硬通货，可回灵、布阵、炼器。',
    type: ItemType.other,
    spiritBonus: 5,
    price: 10,
  ),
  'spirit_stone_low': Item(
    id: 'spirit_stone_low',
    name: '下品灵石',
    description: '灵气杂，适合日常消耗。',
    type: ItemType.other,
    spiritBonus: 2,
    price: 5,
  ),
  'spirit_stone_med': Item(
    id: 'spirit_stone_med',
    name: '中品灵石',
    description: '可做阵眼，常见于宗门赏赐。',
    type: ItemType.other,
    spiritBonus: 20,
    price: 50,
  ),
  'spirit_stone_high': Item(
    id: 'spirit_stone_high',
    name: '上品灵石',
    description: '灵气纯，突破前常被囤积。',
    type: ItemType.other,
    spiritBonus: 100,
    price: 200,
  ),
  'merit_token': Item(
    id: 'merit_token',
    name: '功勋令',
    description: '宗门任务结算凭证，可兑换资源与地位。',
    type: ItemType.other,
    price: 0, // Special currency
  ),
  'secret_scroll': Item(
    id: 'secret_scroll',
    name: '秘闻札',
    description: '记录传闻线索，开启事件分支与隐藏地点。',
    type: ItemType.other,
    price: 50,
  ),
};
