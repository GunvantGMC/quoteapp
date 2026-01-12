import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'saved_favorites';

  /// Save a quote to favorites
  Future<bool> addToFavorites(Map<String, dynamic> quote) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      // Check if already exists
      if (favorites.any((fav) => fav['id'] == quote['id'])) {
        return false;
      }

      // Add timestamp
      final favoriteQuote = {
        ...quote,
        'dateSaved': DateTime.now().toIso8601String(),
      };

      favorites.add(favoriteQuote);
      await prefs.setString(_favoritesKey, jsonEncode(favorites));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove a quote from favorites
  Future<bool> removeFromFavorites(String quoteId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      favorites.removeWhere((fav) => fav['id'] == quoteId);
      await prefs.setString(_favoritesKey, jsonEncode(favorites));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get all favorites
  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null || favoritesJson.isEmpty) {
        return [];
      }

      final List<dynamic> decoded = jsonDecode(favoritesJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Check if a quote is favorited
  Future<bool> isFavorited(String quoteId) async {
    final favorites = await getFavorites();
    return favorites.any((fav) => fav['id'] == quoteId);
  }

  /// Clear all favorites
  Future<bool> clearAllFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_favoritesKey);
      return true;
    } catch (e) {
      return false;
    }
  }
}
