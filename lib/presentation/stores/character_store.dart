import 'package:mobx/mobx.dart';
import '../../domain/entities/character.dart';
import '../../domain/usecases/get_characters.dart';

part 'character_store.g.dart';

// ignore: library_private_types_in_public_api
class CharacterStore = _CharacterStore with _$CharacterStore;

abstract class _CharacterStore with Store {
  final GetCharacters getCharacters;
  

  _CharacterStore(this.getCharacters);

  @observable
  ObservableList<Character> characters = ObservableList<Character>();

   @observable
  int currentPage = 1; // Página actual
   @computed
  List<Character> get paginatedCharacters {
    final startIndex = (currentPage - 1) * 30;
    final endIndex = startIndex + 30;
    return characters.sublist(
      startIndex,
      endIndex > characters.length ? characters.length : endIndex,
    );
  }

  @observable
  ObservableList<Character> favoriteCharacters = ObservableList<Character>();
  //observables de Favoritos

  @action
  Future<void> loadCharacters() async {
    final result = await getCharacters();
    characters.addAll(result);
  }
//future de favorito
@action
  void toggleFavorite(Character character) {
    if (favoriteCharacters.contains(character)) {
      favoriteCharacters.remove(character);
    } else {
      favoriteCharacters.add(character);
    }
  }

@action
 void nextPage() {
    if ((currentPage * 30) < characters.length) {
      currentPage++;
    }
  }  
@action
 void previousPage() {
    if (currentPage > 1) {
      currentPage--;
    }
  }

}

/*part 'character_store.g.dart';

class CharacterStore = _CharacterStore with _$CharacterStore;

abstract class _CharacterStore with Store {
  final GetCharacters getCharacters;

  _CharacterStore(this.getCharacters);

  @observable
  ObservableList<Character> characters = ObservableList<Character>();

  @observable
  int currentPage = 1; // Página actual

  @computed
  List<Character> get paginatedCharacters {
    final startIndex = (currentPage - 1) * 30;
    final endIndex = startIndex + 30;
    return characters.sublist(
      startIndex,
      endIndex > characters.length ? characters.length : endIndex,
    );
  }

  @action
  Future<void> loadCharacters() async {
    final result = await getCharacters();
    characters.addAll(result);
  }

  @action
  void nextPage() {
    if ((currentPage * 30) < characters.length) {
      currentPage++;
    }
  }

  @action
  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
    }
  }
}*/