import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/recipe.dart';
//import 'package:cibus/widgets/favorite_button.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';
import 'package:flutter/material.dart';
import 'inspo_page.dart';
import 'package:cibus/widgets/list_view_recipes.dart';

class HomePage extends StatelessWidget {
  final Stream<UserData> userDataStream;
  HomePage({this.userDataStream});

  Future<List<Recipe>> getFavoriteRecipes(UserData userData) async {
    return await DatabaseService().findFavoriteRecipes(userData.favoriteList);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              body: ListView(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return InspoPage();
                        },
                      ));
                    },
                    child: Hero(
                      tag: 'inspo_homepage',
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30.0),
                                bottomLeft: Radius.circular(30.0),
                              ),
                              child: Image(
                                image: AssetImage('assets/color_eggs.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20.0,
                            bottom: 20.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Trash bin overflow?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  'Make use of those scraps',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 20.0,
                          left: 20.0,
                        ),
                        child: Text(
                          'Hi ${userData.name} !' ?? 'Hi!',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(
                          thickness: 2.0,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                  FutureBuilder(
                    future: getFavoriteRecipes(userData),
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
                              List<Recipe> favorites = futureSnapshot.data;
                              if (favorites.isNotEmpty) {
                                return ListViewRecipes(
                                  title: 'Your favorites',
                                  recipes: favorites,
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    'Checkout our large database of recipes',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      //letterSpacing: 1.1,
                                    ),
                                  ),
                                ); //TODO styla denna
                              }
                            }
                            return Text('There\'s no available data.');
                          }
                      }
                      return null;
                    },
                  ),
                  /*
                  ListViewRecipes(
                    scrollDirection: Axis.horizontal,
                    title: 'Your favorites',
                    userData: userData,
                    userDataStream: userDataStream,
                  ),

                   */
                ],
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
