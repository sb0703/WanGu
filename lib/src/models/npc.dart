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

  const Npc({
    required this.id,
    required this.name,
    this.title = '',
    required this.description,
    required this.stats,
    this.dialogues = const ['...'],
    this.friendship = 50,
  });

  /// 复制并修改
  Npc copyWith({
    String? name,
    String? title,
    String? description,
    Stats? stats,
    List<String>? dialogues,
    int? friendship,
  }) {
    return Npc(
      id: id,
      name: name ?? this.name,
      title: title ?? this.title,
      description: description ?? this.description,
      stats: stats ?? this.stats,
      dialogues: dialogues ?? this.dialogues,
      friendship: friendship ?? this.friendship,
    );
  }
}
