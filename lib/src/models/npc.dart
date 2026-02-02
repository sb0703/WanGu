import 'package:flutter/foundation.dart';
import 'stats.dart';

/// NPC 模型
@immutable
class Npc {
  final String id; // ID
  final String name; // 姓名
  final String title; // 称号
  final String description; // 描述
  final Stats stats; // 属性
  final List<String> dialogues; // 对话列表
  final int friendship; // 好感度 (0-100, 50 为中立)
  final bool isMobile; // 是否会自主移动
  final List<String> tags; // 性格/标签
  final String displayRealm; // 显示境界
  final List<String> inventory; // NPC 背包 (Item IDs)

  const Npc({
    required this.id,
    required this.name,
    this.title = '',
    required this.description,
    required this.stats,
    this.dialogues = const ['...'],
    this.friendship = 50,
    this.isMobile = false,
    this.tags = const [],
    this.displayRealm = '凡人',
    this.inventory = const [],
  });

  /// 复制并修改
  Npc copyWith({
    String? name,
    String? title,
    String? description,
    Stats? stats,
    List<String>? dialogues,
    int? friendship,
    bool? isMobile,
    List<String>? tags,
    String? displayRealm,
    List<String>? inventory,
  }) {
    return Npc(
      id: id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      stats: stats ?? this.stats,
      dialogues: dialogues ?? this.dialogues,
      friendship: friendship ?? this.friendship,
      isMobile: isMobile ?? this.isMobile,
      tags: tags ?? this.tags,
      displayRealm: displayRealm ?? this.displayRealm,
      inventory: inventory ?? this.inventory,
    );
  }
}
