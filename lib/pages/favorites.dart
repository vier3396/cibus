import 'package:cibus/services/database.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/widgets/spin_kit_ripple.dart';
import 'package:cibus/widgets/vertical_list_view.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  final Stream<UserData> userDataStream;
  FavoritesPage({this.userDataStream});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Recipe>> getFavoriteRecipes(UserData userData) async {
    return await DatabaseService().findFavoriteRecipes(userData.favoriteList);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: widget.userDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                title: Text('Favorites'),
                centerTitle: true,
              ),
              body: SafeArea(
                child: FutureBuilder(
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
                              return VerticalListView(
                                myOwnUserPage: false,
                                title: 'Your favorites',
                                recipes: favorites,
                              );
                            } else {
                              return Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'You have no favorites yet',
                                        style: TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Checkout our large database of recipes!',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
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
