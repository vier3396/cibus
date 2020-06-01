import 'package:cibus/services/models/colors.dart';
import 'package:cibus/services/models/constants.dart';
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
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 140,
                            width: 140,
                            child: Stack(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                      userData.profilePic ?? kDefaultProfilePic),
                                ),
                                Positioned(
                                  right: 0.0,
                                    bottom: 0.0,
                                    child: SettingsButton(),),
                              ],
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    userData.username ?? "Cannot find username",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    userData.description ??
                                        "Cannot find description",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                    style: TextStyle(),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                    myOwnUserPage: true,
                                    myFavorites: false,
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              'Sharing is caring',
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Icon(
                                              Icons.favorite_border,
                                              color: kCoral,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Feel free to upload some of your own recipes',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
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
      color: Colors.grey[300],
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
