import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorites_store.g.dart';

class FavoritesStore = _FavoritesStore with _$FavoritesStore;

abstract class _FavoritesStore with Store {
  @observable
  ObservableList<int> favoriteIds = ObservableList<int>();

  @action
  Future<void> toggleFavorite(int id) async {
    if (favoriteIds.contains(id)) {
      favoriteIds.remove(id);
    } else {
      favoriteIds.add(id);
    }
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favoriteIds.map((id) => id.toString()).toList());
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];
    favoriteIds.addAll(favorites.map((id) => int.parse(id)));
  }
}
