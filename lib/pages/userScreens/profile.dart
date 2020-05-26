import 'package:cibus/services/models/constants.dart';
import 'dart:convert';

import 'package:cibus/pages/userScreens/home.dart';
import 'package:cibus/pages/loginScreens/login_screen.dart';
import 'package:cibus/pages/userScreens/settings_screen.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/widgets/vertical_list_view.dart';
import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';

class Profile extends StatelessWidget {
  final Stream userDataStream;
  Profile({this.userDataStream});

  Future<List<Recipe>> getUserRecipes(UserData userData) async {
    return await DatabaseService().findUserRecipes(userData.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              body: SafeArea(
                child: ListView(
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
                          SettingsButton(),
                        ],
                      ),
                    ),
                    Divider(),
                    FutureBuilder(
                      future: getUserRecipes(snapshot.data),
                      builder: (context, futureSnapshot) {
                        if (futureSnapshot.hasError)
                          return Text('Error: ${futureSnapshot.error}');
                        switch (futureSnapshot.connectionState) {
                          case ConnectionState.none:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.done:
                            {
                              if (futureSnapshot.hasData) {
                                List<Recipe> myRecipes = futureSnapshot.data;
                                if (myRecipes.isNotEmpty) {
                                  return VerticalListView(
                                    title: 'Your recipes',
                                    recipes: myRecipes,
                                  );
                                } else {
                                  return Text(
                                      'Sharing is caring<3 feel free to upload some of your own recipes'); //TODO styla denna
                                }
                              }
                              return Text('There\'s no available data.');
                            }
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: MySpinKitRipple(),
              ),
            );
          }
        });
  }
}

class SettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.settings),
      iconSize: 50,
      color: Colors.grey,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingsScreen(),
          ),
        );
      },
    );
  }
}
