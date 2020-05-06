import 'package:cibus/pages/settings_screen.dart';
import 'package:cibus/services/login/auth.dart';
import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/pages/loginScreens/login_screen.dart';
import 'package:cibus/pages/profile.dart';
import 'package:cibus/pages/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/pages/firstScreen.dart';
import 'package:cibus/pages/camera_screen.dart';
import 'package:cibus/services/recipe.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Recipe>(
      create: (context) => Recipe(),
      child: StreamProvider<User>.value(
        value: AuthService().user,
        child: MaterialApp(
          initialRoute: '/loginPage',
          routes: {
            '/': (context) => LoadingScreen(),
            //'/add': (context) => AddRecipe(),
            '/profile': (context) => Profile(),
            '/loginPage': (context) => LoginPage(),
            '/firstScreen': (context) => MyPageView(),
            '/settingsScreen': (context) => SettingsScreen(),
            'camerscreen': (context) => ImageCapture(),
          },
        ),
      ),
    );
  }
}
