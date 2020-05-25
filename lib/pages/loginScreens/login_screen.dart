import 'package:cibus/pages/loading_screen.dart';
import 'package:cibus/pages/loginScreens/register_screen.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/loginScreens/e-sign_in_screen.dart';
import 'package:cibus/services/my_page_view.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/login/sign_in.dart';
import 'package:cibus/pages/loginScreens/username_screen.dart';
import 'package:cibus/services/colors.dart';

const widthLogo = 250.0;
const heightLogo = 250.0;
const backgroundColor = kCoral;
const loginSplashColor = kWarmOrange;
const loginHighlightedBorderColor = kPalePink;
const EdgeInsets loginPaddingFbGo = EdgeInsets.only(left: 10, right: 5);
const EdgeInsets loginPadding = EdgeInsets.only(left: 10, right: 10);

const TextStyle loginTextStyle = TextStyle(
  fontSize: 20,
  color: Colors.white,
);

const TextStyle newUserTextStyle = TextStyle(
  fontSize: 17,
  color: Colors.white,
);

BorderSide loginBorderSide = BorderSide(
  color: Colors.white,
);

RoundedRectangleBorder loginShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(40),
);

SignIn signIn = SignIn();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingScreen()
        : Scaffold(
            body: Container(
              color: backgroundColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/coral_lemon.png',
                      height: heightLogo,
                      width: widthLogo,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _signInButtonGoogle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _signInButtonFacebook(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _signInEmailButton(),
                    ),
                    SizedBox(height: 20.0),
                    Text('New to CIBUS?', style: newUserTextStyle),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _registerButton(),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget _signInButtonGoogle() {
    return OutlineButton(
      splashColor: loginSplashColor,
      highlightedBorderColor: loginHighlightedBorderColor,
      onPressed: () {
        setState(() {
          loading = true;
        });
        signIn.whatLogin = loginType.google;
        signIn.signInWithGoogle().whenComplete(() {
          if (signIn.isNewUser && signIn.isLoggedInGoogle) {
            print("två true");

            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              loading = false;
              return UsernameScreen();
            }));
          } else if (signIn.isLoggedInGoogle) {
            print("ett true");
            loading = false;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyPageView()),
                (Route<dynamic> route) => false);
          } else {
            print("funkar ej");
            setState(() {
              loading = false;
            });
          }
        });
      },
      shape: loginShape,
      borderSide: loginBorderSide,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: loginPaddingFbGo,
              child: Text(
                'Sign in with Google',
                style: loginTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInButtonFacebook() {
    return OutlineButton(
      splashColor: loginSplashColor,
      highlightedBorderColor: loginHighlightedBorderColor,
      onPressed: () {
        setState(() {
          loading = true;
        });

        signIn.whatLogin = loginType.facebook;
        signIn.signInWithFacebook().whenComplete(() {
          if (signIn.isNewUser && signIn.isLoggedInFacebook) {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              loading = false;
              return UsernameScreen();
            }));
          } else if (signIn.isLoggedInFacebook) {
            loading = false;
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyPageView()),
                (Route<dynamic> route) => false);
          } else {
            setState(() {
              loading = false;
            });
          }
        });
      },
      shape: loginShape,
      borderSide: loginBorderSide,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/icon_fb.png"), height: 35.0),
            Padding(
              padding: loginPaddingFbGo,
              child: Text(
                'Sign in with Facebook',
                style: loginTextStyle,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _signInEmailButton() {
    return OutlineButton(
      splashColor: loginSplashColor,
      highlightedBorderColor: loginHighlightedBorderColor,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return EmailSignIn();
            },
          ),
        );
      },
      shape: loginShape,
      borderSide: loginBorderSide,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: loginPadding,
              child: Text('Sign in with email', style: loginTextStyle),
            )
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return OutlineButton(
      splashColor: loginSplashColor,
      highlightedBorderColor: loginHighlightedBorderColor,
      onPressed: () {
        /* Navigator.of(context).pushNamedAndRemoveUntil(
            '/loginPage', (Route<dynamic> route) => false); */
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return RegisterScreen();
            },
          ),
        );
      },
      shape: loginShape,
      borderSide: loginBorderSide,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: loginPadding,
              child: Text('Register new user', style: loginTextStyle),
            )
          ],
        ),
      ),
    );
  }
}
