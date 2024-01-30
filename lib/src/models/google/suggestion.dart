class Suggestion {
  final String placeId;
  final String description;
  final String name;

  Suggestion(this.placeId, this.description, this.name);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId, name: $name)';
  }
}
