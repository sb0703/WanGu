import '../models/npc.dart';
import '../models/stats.dart';

class NpcsRepository {
  static const Map<String, Npc> _npcs = {
    'village_chief': Npc(
      id: 'village_chief',
      name: '王村长',
      title: '凡人村长',
      description: '慈祥的老人，在这个危险的世界里勉力维持着村庄的生存。',
      stats: Stats(
        maxHp: 50,
        hp: 50,
        maxSpirit: 0,
        spirit: 0,
        attack: 5,
        defense: 2,
        speed: 3,
        insight: 10,
      ),
      dialogues: [
        '年轻人，外面的世界很危险，多加小心啊。',
        '最近村子附近的野兽越来越多了...',
        '如果你能帮我们清理一下附近的野兽就好了。',
      ],
    ),
    'sect_elder': Npc(
      id: 'sect_elder',
      name: '李长老',
      title: '外门长老',
      description: '宗门的外门长老，负责指导新入门的弟子。',
      stats: Stats(
        maxHp: 500,
        hp: 500,
        maxSpirit: 200,
        spirit: 200,
        attack: 80,
        defense: 40,
        speed: 30,
        insight: 50,
      ),
      dialogues: [
        '修仙之路，逆天而行，切记不可懈怠。',
        '你的资质尚可，但还需勤加修炼。',
        '若有不懂之处，可去藏经阁查阅。',
      ],
    ),
    'traveling_merchant': Npc(
      id: 'traveling_merchant',
      name: '游方商人',
      title: '神秘商人',
      description: '行踪不定的商人，据说手里有不少好东西。',
      stats: Stats(
        maxHp: 200,
        hp: 200,
        maxSpirit: 50,
        spirit: 50,
        attack: 20,
        defense: 10,
        speed: 20,
        insight: 80,
      ),
      dialogues: [
        '走过路过不要错过，看看我的宝贝？',
        '只要你有灵石，什么都好说。',
        '最近生意不好做啊...',
      ],
    ),
  };

  static Npc? get(String id) => _npcs[id];
  
  static List<Npc> getAll() => _npcs.values.toList();
}
