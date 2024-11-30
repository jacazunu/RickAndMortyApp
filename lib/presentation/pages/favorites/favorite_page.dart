import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../stores/character_store.dart';
import 'package:prueba_vacante_app/presentation/pages/character_detail/character_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final characterStore = Provider.of<CharacterStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
      ),
      body: Observer(
        builder: (_) {
          // Si no hay personajes favoritos, mostrar mensaje
          if (characterStore.favoriteCharacters.isEmpty) {
            return const Center(child: Text("No hay favoritos seleccionados"));
          }

          return ListView.builder(
            itemCount: characterStore.favoriteCharacters.length,
            itemBuilder: (context, index) {
              final character = characterStore.favoriteCharacters[index];

              // Hacer clic en un personaje para ver sus detalles
              return InkWell(
                onTap: () {
                  // Al hacer clic, navegar a la página de detalles
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CharacterDetailPage(character: character),
                    ),
                  );
                },
                child: Container(
                  color: index % 2 == 0 ? Colors.grey[200] : Colors.white, // Alternar colores
                  child: ListTile(
                    leading: Image.network(character.image),
                    title: Text(character.name),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}