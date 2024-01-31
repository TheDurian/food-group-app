class Suggestion {
  final String placeId;
  final String description;
  final String name;

  Suggestion({
    required this.placeId,
    required this.description,
    required this.name,
  });

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId, name: $name)';
  }
}
