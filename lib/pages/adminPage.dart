import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/recipeList.dart';
import 'package:cibus/services/recipe.dart';
import 'package:cibus/services/login/user.dart';
import 'package:cibus/services/database.dart';
import 'package:cibus/widgets/recipe_preview.dart';
import 'package:cibus/services/ingredientList.dart';
import 'package:cibus/pages/user_page.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool firstTime = true;
  List<UserData> userList = [];

  void getRecipes({bool firstTimeFunc}) async {
    if (firstTimeFunc) {
      User user = Provider.of<User>(context);
      DatabaseService database = DatabaseService(uid: user.uid);
      List<Map> recipeListFromDatabase = await database.returnReportedRecipes();
      Provider.of<RecipeList>(context, listen: false)
          .addEntireRecipeList(recipeListFromDatabase);
      firstTime = false;
    }
  }

  void getUsers({firstTimeFunc}) async {
    if (firstTimeFunc) {
      User user = Provider.of<User>(context);
      DatabaseService database = DatabaseService(uid: user.uid);
      userList = await database.getUserDataList();
      print('userlist: ${userList}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);
    getRecipes(firstTimeFunc: firstTime);
    getUsers(firstTimeFunc: firstTime);
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () async {
                      List<Recipe> recipes = await DatabaseService()
                          .findUserRecipes(userList[index].uid);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserPage(
                                    recipes: recipes,
                                    userData: userList[index],
                                  )));
                    },
                    child: Row(
                      children: <Widget>[
                        Text('${userList[index].name}'),
                        RaisedButton(
                          onPressed: () {
                            database.adminRemoveUser(
                                userId: userList[index].uid);

                            setState(() {
                              firstTime = true;
                            });
                          },
                          child: Text('remove user'),
                        ),
                        RaisedButton(
                          onPressed: () {
                            database.adminRemoveUserTag(
                                userId: userList[index].uid);

                            setState(() {
                              firstTime = true;
                            });
                          },
                          child: Text('remove user'),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Card(
                child: InkWell(
                  onTap: () async {
                    print(Provider.of<RecipeList>(context, listen: false)
                        .recipeList[index]['title']);

                    Provider.of<Recipe>(context, listen: false)
                        .addAllPropertiesFromDocument(
                            recipe:
                                Provider.of<RecipeList>(context, listen: false)
                                    .recipeList[index],
                            recipeID:
                                Provider.of<RecipeList>(context, listen: false)
                                    .recipeList[index]['recipeId']);

                    User user = Provider.of<User>(context, listen: false);
                    DatabaseService database = DatabaseService(uid: user.uid);

                    int myRating = await database.getYourRating(
                        recipeId:
                            Provider.of<RecipeList>(context, listen: false)
                                .recipeList[index]['recipeId'],
                        userId: user.uid);
                    Provider.of<Recipe>(context, listen: false)
                        .addYourRating(rating: myRating);
                    print(
                        Provider.of<Recipe>(context, listen: false).yourRating);

                    final popProvider =
                        Provider.of<Recipe>(context, listen: false);
                    final recipeListProvider =
                        Provider.of<RecipeList>(context, listen: false);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          //TODO fixa navigator till något bättre?
                          return ChangeNotifierProvider.value(
                            value: recipeListProvider,
                            child: ChangeNotifierProvider.value(
                                value: popProvider,
                                child: RecipePreview(
                                  preview: false,
                                  index: index,
                                )),
                          );
                          ;
                        },
                      ),
                    );
                    //ta rätt recept från recipeList och hämta ingredienserna
                    // skapa ett recipeobjekt och skicka till nästa sida
                    //skicka in recipeList[index] i en funktion och där göra ett nytt recipe
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Image(
                          image: NetworkImage(context
                                  .read<RecipeList>()
                                  .recipeList[index]['imageURL'] ??
                              'https://firebasestorage.googleapis.com/v0/b/independent-project-7edde.appspot.com/o/images%2F2020-05-08%2011%3A32%3A16.330607.png?alt=media&token=1e4bff1d-c08b-4afa-a1f3-a975e46e89c5'),
                        ),
                        title: Text(context.read<RecipeList>().recipeList[index]
                                ['title'] ??
                            '??'),
                        subtitle: Text(context
                                .read<RecipeList>()
                                .recipeList[index]['description'] ??
                            '??'),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              showRatingCibus(
                                  rating: context
                                          .read<RecipeList>()
                                          .recipeList[index]['averageRating'] ??
                                      0,
                                  imageHeight: 20.0),
                              Text(context
                                      .read<RecipeList>()
                                      .recipeList[index]['averageRating']
                                      .toStringAsPrecision(2)
                                      .toString() ??
                                  '??'),
                            ],
                          ),
                          SizedBox(width: 50),
                          Column(
                            children: <Widget>[
                              Text(context
                                      .read<RecipeList>()
                                      .recipeList[index]['time']
                                      .toString() ??
                                  '??'),
                              Text("minutes"),
                            ],
                          ),
                          RaisedButton(
                            onPressed: () {
                              database.adminRemoveRecipe(
                                  recipeId: context
                                      .read<RecipeList>()
                                      .recipeList[index]['recipeId']);

                              setState(() {
                                firstTime = true;
                              });
                            },
                            child: Text('remove recipe'),
                          ),
                          RaisedButton(
                            onPressed: () {
                              database.removeReportedRecipeTag(
                                  recipeId: context
                                      .read<RecipeList>()
                                      .recipeList[index]['recipeId']);

                              setState(() {
                                firstTime = true;
                              });
                            },
                            child: Text('remove tag'),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: Provider.of<RecipeList>(context).recipeCount,
          ),
        ),
      ],
    );
  }

  double roundForStars(double x) {
    // 2.1 => 2.5; 2.5 => 2.5; 2.6 => 3.0; 3.0 => 3.0;

    int xWhole = x.toInt();
    double xDecimal = x - xWhole;
    double decimalToAdd;
    if (xDecimal < 0.1) {
      decimalToAdd = 0.0;
    } else if (xDecimal <= 0.5) {
      decimalToAdd = 0.5;
    } else {
      decimalToAdd = 1.0;
    }
    return xWhole + decimalToAdd;
  }

  Widget showRatingCibus({double rating, double imageHeight}) {
    double roundedRating = roundForStars(rating);

    List<Widget> listOfCibus = List<Widget>();

    for (var i = 0; i < roundedRating.toInt(); i++) {
      Image star = Image(
        image: AssetImage("assets/cibus_filled.png"),
        height: imageHeight,
      );
      listOfCibus.add(star);
    }
    if (roundedRating - roundedRating.toInt() > 0.1) {
      // there should be a half cibus
      Image halfStar = Image(
        image: AssetImage("assets/cibus_filled_half.png"),
        height: imageHeight,
      );
      listOfCibus.add(halfStar);
    }
    return Row(children: listOfCibus);
  }
}
