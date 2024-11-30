import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prueba_vacante_app/domain/entities/character.dart';
import 'package:prueba_vacante_app/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final String apiUrl = 'https://rickandmortyapi.com/api/character';

  @override
  Future<List<Character>> getCharacters() async {
    List<Character> allCharacters = [];
    int currentPage = 1;
    bool hasNextPage = true;

    while (hasNextPage) {
      final response = await http.get(Uri.parse('$apiUrl?page=$currentPage'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        // Mapear los resultados a entidades de Character
        allCharacters.addAll(
          results.map((json) => Character.fromJson(json)).toList(),
        );

        // Verificar si hay una página siguiente
        hasNextPage = data['info']['next'] != null;
        currentPage++;
      } else {
        throw Exception('Failed to fetch characters');
      }
    }

    return allCharacters;
  }
}




/*class CharacterRepositoryImpl implements CharacterRepository {
  final String baseUrl = 'https://rickandmortyapi.com/api';

  @override
  Future<List<Character>> getCharacters() async {
    final url = Uri.parse('$baseUrl/character');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => Character.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch characters');
    }
  }
}*/