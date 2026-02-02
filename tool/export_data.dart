import 'dart:convert';
import 'dart:io';

import 'package:wanggu_flutter/src/data/buffs_repository.dart';
import 'package:wanggu_flutter/src/data/drop_tables.dart';
import 'package:wanggu_flutter/src/data/enemies_repository.dart';
import 'package:wanggu_flutter/src/data/items_repository.dart';
import 'package:wanggu_flutter/src/data/maps_repository.dart';
import 'package:wanggu_flutter/src/data/missions_repository.dart';
import 'package:wanggu_flutter/src/data/traits_repository.dart';
import 'package:wanggu_flutter/src/models/buff.dart';
import 'package:wanggu_flutter/src/models/enemy.dart';
import 'package:wanggu_flutter/src/models/item.dart';
import 'package:wanggu_flutter/src/models/map_node.dart';
import 'package:wanggu_flutter/src/models/mission.dart';
import 'package:wanggu_flutter/src/models/realm_stage.dart';
import 'package:wanggu_flutter/src/models/stats.dart';
import 'package:wanggu_flutter/src/models/trait.dart';

void main(List<String> args) async {
  final outputDir = Directory(
    args.isNotEmpty ? args.first : '../WanGu_Server/src/main/resources/data',
  );
  await outputDir.create(recursive: true);

  _writeJson(outputDir, 'items.json', ItemsRepository.getAll().map(_itemToMap));
  _writeJson(
    outputDir,
    'enemies.json',
    EnemiesRepository.getAll().map(_enemyToMap),
  );
  _writeJson(outputDir, 'maps.json', MapsRepository.getAll().map(_mapToMap));
  _writeJson(
    outputDir,
    'missions.json',
    MissionsRepository.missions.map(_missionToMap),
  );
  _writeJson(outputDir, 'buffs.json', BuffsRepository.getAll().map(_buffToMap));
  _writeJson(
    outputDir,
    'realm_stages.json',
    RealmStage.stages.asMap().entries.map(_realmEntryToMap),
  );
  _writeJson(outputDir, 'drop_tables.json', _dropTablesToMap());
  _writeJson(outputDir, 'npcs.json', _manualNpcs.map(_npcToMap));
  _writeJson(
    outputDir,
    'traits.json',
    TraitsRepository.getAll().map(_traitToMap),
  );

  stdout.writeln('Export completed to ${outputDir.path}');
}

Map<String, dynamic> _statsToMap(Stats s) => {
  'maxHp': s.maxHp,
  'hp': s.hp,
  'maxSpirit': s.maxSpirit,
  'spirit': s.spirit,
  'attack': s.attack,
  'defense': s.defense,
  'speed': s.speed,
  'insight': s.insight,
  'purity': s.purity,
};

Map<String, dynamic> _itemToMap(Item i) => {
  'id': i.id,
  'name': i.name,
  'description': i.description,
  'type': i.type.name,
  'rarity': i.rarity.name,
  'slot': i.slot?.name,
  'element': i.element.name,
  'attackBonus': i.attackBonus,
  'defenseBonus': i.defenseBonus,
  'hpBonus': i.hpBonus,
  'spiritBonus': i.spiritBonus,
  'speed': i.speed,
  'spaceBonus': i.spaceBonus,
  'levelReq': i.levelReq,
  'price': i.price,
  'skillName': i.skillName,
  'skillDesc': i.skillDesc,
  'skillCost': i.skillCost,
  'skillDamageMultiplier': i.skillDamageMultiplier,
  'count': i.count,
  'stackable': i.stackable,
};

Map<String, dynamic> _enemyToMap(Enemy e) => {
  'id': e.id,
  'name': e.name,
  'description': e.description,
  'dangerLevel': e.dangerLevel,
  'stats': _statsToMap(e.stats),
  'loot': e.loot,
  'xpReward': e.xpReward,
  'element': e.element.name,
};

Map<String, dynamic> _mapToMap(MapNode m) => {
  'id': m.id,
  'name': m.name,
  'description': m.description,
  'danger': m.danger,
  'npcIds': m.npcIds,
  'enemyChance': m.enemyChance,
  'herbChance': m.herbChance,
  'resourceIds': m.resourceIds,
};

Map<String, dynamic> _missionToMap(Mission m) => {
  'id': m.id,
  'title': m.title,
  'description': m.description,
  'type': m.type.name,
  'targetId': m.targetId,
  'targetName': m.targetName,
  'targetCount': m.targetCount,
  'difficulty': m.difficulty,
  'reward': {
    'contribution': m.reward.contribution,
    'exp': m.reward.exp,
    'itemIds': m.reward.itemIds,
  },
};

