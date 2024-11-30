class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String url;
  final String location;
  final String origin;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.url,
    required this.location,
    required this.origin,
  });

  // Método para crear un Character desde un JSON
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      gender: json['gender'],
      image: json['image'],
      url: json['url'],
      location: json['location']['name'],
      origin: json['origin']['name'],
    );
  }
}


