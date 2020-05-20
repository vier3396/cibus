import 'package:cibus/services/constants.dart';
import 'package:cibus/pages/settings_screen.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';

class Profile extends StatelessWidget {
  Stream userDataStream;
  Profile({this.userDataStream});

  /*
  Future<List<Recipe>> getUserRecipes(UserData userData) async {
    return await DatabaseService().findUserRecipes(userData.uid);
  }

   */
/*
  Widget ifHasRecipes(List<Recipe> myRecipes) {
    if (myRecipes != null && myRecipes.isEmpty) {
      return ListViewRecipes(
        scrollDirection: Axis.vertical,
        title: 'Your recipes',
      );
    } else {
      return Text('You have no favorites yet'); //TODO styla denna
    }
  }

 */

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
                          IconButton(
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
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    /*
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
                              return Column(
                                children: <Widget>[
                                  //widgets using userData
                                  ifHasRecipes(myRecipes),
                                ],
                              );
                            }
                            return Text('There\'s no available data.');
                          }
                      }
                      return null;
                    },
                  ),

                   */
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
