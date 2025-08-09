class Place {
  final String name;
  final String description;
  final String image;

  Place({required this.name, required this.description, required this.image});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Unknown Place',
      description:
          json['wikipedia_extracts']?['text'] ??
          json['info']?['descr'] ??
          'No description available',
      image: json['preview']?['source'] ?? '', // May not always be available
    );
  }
}
