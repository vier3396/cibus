import 'package:cibus/pages/loginScreens/username_screen.dart';
import 'package:cibus/pages/loginScreens/verify_screen.dart';
import 'package:cibus/pages/userScreens/settings_screen.dart';
import 'package:cibus/services/login/auth.dart';
import 'widgets/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/pages/loginScreens/login_screen.dart';
import 'package:cibus/pages/userScreens/profile.dart';
import 'package:cibus/pages/loadingScreens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/user.dart';
import 'package:cibus/pages/cameraScreens/camera_screen.dart';
import 'package:cibus/services/models/colors.dart';
import 'package:cibus/widgets/recipe_preview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool authenticated = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>(
      lazy: false,
      create: (context) => AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: kCoral, //Appbar
          accentColor: kCoral,
          appBarTheme: AppBarTheme(
            color: Colors.white,
            elevation: 0.0,
          ),
        ),
        initialRoute: '/loginPage',
        routes: {
          '/': (context) => LoadingScreen(),
          '/profile': (context) => Profile(),
          '/loginPage': (context) => LoginPage(),
          '/firstScreen': (context) => MyPageView(),
          '/settingsScreen': (context) => SettingsScreen(),
          'camerscreen': (context) => ImageCapture(),
          '/recipePreview': (context) => RecipePreview(),
          '/verifyscreen': (context) => VerifyScreen(),
          '/usernamescreen': (context) => UsernameScreen(),
        },
      ),
    );
  }
}
