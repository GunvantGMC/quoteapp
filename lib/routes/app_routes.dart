import 'package:flutter/material.dart';
import '../presentation/favorites_screen/favorites_screen.dart';
import '../presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String favorites = '/favorites-screen';
  static const String home = '/home-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeScreen(),
    favorites: (context) => const FavoritesScreen(),
    home: (context) => const HomeScreen(),
  };
}
