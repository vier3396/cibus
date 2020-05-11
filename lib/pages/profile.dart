import 'package:cibus/pages/home.dart';
import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/settings_screen.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter/material.dart';
import 'package:cibus/services/colors.dart';
import 'package:cibus/services/popup_layout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'settings_screen.dart';

const topMarginPopupLayout = 0.0;

class Profile extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<bool> _boldButtons = [false, true, false];
  Container wallOfText = yourRecipes();
  //int karma;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              body: SafeArea(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                userData.profilePic ?? kBackupProfilePic),
                            radius: 40.0,
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                Text(
                                  userData.name ?? "Cannot find name",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  userData.description ??
                                      "Cannot find description",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                  style: TextStyle(),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 40.0),
                          IconButton(
                            icon: Image.asset('assets/cogwheel.png'),
                            iconSize: 50,
                            onPressed: () {
                              PopupLayout(top: topMarginPopupLayout).showPopup(
                                  context, SettingsScreen(), 'Cibus Settings');
                            },
                          ),
                        ],
                      ),
                    ),
                    Divider(color: kCibusTextColor),
                    SizedBox(height: 40.0),
                    buildProfileButtons(),
                    SizedBox(height: 20.0),
                    wallOfText,
                  ],
                ),
              ),
            );
          } else {
            return HomePage();
          }
        });
  }

  Container buildProfileButtons() {
    return Container(
      color: kDarkerkBackgroundColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              child: Text(
                "Notifications",
                style: TextStyle(
                    fontWeight:
                        _boldButtons[0] ? FontWeight.bold : FontWeight.normal),
              ),
              onPressed: () {
                wallOfText = _boldButtons[0] ? wallOfText : notifications();
                setState(() {
                  _boldButtons = [true, false, false];
                });
                // call function to display right kind of text
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text(
                "Your recipes",
                style: TextStyle(
                    fontWeight:
                        _boldButtons[1] ? FontWeight.bold : FontWeight.normal),
              ),
              onPressed: () {
                wallOfText = _boldButtons[1] ? wallOfText : yourRecipes();
                setState(() {
                  _boldButtons = [false, true, false];
                });
                // call function to display right kind of text
              },
            ),
          ),
          Expanded(
            child: FlatButton(
              child: Text(
                "Favorites",
                style: TextStyle(
                    fontWeight:
                        _boldButtons[2] ? FontWeight.bold : FontWeight.normal),
              ),
              onPressed: () {
                wallOfText = _boldButtons[0] ? wallOfText : favorites();
                setState(() {
                  _boldButtons = [false, false, true];
                });
                // call function to display right kind of text
                // wallOfText = Favorites();
              },
            ),
          ),
        ],
      ),
    );
  }

  Container notifications() {
    return Container(
      child: Text("notifications"),
    );
  }

  static Container yourRecipes() {
    return Container(
      child: Text("your recipes"),
    );
  }

  Container favorites() {
    return Container(
      child: Text("favorites"),
    );
  }

  /* Padding buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(userData.profilePic),
            radius: 40.0,
          ),
          SizedBox(width: 20.0),
          Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                'YOUR NAME',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                'Karma points: $karma',
                style: TextStyle(
                ),
              ),
            ],
          ),
          SizedBox(width: 40.0),
          IconButton(
            icon: Image.asset('assets/cogwheel.png'),
            iconSize: 50,
            onPressed: () {
              PopupLayout(top: topMarginPopupLayout).showPopup(context,
                  popupBodySettings(), 'Settings');
            },
          ),
        ],
      ),
    );

  } */

  Widget popupBodySettings() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text("Account"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MyRecipes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
