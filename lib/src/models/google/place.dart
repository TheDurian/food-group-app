class Place {
  String address;
  String name;
  String photoReference;

  Place({
    required this.address,
    required this.name,
    required this.photoReference,
  });

  @override
  String toString() {
    return 'Place(address: $address, name: $name, photoReference: $photoReference)';
  }
}
