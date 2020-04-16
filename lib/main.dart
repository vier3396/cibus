import 'package:flutter/material.dart';
import 'package:independentproject/pages/add_recipe.dart';
import 'package:independentproject/pages/cook_recipe.dart';
import 'package:independentproject/pages/profile.dart';
import 'package:independentproject/pages/loading_screen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/profile',
    routes: {
      '/': (context) => LoadingScreen(),
      '/cook': (context) => CookRecipe(),
      '/add': (context) => AddRecipe(),
      '/profile': (context) => Profile(),
    },
  ));
}
