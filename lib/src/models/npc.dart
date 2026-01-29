import 'package:flutter/foundation.dart';
import 'stats.dart';

@immutable
class Npc {
  final String id;
  final String name;
  final String title;
  final String description;
  final Stats stats;
  final List<String> dialogues;
  final int friendship; // 0-100, 50 neutral

  const Npc({
    required this.id,
    required this.name,
    this.title = '',
    required this.description,
    required this.stats,
    this.dialogues = const ['...'],
    this.friendship = 50,
  });

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
