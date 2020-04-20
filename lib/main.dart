import 'package:flutter/material.dart';
import 'package:cibus/pages/add_recipe.dart';
import 'package:cibus/pages/authtest.dart';
import 'package:cibus/pages/cook_recipe.dart';
import 'package:cibus/pages/profile.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/pages/test.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/loginPage',
    routes: {
      '/': (context) => LoadingScreen(),
      '/cook': (context) => CookRecipe(),
      '/add': (context) => AddRecipe(),
      '/profile': (context) => Profile(),
      '/test': (context) => Test(),
      '/loginPage': (context) => LoginPage(),
    },
  ));
}
