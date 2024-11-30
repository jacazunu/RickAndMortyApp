import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';

class CharacterRemoteDataSource {
  final http.Client client;

  CharacterRemoteDataSource(this.client);

  Future<List<CharacterModel>> fetchCharacters() async {
    final response = await client.get(Uri.parse('https://rickandmortyapi.com/api/character'));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return (json['results'] as List)
          .map((character) => CharacterModel.fromJson(character))
          .toList();
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