Map<String, dynamic> _npcToMap(_NpcData n) => {
  'id': n.id,
  'name': n.name,
  'title': n.title,
  'description': n.description,
  'stats': _statsToMap(n.stats),
  'dialogues': n.dialogues,
  'friendship': n.friendship,
};

Map<String, dynamic> _buffToMap(Buff b) => {
  'id': b.id,
  'name': b.name,
  'description': b.description,
  'type': b.type.name,
  'statModifiers': _statsToMap(b.statModifiers),
};

Map<String, dynamic> _traitToMap(Trait t) => {
  'id': t.id,
  'name': t.name,
  'description': t.description,
  // ignore: deprecated_member_use
  'color': t.color.value,
};

Map<String, dynamic> _realmEntryToMap(MapEntry<int, RealmStage> e) => {
  'index': e.key,
  'name': e.value.name,
  'maxXp': e.value.maxXp,
  'hpBonus': e.value.hpBonus,
  'attackBonus': e.value.attackBonus,
  'spiritBonus': e.value.spiritBonus,
  'raceNames': e.value.raceNames.map((k, v) => MapEntry(k.name, v)),
};

Map<String, dynamic> _dropTablesToMap() => {
  'commonHerbs': DropTables.commonHerbs,
  'rareHerbs': DropTables.rareHerbs,
  'epicHerbs': DropTables.epicHerbs,
  'commonMonsterParts': DropTables.commonMonsterParts,
  'rareMonsterParts': DropTables.rareMonsterParts,
  'epicMonsterParts': DropTables.epicMonsterParts,
  'lowLevelConsumables': DropTables.lowLevelConsumables,
  'midLevelConsumables': DropTables.midLevelConsumables,
  'highLevelConsumables': DropTables.highLevelConsumables,
  'basicEquipment': DropTables.basicEquipment,
  'advancedEquipment': DropTables.advancedEquipment,
  'specialEquipment': DropTables.specialEquipment,
};

void _writeJson(Directory dir, String fileName, dynamic data) {
  final file = File('${dir.path}/$fileName');
  final encoder = const JsonEncoder.withIndent('  ');
  final payload = data is Iterable ? data.toList() : data;
  file.writeAsStringSync(encoder.convert(payload));
  final count = data is Iterable
      ? data.length
      : (data is Map ? data.length : 1);
  stdout.writeln('Generated $fileName ($count records)');
}

class _NpcData {
  const _NpcData({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.stats,
    required this.dialogues,
    this.friendship = 50,
  });

  final String id;
  final String name;
  final String title;
  final String description;
  final Stats stats;
  final List<String> dialogues;
  final int friendship;
}

const _manualNpcs = <_NpcData>[
  _NpcData(
    id: 'village_chief',
    name: '鐜嬫潙闀?',
    title: '鍑′汉鏉戦暱',
    description: '鎱堢ゥ鐨勮€佷汉锛屽湪杩欎釜鍗遍櫓鐨勪笘鐣岄噷鍕夊姏缁存寔鐫€鏉戝簞鐨勭敓瀛樸€?',
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
      '最近村子附近的野兽越来越多了..',
      '如果你能帮我们清理一下附近的野兽就好了。',
    ],
    friendship: 60,
  ),
  _NpcData(
    id: 'sect_elder',
    name: '鏉庨暱鑰?',
    title: '澶栭棬闀胯€?',
    description: '瀹楅棬鐨勫闂ㄩ暱鑰侊紝璐熻矗鎸囧鏂板叆闂ㄧ殑寮熷瓙銆?',
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
      '淇粰涔嬭矾锛岄€嗗ぉ鑰岃锛屽垏璁颁笉鍙噲鎬犮€?',
      '浣犵殑璧勮川灏氬彲锛屼絾杩橀渶鍕ゅ姞淇偧銆?',
      '鑻ユ湁涓嶆噦涔嬪锛屽彲鍘昏棌缁忛榿鏌ラ槄銆?',
    ],
  ),
  _NpcData(
    id: 'traveling_merchant',
    name: '娓告柟鍟嗕汉',
    title: '绁炵鍟嗕汉',
    description: '琛岃釜涓嶅畾鐨勫晢浜猴紝鎹鎵嬮噷鏈変笉灏戝ソ涓滆タ銆?',
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
      '璧拌繃璺繃涓嶈閿欒繃锛岀湅鐪嬫垜鐨勫疂璐濓紵',
      '鍙浣犳湁鐏电煶锛屼粈涔堥兘濂借銆?',
      '鏈€杩戠敓鎰忎笉濂藉仛鍟?..',
    ],
  ),
];
