import 'dart:math';
import '../models/npc.dart';
import '../models/stats.dart';

/// NPC 随机生成器
class NpcGenerator {
  static final Random _rng = Random();

  /// 姓氏库
  static const List<String> _surnames = [
    '赵', '钱', '孙', '李', '周', '吴', '郑', '王',
    '冯', '陈', '褚', '卫', '蒋', '沈', '韩', '杨',
    '朱', '秦', '尤', '许', '何', '吕', '施', '张',
    '孔', '曹', '严', '华', '金', '魏', '陶', '姜',
    '戚', '谢', '邹', '喻', '柏', '水', '窦', '章',
    '云', '苏', '潘', '葛', '奚', '范', '彭', '郎',
    '鲁', '韦', '昌', '马', '苗', '凤', '花', '方',
    '俞', '任', '袁', '柳', '酆', '鲍', '史', '唐',
    '费', '廉', '岑', '薛', '雷', '贺', '倪', '汤',
    '滕', '殷', '罗', '毕', '郝', '邬', '安', '常',
    '乐', '于', '时', '傅', '皮', '卞', '齐', '康',
    '伍', '余', '元', '卜', '顾', '孟', '平', '黄',
    // 复姓/玄幻姓
    '独孤', '慕容', '轩辕', '欧阳', '上官', '令狐', '诸葛', '司马',
    '公孙', '皇甫', '南宫', '百里', '东郭', '西门', '北宫',
  ];

  /// 男名库 (偏硬朗/玄幻)
  static const List<String> _maleNames = [
    '凡', '尘', '风', '云', '霸', '天', '墨', '渊',
    '炎', '雷', '霆', '霄', '玄', '真', '道', '极',
    '锋', '剑', '狂', '傲', '绝', '灭', '生', '死',
    '修', '罗', '战', '神', '圣', '尊', '帝', '皇',
    '龙', '虎', '豹', '鹤', '鹏', '鲲', '鹏', '麟',
    '山', '海', '河', '川', '岳', '峰', '林', '森',
    '金', '木', '水', '火', '土', '阳', '阴', '虚',
  ];

  /// 女名库 (偏唯美)
  static const List<String> _femaleNames = [
    '灵', '儿', '雪', '月', '瑶', '姬', '紫', '烟',
    '雨', '霜', '露', '霞', '云', '霓', '裳', '衣',
    '梦', '幻', '幽', '兰', '竹', '菊', '梅', '莲',
    '琴', '棋', '书', '画', '诗', '词', '歌', '舞',
    '仙', '神', '圣', '洁', '纯', '真', '善', '美',
    '柔', '情', '丝', '缕', '心', '意', '念', '思',
  ];

  /// 道号中缀
  static const List<String> _daoTitleMiddle = [
    '青木', '血手', '凌云', '逍遥', '无极', '太上', '玄微', '清虚',
    '烈火', '寒冰', '紫电', '狂风', '巨力', '神行', '百变', '千面',
  ];

  /// 道号后缀
  static const List<String> _daoTitleSuffix = [
    '散人', '居士', '真人', '上人', '真君', '老祖', '尊者', '大圣',
  ];

  // --- Description Components ---
  static const List<String> _bodyTypes = [
    '身材魁梧的', '瘦骨嶙峋的', '大腹便便的', '身姿曼妙的', '身形修长的',
    '五短身材的', '体格健壮的', '弱不禁风的', '高大威猛的', '娇小玲珑的',
  ];

  static const List<String> _clothingTypes = [
    '身穿青云宗道袍', '披着破旧麻衣', '身披兽皮战甲', '锦衣华服', '一袭白衣胜雪',
    '身着黑袍', '衣衫褴褛', '珠光宝气', '一身劲装', '道骨仙风',
  ];

  static const List<String> _faceFeatures = [
    '剑眉星目', '贼眉鼠眼', '面若桃花', '独眼龙', '满脸横肉',
    '慈眉善目', '面容清秀', '神情呆滞', '目光如炬', '嘴角含笑',
  ];

  static const List<String> _auras = [
    '周身散发着寒气', '眼神阴鸷', '笑眯眯的', '一脸正气', '杀气腾腾',
    '仙气飘飘', '暮气沉沉', '锋芒毕露', '深不可测', '平平无奇',
  ];

  // --- Archetypes ---
  // Unused field warning fixed by using string literals directly in generate logic or keeping list if intended for expansion.
  // For now, removing the list as logic uses string literals.
  
  /// Generate a random NPC
  static Npc generate({
    required int stageIndex, // 0: Qi Refinement, 1: Foundation, etc.
    String? archetype,
    String? mapType, // Optional context
  }) {
    // 1. Roll Archetype if not provided
    if (archetype == null) {
      final roll = _rng.nextDouble();
      if (roll < 0.05) {
        archetype = 'Young_Master';
      } else if (roll < 0.06) {
        // Very rare for Hidden Expert
        archetype = 'Hidden_Expert';
      } else if (roll < 0.10) {
        archetype = 'Trash';
      } else if (roll < 0.15) {
        archetype = 'Hunter';
      } else {
        archetype = 'Common_Cultivator';
      }
    }

    // 2. Generate Basic Info (Appearance)
    final isMale = _rng.nextBool();
    String name = _generateName(isMale);
    String title = '';
    
    // Dao Title for higher realms (Stage 2: Golden Core+)
    if (stageIndex >= 2 || archetype == 'Hidden_Expert') {
      title = _generateDaoTitle();
    } else {
      title = isMale ? '散修' : '女修';
    }

    String description = _generateDescription(archetype, isMale);
    List<String> tags = _generateTags(archetype);

    // 3. Generate Stats
    Stats stats;
    String displayRealm = _getRealmName(stageIndex);
    
    if (archetype == 'Hidden_Expert') {
      // Disguised: Looks weak (Qi Refinement), actually strong (Nascent Soul+)
      displayRealm = '炼气期'; // Fake display
      // Real stats are much higher (e.g., Stage 4+)
      stats = _generateStats(4 + _rng.nextInt(2)); 
    } else if (archetype == 'Trash') {
      // Trash usually has lower realm than expected or weak stats
      stats = _generateStats(stageIndex, multiplier: 0.8);
    } else if (archetype == 'Young_Master') {
      // Average stats, maybe slightly boosted by resources
      stats = _generateStats(stageIndex, multiplier: 1.1);
    } else {
      stats = _generateStats(stageIndex);
    }

    // 4. Dialogues
    List<String> dialogues = _generateDialogues(archetype);

    // 5. Create NPC
    return Npc(
      id: 'gen_${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(1000)}',
      name: name,
      title: title,
      description: description,
      stats: stats,
      dialogues: dialogues,
      tags: tags,
      displayRealm: displayRealm,
      isMobile: true, // Generated NPCs are usually wanderers
      friendship: 50,
    );
  }

