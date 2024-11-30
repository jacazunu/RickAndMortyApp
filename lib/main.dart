import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_vacante_app/presentation/stores/character_store.dart';
import 'package:prueba_vacante_app/presentation/pages/character_list/character_list_page.dart';
import 'package:prueba_vacante_app/domain/usecases/get_characters.dart';
import 'package:prueba_vacante_app/data/repositories/character_repository_impl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Crea las dependencias
    final characterRepository = CharacterRepositoryImpl();
    final getCharacters = GetCharacters(characterRepository);

    return MultiProvider(
      providers: [
        Provider<CharacterStore>(
          create: (_) => CharacterStore(getCharacters),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rick and Morty App',
        home: CharacterListPage(),
      ),
    );
  }
}