import 'package:cibus/pages/settings_screen.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:flutter/material.dart';
import 'package:cibus/pages/add_recipe.dart';
import 'package:cibus/pages/authtest.dart';
import 'package:cibus/pages/cook_recipe.dart';
import 'package:cibus/pages/profile.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/pages/test.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/pages/firstScreen.dart';





void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/loginPage',
        routes: {
          '/': (context) => LoadingScreen(),
          '/cook': (context) => CookRecipe(),
          '/add': (context) => AddRecipe(),
          '/profile': (context) => Profile(),
          '/test': (context) => Test(),
          '/loginPage': (context) => LoginPage(),
          '/firstScreen': (context) => FirstScreen(),
          '/settingsScreen': (context) => SettingsScreen(),
        },
      ),
    );
  }
}