  static String _generateName(bool isMale) {
    final surname = _surnames[_rng.nextInt(_surnames.length)];
    final namePool = isMale ? _maleNames : _femaleNames;
    String name = namePool[_rng.nextInt(namePool.length)];
    if (_rng.nextBool()) {
      // Double character name
      name += namePool[_rng.nextInt(namePool.length)];
    }
    return '$surname$name';
  }

  static String _generateDaoTitle() {
    final middle = _daoTitleMiddle[_rng.nextInt(_daoTitleMiddle.length)];
    final suffix = _daoTitleSuffix[_rng.nextInt(_daoTitleSuffix.length)];
    return '$middle$suffix';
  }

  static String _generateDescription(String archetype, bool isMale) {
    if (archetype == 'Hidden_Expert') {
      return '一个看似平平无奇的老者，手里拿着一串糖葫芦，但眼神深邃，仿佛能看穿一切。';
    }
    
    final body = _bodyTypes[_rng.nextInt(_bodyTypes.length)];
    final clothing = _clothingTypes[_rng.nextInt(_clothingTypes.length)];
    final face = _faceFeatures[_rng.nextInt(_faceFeatures.length)];
    final aura = _auras[_rng.nextInt(_auras.length)];
    
    return '一个$body${isMale ? '修士' : '女修'}，$clothing，$face，$aura。';
  }

  static Stats _generateStats(int stageIndex, {double multiplier = 1.0}) {
    // Base scaling roughly follows: 10 * 2^stageIndex
    // 0: Qi Refinement (~10-20)
    // 1: Foundation (~40-80)
    // 2: Golden Core (~160-300)
    // ...
    double scale = pow(2.5, stageIndex).toDouble() * multiplier;
    
    // Variance
    double v() => 0.8 + _rng.nextDouble() * 0.4;

    return Stats(
      maxHp: (100 * scale * v()).toInt(),
      hp: (100 * scale * v()).toInt(),
      maxSpirit: (50 * scale * v()).toInt(),
      spirit: (50 * scale * v()).toInt(),
      attack: (10 * scale * v()).toInt(),
      defense: (5 * scale * v()).toInt(),
      speed: (10 * scale * v()).toInt(),
      insight: (10 * v()).toInt(),
      purity: 100, // NPCs usually assumed full or irrelevant
    );
  }

  static List<String> _generateTags(String archetype) {
    switch (archetype) {
      case 'Young_Master':
        return ['Arrogant', 'Rich', 'Has_Parent', 'Rash'];
      case 'Trash':
        return ['Tenacious', 'Poor', 'Protagonist_Aura_Maybe'];
      case 'Hidden_Expert':
        return ['Mysterious', 'Powerful', 'Neutral'];
      case 'Hunter':
        return ['Demonic', 'Cruel', 'Rich_Loot'];
      default:
        // Random personality
        List<String> tags = [];
        if (_rng.nextBool()) tags.add(_rng.nextBool() ? 'Righteous' : 'Demonic');
        if (_rng.nextBool()) tags.add(_rng.nextBool() ? 'Cautious' : 'Rash');
        return tags;
    }
  }

  static List<String> _generateDialogues(String archetype) {
    switch (archetype) {
      case 'Young_Master':
        return [
          '你知道我爹是谁吗？',
          '滚开，好狗不挡道！',
          '这东西本少爷看上了，识相的就赶紧滚！',
        ];
      case 'Trash':
        return [
          '三十年河东，三十年河西，莫欺少年穷！',
          '今日之辱，他日必百倍奉还！',
          '只要我不死，终有出头之日。',
        ];
      case 'Hidden_Expert':
        return [
          '年轻人，我看你骨骼惊奇...',
          '相逢即是有缘，这本秘籍五块灵石卖你了。',
          '大道至简，返璞归真。',
        ];
      case 'Hunter':
        return [
          '桀桀桀，又来一个送死的。',
          '交出储物袋，留你全尸！',
          '你的血肉正好用来祭炼我的法宝。',
        ];
      default:
        return [
          '这位道友，有礼了。',
          '修仙路漫漫，吾等当上下求索。',
          '最近这附近不太平啊。',
        ];
    }
  }

  static String _getRealmName(int index) {
    const realms = ['炼气期', '筑基期', '金丹期', '元婴期', '化神期', '炼虚期', '合体期', '大乘期', '渡劫期'];
    if (index >= 0 && index < realms.length) return realms[index];
    return '未知境界';
  }
}
