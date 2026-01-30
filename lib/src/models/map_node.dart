class MapNode {
  const MapNode({
    required this.id,
    required this.name,
    required this.description,
    required this.danger,
    this.npcIds = const [],
    this.enemyChance = 0.55,
    this.herbChance = 0.25,
    this.resourceIds = const ['herb'],
  });

  final String id;
  final String name;
  final String description;
  final int danger; // 0-10, higher means harder encounters
  final List<String> npcIds;

  // Event probabilities (should sum to <= 1.0 ideally, or be handled sequentially)
  final double enemyChance;
  final double herbChance;

  // Resources found in this map
  final List<String> resourceIds;
}
