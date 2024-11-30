class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String image;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      image: json['image'],
    );
  }
}
