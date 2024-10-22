import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  Future<void> toggleFavorite(String email, String cardId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convertimos la lista obtenida en una lista modificable
    final List<String> favorites = List<String>.from(prefs.getStringList(email) ?? []);

    // Verificamos si la carta ya es favorita
    if (favorites.contains(cardId)) {
      favorites.remove(cardId); // Si es favorita, la eliminamos
    } else {
      favorites.add(cardId); // Si no es favorita, la agregamos
    }

    // Guardamos la lista modificada en SharedPreferences
    await prefs.setStringList(email, favorites);
  }

  Future<List<String>> getFavorites(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Devolvemos la lista modificable de favoritos
    return List<String>.from(prefs.getStringList(email) ?? []);
  }

  Future<bool> isFavorite(String email, String cardId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Convertimos la lista en modificable
    final List<String> favorites = List<String>.from(prefs.getStringList(email) ?? []);
    // Comprobamos si la carta está en favoritos
    return favorites.contains(cardId);
  }
}