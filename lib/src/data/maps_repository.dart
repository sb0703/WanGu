import '../models/map_node.dart';

class MapsRepository {
  static List<MapNode> getAll() {
    return const [
      MapNode(
        id: 'sect',
        name: '宗门后山',
        description: '安全区，灵气稀薄，可打坐修炼',
        danger: 1,
        npcIds: ['sect_elder'],
      ),
      MapNode(
        id: 'bamboo',
        name: '青竹林',
        description: '常见野兽出没，偶有灵草',
        danger: 2,
        npcIds: ['village_chief'],
      ),
      MapNode(
        id: 'stream',
        name: '溪谷',
        description: '水源地，有些水生妖兽',
        danger: 3,
        npcIds: ['traveling_merchant'],
      ),
      MapNode(
        id: 'cave',
        name: '阴风洞',
        description: '阴冷潮湿，蝙蝠成群',
        danger: 5,
        npcIds: [],
      ),
      MapNode(
        id: 'mountain',
        name: '落霞峰',
        description: '山势陡峭，灵气充裕',
        danger: 7,
        npcIds: [],
      ),
      MapNode(
        id: 'ruin',
        name: '上古遗迹',
        description: '危险与机遇并存的禁地',
        danger: 9,
        npcIds: [],
      ),
    ];
  }
}
