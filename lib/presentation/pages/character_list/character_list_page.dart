import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import '../../stores/character_store.dart';
//import 'package:prueba_vacante_app/domain/entities/character.dart';
import 'package:prueba_vacante_app/presentation/pages/favorites/favorite_page.dart';
import 'package:prueba_vacante_app/presentation/pages/character_detail/character_detail_page.dart'; // Importar la nueva página de detalles

class CharacterListPage extends StatefulWidget {
  @override
  _CharacterListPageState createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  late CharacterStore characterStore;
  late ScrollController _scrollController;
  String searchQuery = '';
  TextEditingController pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      characterStore = Provider.of<CharacterStore>(context, listen: false);
      characterStore.loadCharacters(); // Cargar personajes al inicio
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _updateSearchQuery(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      // Reiniciar la página cuando se actualiza la búsqueda
      characterStore.currentPage = 1;
    });
  }

  void _goToPage() {
    final page = int.tryParse(pageController.text);
    if (page != null && page > 0) {
      final totalPages = (characterStore.characters.length / 30).ceil();
      if (page <= totalPages) {
        setState(() {
          characterStore.currentPage = page;
          _scrollToTop();
        });
      } else {
        pageController.text = characterStore.currentPage.toString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Página no válida')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ingrese un número de página válido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    characterStore = Provider.of<CharacterStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: _updateSearchQuery,
          decoration: const InputDecoration(
            icon: Icon(Icons.search),
            hintText: "Buscar personaje...",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Observer(
              builder: (_) {
                // Filtrar personajes según la búsqueda
                final filteredCharacters = searchQuery.isEmpty
                    ? characterStore.characters // Todos los personajes cargados
                    : characterStore.characters
                        .where((character) => character.name.toLowerCase().contains(searchQuery))
                        .toList();

                if (filteredCharacters.isEmpty) {
                  return const Center(child: Text("No characters found"));
                }

                // Controlar la paginación en la lista filtrada
                final startIndex = (characterStore.currentPage - 1) * 30;
                final endIndex = startIndex + 30;
                final charactersToShow = filteredCharacters.sublist(
                  startIndex,
                  endIndex < filteredCharacters.length ? endIndex : filteredCharacters.length,
                );

                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos columnas
                    crossAxisSpacing: 10, // Espacio horizontal entre las celdas
                    mainAxisSpacing: 10, // Espacio vertical entre las celdas
                    childAspectRatio: 1.0, // Ajustar la proporción para reducir el tamaño
                  ),
                  itemCount: charactersToShow.length,
                  itemBuilder: (context, index) {
                    final character = charactersToShow[index];
                    return Observer(
                      builder: (_) {
                        final isFavorite = characterStore.favoriteCharacters.contains(character);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CharacterDetailPage(character: character),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                        ),
                                        child: Image.network(
                                          character.image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 120, // Ajusta la altura de las imágenes
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0, top: 6.0, right: 32.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              character.name,
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), // Reducir tamaño de fuente
                                            ),
                                          ),
                                          AnimatedSwitcher(
                                            duration: Duration(milliseconds: 300),
                                            transitionBuilder: (child, animation) {
                                              return ScaleTransition(scale: animation, child: child);
                                            },
                                            child: IconButton(
                                              key: ValueKey(isFavorite),
                                              icon: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorite ? Colors.red : Colors.grey,
                                              ),
                                              onPressed: () {
                                                characterStore.toggleFavorite(character);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (characterStore.currentPage > 1) {
                          characterStore.previousPage();
                          _scrollToTop();
                          setState(() {});
                        }
                      },
                      child: const Text("Anterior"),
                    ),
                    Observer(
                      builder: (_) => Text(
                        "Página ${characterStore.currentPage}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final filteredCharacters = searchQuery.isEmpty
                            ? characterStore.characters
                            : characterStore.characters
                                .where((character) => character.name.toLowerCase().contains(searchQuery))
                                .toList();
                        if ((characterStore.currentPage * 30) < filteredCharacters.length) {
                          characterStore.nextPage();
                          _scrollToTop();
                          setState(() {});
                        }
                      },
                      child: const Text("Siguiente"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Ir a página: '),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: pageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(hintText: 'Max 28'),
                        onSubmitted: (_) => _goToPage(), // Aquí se maneja el evento Enter
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _goToPage,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 