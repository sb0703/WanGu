class MapNode {
  const MapNode({
    required this.id,
    required this.name,
    required this.description,
    required this.danger,
  });

  final String id;
  final String name;
  final String description;
  final int danger; // 0-10, higher means harder encounters
}
