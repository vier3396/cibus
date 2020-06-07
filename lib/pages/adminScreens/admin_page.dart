import 'package:cibus/pages/userScreens/user_page.dart';
import 'package:cibus/services/models/constants.dart';
import 'package:cibus/widgets/show_rating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cibus/services/models/recipe_list.dart';
import 'package:cibus/services/models/recipe.dart';
import 'package:cibus/services/models/user.dart';
import 'package:cibus/services/database/database.dart';
import 'package:cibus/widgets/recipe_preview.dart';

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
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    DatabaseService database = DatabaseService(uid: user.uid);
    getRecipes(firstTimeFunc: firstTime);
    getUsers(firstTimeFunc: firstTime);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Text(
              'reported users',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
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
                            SizedBox(
                              width: 10,
                            ),
                            Text('${userList[index].name}'),
                            SizedBox(
                              width: 10,
                            ),
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
                            SizedBox(
                              width: 10,
                            ),
                            RaisedButton(
                              onPressed: () {
                                database.adminRemoveUserTag(
                                    userId: userList[index].uid);

                                setState(() {
                                  firstTime = true;
                                });
                              },
                              child: Text('remove tag'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Text(
              'reported recipes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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
                                recipe: Provider.of<RecipeList>(context,
                                        listen: false)
                                    .recipeList[index],
                                recipeID: Provider.of<RecipeList>(context,
                                        listen: false)
                                    .recipeList[index]['recipeId']);

                        User user = Provider.of<User>(context, listen: false);
                        DatabaseService database =
                            DatabaseService(uid: user.uid);

                        int myRating = await database.getYourRating(
                            recipeId:
                                Provider.of<RecipeList>(context, listen: false)
                                    .recipeList[index]['recipeId'],
                            userId: user.uid);
                        Provider.of<Recipe>(context, listen: false)
                            .addYourRating(rating: myRating);
                        print(Provider.of<Recipe>(context, listen: false)
                            .yourRating);

                        final popProvider =
                            Provider.of<Recipe>(context, listen: false);
                        final recipeListProvider =
                            Provider.of<RecipeList>(context, listen: false);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return ChangeNotifierProvider.value(
                                value: recipeListProvider,
                                child: ChangeNotifierProvider.value(
                                    value: popProvider,
                                    child: RecipePreview(
                                      preview: false,
                                      index: index,
                                    )),
                              );
                            },
                          ),
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: Image(
                              image: NetworkImage(context
                                      .read<RecipeList>()
                                      .recipeList[index]['imageURL'] ??
                                  kDefaultRecipePic),
                            ),
                            title: Text(context
                                    .read<RecipeList>()
                                    .recipeList[index]['title'] ??
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
                                  ShowRating(
                                      rating: context
                                                  .read<RecipeList>()
                                                  .recipeList[index]
                                              ['averageRating'] ??
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
        ),
      ),
    );
  }
}
