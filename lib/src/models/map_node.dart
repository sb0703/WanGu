class MapNode {
  const MapNode({
    required this.id,
    required this.name,
    required this.description,
    required this.danger,
    this.npcIds = const [],
  });

  final String id;
  final String name;
  final String description;
  final int danger; // 0-10, higher means harder encounters
  final List<String> npcIds;
}
